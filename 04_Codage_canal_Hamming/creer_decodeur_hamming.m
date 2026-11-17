% Crée le modèle 'hamming_dec'. Variable attendue dans le workspace de base :
%   Yin = [t Y]   (Y : une ligne de 7 bits par période)
function creer_decodeur_hamming(npts)
    mdl = 'hamming_dec';
    if bdIsLoaded(mdl), close_system(mdl, 0); end
    new_system(mdl); open_system(mdl);
    LO = 'simulink/Logic and Bit Operations/Logical Operator';
    DT = 'simulink/Signal Attributes/Data Type Conversion';
    CC = 'simulink/Logic and Bit Operations/Compare To Constant';
    TW = 'simulink/Sinks/To Workspace';

    add_block('simulink/Sources/From Workspace',[mdl '/Yin'],'VariableName','Yin', ...
        'SampleTime','1','Interpolate','off','OutputAfterFinalValue','Holding final value');
    add_block(DT,[mdl '/ConvY'],'OutDataTypeStr','boolean');
    add_block('simulink/Signal Routing/Demux',[mdl '/Dm'],'Outputs','7');
    add_line(mdl,'Yin/1','ConvY/1');  add_line(mdl,'ConvY/1','Dm/1');

    % Syndromes : XOR à 4 entrées (parité), ports = indice du bit + 1
    ports = {[1 3 4 5], [1 2 3 6], [2 3 4 7]};
    add_block('simulink/Signal Routing/Mux',[mdl '/MuxS'],'Inputs','3');
    for s = 1:3
        nm = sprintf('S%d', s-1);
        add_block(LO,[mdl '/' nm],'Operator','XOR','Inputs','4');
        for q = 1:4
            add_line(mdl, sprintf('Dm/%d', ports{s}(q)), sprintf('%s/%d', nm, q));
        end
        add_line(mdl,[nm '/1'],sprintf('MuxS/%d', s));
    end
    add_block(DT,[mdl '/ConvS'],'OutDataTypeStr','double');
    add_block('simulink/Math Operations/Gain',[mdl '/GainV'],'Gain','[4 2 1]', ...
        'Multiplication','Matrix(K*u)');
    add_line(mdl,'MuxS/1','ConvS/1');  add_line(mdl,'ConvS/1','GainV/1');

    % Correction des 4 bits de message
    codes = [6 3 7 5];
    add_block('simulink/Signal Routing/Mux',[mdl '/MuxM'],'Inputs','4');
    for j = 0:3
        e = sprintf('E%d',j); x = sprintf('X%d',j); o = sprintf('O%d',j);
        add_block(CC,[mdl '/' e],'relop','==','const',num2str(codes(j+1)));
        add_block(LO,[mdl '/' x],'Operator','XOR','Inputs','2');
        add_block(DT,[mdl '/' o],'OutDataTypeStr','double');
        add_line(mdl,'GainV/1',[e '/1']);
        add_line(mdl,sprintf('Dm/%d',j+1),[x '/1']);
        add_line(mdl,[e '/1'],[x '/2']);
        add_line(mdl,[x '/1'],[o '/1']);
        add_line(mdl,[o '/1'],sprintf('MuxM/%d',j+1));
    end

    % Drapeau de détection
    add_block(CC,[mdl '/Det'],'relop','~=','const','0');
    add_block(DT,[mdl '/ConvDet'],'OutDataTypeStr','double');
    add_line(mdl,'GainV/1','Det/1'); add_line(mdl,'Det/1','ConvDet/1');

    add_block(TW,[mdl '/Wm'],'VariableName','mhat_sim','SaveFormat','Array');
    add_block(TW,[mdl '/Wd'],'VariableName','det_sim','SaveFormat','Array');
    add_block(TW,[mdl '/Wv'],'VariableName','synd_sim','SaveFormat','Array');
    add_line(mdl,'MuxM/1','Wm/1'); add_line(mdl,'ConvDet/1','Wd/1'); add_line(mdl,'GainV/1','Wv/1');

    set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
        'FixedStep','1','StopTime',num2str(npts-1));
    try, Simulink.BlockDiagram.arrangeSystem(mdl); end
    save_system(mdl);
end