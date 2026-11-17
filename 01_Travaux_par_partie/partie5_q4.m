clear; clc; close all;
Parametres;
Nbq = 2e5;
dB = 0:9;  x = 10.^(dB/10);
thB = Q(sqrt(2*x));                       % BPSK = chaîne de la partie 3
creer_chaine_qpsk('gray');

berB = zeros(size(dB)); berQ = berB; berS = berB; eS = berB;
for i = 1:numel(dB)
    N = 5e6;
    b = rand(N,1) < 0.5;
    r = (2*b-1) + sqrt(1/(2*x(i)))*randn(N,1);       % BPSK : Eb = 1, sigma^2 = N0/2
    berB(i) = mean((r > 0) ~= b);
    berQ(i) = ber_qpsk_matlab(dB(i), 'gray', false);
    [berS(i), eS(i)] = ber_qpsk_simulink(dB(i));
end
fprintf('EbN0 | theorie  | BPSK Matlab | QPSK Matlab | QPSK Simulink (erreurs)\n');
for i = 1:numel(dB)
    fprintf('%4d | %.2e | %.2e    | %.2e    | %.2e (%d)\n', dB(i), thB(i), berB(i), berQ(i), berS(i), eS(i));
end
disp('Points Simulink a moins de 100 erreurs : peu fiables.');

figure; semilogy(dB, thB, 'k-', dB, berB, 'bo', dB, berQ, 'rs', dB, berS, 'm*', 'LineWidth', 1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('théorie Q(\surd(2E_b/N_0))','BPSK (partie 3)','QPSK Gray (Matlab)','QPSK Gray (Simulink)', ...
       'Location','southwest');
title('QPSK de Gray contre BPSK, à E_b/N_0 égal');

fprintf('\nA duree de symbole T egale : BPSK Rb = 1/T | QPSK Rb = 2/T -> debit x2\n');
fprintf('A debit Rb egal : Ts(QPSK) = 2 Tb -> bande (1+alpha)/(2 Ts) divisee par 2\n');
fprintf('A Es/N0 egal, la QPSK perd 3 dB (Eb = Es/2) ; a Eb/N0 egal, TEB identique.\n');