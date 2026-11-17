% Crée le modèle 'chaine_ham74'. Lancer Parametres avant.
% 1 tick = 1 échantillon canal. Bit codé : L ticks. Bit d'info : Tbi = 7L/4 ticks.
mdl = 'chaine_ham74';
if bdIsLoaded(mdl), close_system(mdl, 0); end
new_system(mdl); open_system(mdl);
clear ber_hamming_simulink                      % remet à zéro le cache du retard
assignin('base','dly',0);
DT  = 'simulink/Signal Attributes/Data Type Conversion';
TW  = 'simulink/Sinks/To Workspace';
GN  = 'simulink/Math Operations/Gain';
MFB = 'simulink/User-Defined Functions/MATLAB Function';
rt  = sfroot;
s1  = sprintf('%d', round(graine));             % graines numériques
s2  = sprintf('%d', round(graine)+1);

% Emetteur : bits d'information, période Tbi
add_block('simulink/Sources/Uniform Random Number',[mdl '/U'], ...
    'Minimum','0','Maximum','1','Seed',s1,'SampleTime','Tbi');
add_block('simulink/Sources/Constant',[mdl '/psrc'],'Value','0.5','SampleTime','Tbi');
add_block('simulink/Logic and Bit Operations/Relational Operator',[mdl '/Cmp'],'Operator','<');
add_block(DT,[mdl '/Conv'],'OutDataTypeStr','double');

% Codeur : Buffer(4) -> MATLAB Function -> Unbuffer
add_block('dspbuff3/Buffer',[mdl '/Buf4'],'N','4','V','0');
add_block(MFB,[mdl '/Enc74']);
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/Enc74']);
ch.Script = strjoin({ ...
    'function c = Enc74(m)', ...
    '%#codegen', ...
    'c = [m(1); m(2); m(3); m(4); ...', ...
    '     mod(m(1)+m(3)+m(4),2); ...', ...
    '     mod(m(1)+m(2)+m(3),2); ...', ...
    '     mod(m(2)+m(3)+m(4),2)];', ...
    'end'}, newline);
add_block('dspbuff3/Unbuffer',[mdl '/UnbC']);

% Niveaux +-a_c, répétition L fois, canal gaussien
add_block(GN,[mdl '/G2a'],'Gain','2*a_c');
add_block('simulink/Math Operations/Bias',[mdl '/Bia'],'Bias','-a_c');
add_block('simulink/Signal Attributes/Rate Transition',[mdl '/Rep'], ...
    'OutPortSampleTimeOpt','Specify','OutPortSampleTime','1', ...
    'Integrity','off','Deterministic','off');
add_block('simulink/Sources/Random Number',[mdl '/Bruit'], ...
    'Mean','0','Variance','sig2','Seed',s2,'SampleTime','1');
add_block('simulink/Math Operations/Add',[mdl '/Canal'],'Inputs','++');

% Détecteur : Buffer(L) -> moyenne + seuil nul
add_block('dspbuff3/Buffer',[mdl '/BufL'],'N','L','V','0');
add_block(MFB,[mdl '/Det']);
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/Det']);
ch.Script = strjoin({ ...
    'function b = Det(u)', ...
    '%#codegen', ...
    'b = double(mean(u(:)) > 0);', ...
    'end'}, newline);

% Recalage des mots : retard de dly bits codés (0..6)
add_block('simulink/Discrete/Integer Delay',[mdl '/Recal'], ...
    'NumDelays','dly','InitialCondition','0','SampleTime','L');

% Décodeur : Buffer(7) -> MATLAB Function -> Unbuffer
add_block('dspbuff3/Buffer',[mdl '/Buf7'],'N','7','V','0');
add_block(MFB,[mdl '/Dec74']);
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/Dec74']);
ch.Script = strjoin({ ...
    'function m = Dec74(y)', ...
    '%#codegen', ...
    's0 = mod(y(1)+y(3)+y(4)+y(5), 2);', ...
    's1 = mod(y(1)+y(2)+y(3)+y(6), 2);', ...
    's2 = mod(y(2)+y(3)+y(4)+y(7), 2);', ...
    'v  = 4*s0 + 2*s1 + s2;', ...
    'm  = y(1:4);', ...
    'if v == 6, m(1) = 1 - m(1); end', ...
    'if v == 3, m(2) = 1 - m(2); end', ...
    'if v == 7, m(3) = 1 - m(3); end', ...
    'if v == 5, m(4) = 1 - m(4); end', ...
    'end'}, newline);
add_block('dspbuff3/Unbuffer',[mdl '/UnbM']);

% Sorties
add_block(TW,[mdl '/Wtx'],'VariableName','btx_sim','SaveFormat','Array');
add_block(TW,[mdl '/Wrx'],'VariableName','brx_sim','SaveFormat','Array');

% Liaisons
add_line(mdl,'U/1','Cmp/1');       add_line(mdl,'psrc/1','Cmp/2');
add_line(mdl,'Cmp/1','Conv/1');    add_line(mdl,'Conv/1','Buf4/1');
add_line(mdl,'Buf4/1','Enc74/1');  add_line(mdl,'Enc74/1','UnbC/1');
add_line(mdl,'UnbC/1','G2a/1');    add_line(mdl,'G2a/1','Bia/1');
add_line(mdl,'Bia/1','Rep/1');
add_line(mdl,'Rep/1','Canal/1');   add_line(mdl,'Bruit/1','Canal/2');
add_line(mdl,'Canal/1','BufL/1');  add_line(mdl,'BufL/1','Det/1');
add_line(mdl,'Det/1','Recal/1');   add_line(mdl,'Recal/1','Buf7/1');
add_line(mdl,'Buf7/1','Dec74/1');  add_line(mdl,'Dec74/1','UnbM/1');
add_line(mdl,'Conv/1','Wtx/1');    add_line(mdl,'UnbM/1','Wrx/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1','StopTime','Nb*Tbi');
try, Simulink.BlockDiagram.arrangeSystem(mdl); end
save_system(mdl);