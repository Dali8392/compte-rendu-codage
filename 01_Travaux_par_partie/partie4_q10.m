clear;
clc;
close all;
Parametres;
creer_chaine_base;                   % chaîne sans codage (partie 3)
creer_chaine_hamming;                % chaîne avec codage

% Validation sans bruit
assignin('base','sig2',0);
o = sim('chaine_hamming','StopTime',num2str(2000*Tbi));
[~,~,~,d] = ber_hamming_simulink(30);          % 30 dB : quasi sans bruit
fprintf('Retard de la chaine codee : %d bits d''information (%.1f Tb)\n', d, d);

% Courbes
dB = 0:9;   x = 10.^(dB/10);
berU = zeros(size(dB)); berC = berU; eU = berU; eC = berU; nU = berU; nC = berU;
for i = 1:numel(dB)
    [berU(i), ~, eU(i), nU(i)] = ber_simulink(dB(i));          % sans codage (Simulink)
    [berC(i), eC(i), nC(i)]    = ber_hamming_simulink(dB(i));  % avec codage (Simulink)
end
berUm = arrayfun(@(v) ber_sim_matlab(v,false,A), dB);          % références Matlab (>=100 erreurs)
berCm = arrayfun(@(v) ber_sim_matlab(v,true, A), dB);

fprintf('EbN0 | sans codage: erreurs / TEB | avec codage: erreurs / TEB\n');
for i = 1:numel(dB)
    fprintf('%4d | %7d / %.2e %s | %7d / %.2e %s\n', dB(i), eU(i), berU(i), ...
        char(32+10*(eU(i)<100)), eC(i), berC(i), char(32+10*(eC(i)<100)));
end
disp('(* = moins de 100 erreurs : point peu fiable)');

% Théorie et limites de Shannon
dd  = -2:0.05:9;  xx = 10.^(dd/10);
thU = Q(sqrt(2*xx));
thC = pb_hamming_exact(Q(sqrt(2*(4/7)*xx)));
thA = pb_hamming_approx(Q(sqrt(2*(4/7)*xx)));
R   = 4/7;
lim_R   = 10*log10((2^(2*R)-1)/(2*R));      % ~ 0.24 dB
lim_abs = 10*log10(log(2));                 % -1.59 dB

figure; semilogy(dd, thU, 'k-', dd, thC, 'r-', dd, thA, 'b--', 'LineWidth', 1.2); hold on;
semilogy(dB, berU,  'ko', dB, berC,  'r*', dB, berUm, 'ks', dB, berCm, 'r+');
xline(lim_R,   'g-',  sprintf('Shannon R=4/7 : %.2f dB', lim_R),  'LabelVerticalAlignment','bottom');
xline(lim_abs, 'm-',  sprintf('limite absolue : %.2f dB', lim_abs), 'LabelVerticalAlignment','bottom');
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-7 1]); xlim([-2 9]);
legend('théorie sans codage','théorie Hamming (exacte)','théorie Hamming (approx.)', ...
       'Simulink sans codage','Simulink Hamming','Matlab sans codage','Matlab Hamming', ...
       'Location','southwest');
title(sprintf('Chaîne avec et sans Hamming (7,4), L = %d', L));