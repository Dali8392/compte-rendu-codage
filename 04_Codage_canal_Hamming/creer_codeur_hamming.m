% Crée le modèle 'codeur_hamming'. Variables attendues dans le workspace de base :
%   uin     = [t u]    entrée série (m3 m2 m1 m0 0 0 0 par mot)
%   gate_in = [t g]    porte (1 1 1 1 0 0 0 par mot)
mdl = 'codeur_hamming';
if bdIsLoaded(mdl), close_system(mdl, 0); end
new_system(mdl); open_system(mdl);
LO = 'simulink/Logic and Bit Operations/Logical Operator';
DT = 'simulink/Signal Attributes/Data Type Conversion';
FW = 'simulink/Sources/From Workspace';
TW = 'simulink/Sinks/To Workspace';
UD = 'simulink/Discrete/Unit Delay';

% Entrées (boolean)
add_block(FW,[mdl '/Uin'],'VariableName','uin','SampleTime','1', ...
    'Interpolate','off','OutputAfterFinalValue','Holding final value');
add_block(DT,[mdl '/ConvU'],'OutDataTypeStr','boolean');
add_block(FW,[mdl '/Gate'],'VariableName','gate_in','SampleTime','1', ...
    'Interpolate','off','OutputAfterFinalValue','Holding final value');
add_block(DT,[mdl '/ConvG'],'OutDataTypeStr','boolean');

% f = (m XOR s2) AND g
add_block(LO,[mdl '/XORf'],'Operator','XOR','Inputs','2');
add_block(LO,[mdl '/ANDf'],'Operator','AND','Inputs','2');

% Registre : s0 <- f ; s1 <- s0 XOR f ; s2 <- s1
add_block(UD,[mdl '/D0'],'InitialCondition','0','SampleTime','1');
add_block(UD,[mdl '/D1'],'InitialCondition','0','SampleTime','1');
add_block(UD,[mdl '/D2'],'InitialCondition','0','SampleTime','1');
add_block(LO,[mdl '/XOR1'],'Operator','XOR','Inputs','2');

% Interrupteur : g=1 -> message, g=0 -> s2
add_block('simulink/Signal Routing/Switch',[mdl '/Sw'],'Criteria','u2 ~= 0');

% Sorties
add_block(DT,[mdl '/ConvOut'],'OutDataTypeStr','double');
add_block('simulink/Signal Routing/Mux',[mdl '/MuxS'],'Inputs','3');
add_block(DT,[mdl '/ConvS'],'OutDataTypeStr','double');
add_block(TW,[mdl '/Wc'],'VariableName','cout_sim','SaveFormat','Array');
add_block(TW,[mdl '/Ws'],'VariableName','S_sim','SaveFormat','Array');

add_line(mdl,'Uin/1','ConvU/1');   add_line(mdl,'Gate/1','ConvG/1');
add_line(mdl,'ConvU/1','XORf/1');  add_line(mdl,'D2/1','XORf/2');
add_line(mdl,'XORf/1','ANDf/1');   add_line(mdl,'ConvG/1','ANDf/2');
add_line(mdl,'ANDf/1','D0/1');
add_line(mdl,'D0/1','XOR1/1');     add_line(mdl,'ANDf/1','XOR1/2');
add_line(mdl,'XOR1/1','D1/1');
add_line(mdl,'D1/1','D2/1');
add_line(mdl,'ConvU/1','Sw/1');    add_line(mdl,'ConvG/1','Sw/2');   add_line(mdl,'D2/1','Sw/3');
add_line(mdl,'Sw/1','ConvOut/1');  add_line(mdl,'ConvOut/1','Wc/1');
add_line(mdl,'D0/1','MuxS/1');     add_line(mdl,'D1/1','MuxS/2');   add_line(mdl,'D2/1','MuxS/3');
add_line(mdl,'MuxS/1','ConvS/1');  add_line(mdl,'ConvS/1','Ws/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1','StopTime','112');
try, Simulink.BlockDiagram.arrangeSystem(mdl); end
save_system(mdl);