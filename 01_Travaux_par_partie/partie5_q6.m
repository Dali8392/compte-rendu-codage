clear; clc; close all;
Parametres;
Nbq = 2e5;                                   % 2e4 pour tester vite
creer_chaine_qpsk_ham;
[~,~,~,d] = ber_qpsk_ham_simulink(30);
fprintf('Retard Hamming+QPSK : %d bits d''information (recalage dly = %d)\n', d, evalin('base','dly'));

dB = 0:9;  x = 10.^(dB/10);
thU  = Q(sqrt(2*x));                          % sans codage (QPSK Gray = BPSK)
thC  = pb_hamming_exact(Q(sqrt(2*(4/7)*x)));  % Hamming exact (partie 4)
berS = zeros(size(dB)); eS = berS; berM = berS; berUq = berS;
for i = 1:numel(dB)
    [berS(i), eS(i)] = ber_qpsk_ham_simulink(dB(i));
    berM(i)  = ber_qpsk_matlab(dB(i),'gray',true);
    berUq(i) = ber_qpsk_matlab(dB(i),'gray',false);
end
fprintf('EbN0 | Hamming th. | QPSK+Ham Matlab | QPSK+Ham Simulink (err) | QPSK sans codage\n');
for i = 1:numel(dB)
    fprintf('%4d | %.2e    | %.2e        | %.2e (%d)            | %.2e\n', ...
        dB(i), thC(i), berM(i), berS(i), eS(i), berUq(i));
end

figure; semilogy(dB, thU,'k-', dB, thC,'r-', dB, berUq,'ks', dB, berM,'r+', dB, berS,'m*', 'LineWidth',1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-7 1]);
legend('sans codage (théorie)','Hamming (théorie, partie 4)','QPSK sans codage', ...
       'QPSK + Hamming (Matlab)','QPSK + Hamming (Simulink)','Location','southwest');
title('QPSK avec Hamming (7,4), E_b/N_0 de l''information');

fprintf('\nDebit de symboles : BPSK sans codage 1/Tb | BPSK + Hamming 7/(4Tb) = 1.75/Tb | QPSK + Hamming 7/(8Tb) = 0.875/Tb\n');
fprintf('Bande QPSK+Hamming / bande BPSK sans codage = %.3f\n', 7/8);