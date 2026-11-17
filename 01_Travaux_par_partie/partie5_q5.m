clear; clc; close all;
Parametres;
Nbq = 2e5;
dB = 0:9;  x = 10.^(dB/10);
q  = Q(sqrt(2*x));
thG = q;                      % Gray
thN = 1.5*q - q.^2;           % naturel

berG = zeros(size(dB)); berN = berG; sN = berG; eN = berG;
for i = 1:numel(dB)
    berG(i) = ber_qpsk_matlab(dB(i),'gray',false);
    berN(i) = ber_qpsk_matlab(dB(i),'naturel',false);
end
creer_chaine_qpsk('naturel');                     % efface aussi le retard mémorisé
for i = 1:numel(dB)
    [sN(i), eN(i)] = ber_qpsk_simulink(dB(i));
end

fprintf('EbN0 | Gray th.  | Gray sim  | Nat. th.  | Nat. sim  | Nat. Simulink (err) | Nat/Gray\n');
for i = 1:numel(dB)
    fprintf('%4d | %.2e | %.2e | %.2e | %.2e | %.2e (%d) | %.2f\n', ...
        dB(i), thG(i), berG(i), thN(i), berN(i), sN(i), eN(i), berN(i)/berG(i));
end

% Taux d'erreur symbole : identique pour les deux mappings (5 dB)
N = 2e6; b = double(rand(N,1) < 0.5); sg = sqrt(1/(4*10^0.5));
for mp = {'gray','naturel'}
    s  = qpsk_mod(b, mp{1});
    r  = s + sg*(randn(size(s)) + 1j*randn(size(s)));
    bh = qpsk_demod(r, mp{1});
    ser = mean(any(reshape(bh ~= b, 2, []), 1));
    fprintf('5 dB, %-8s : TES mesure = %.4f | theorie 1-(1-q)^2 = %.4f\n', ...
        mp{1}, ser, 1-(1-Q(sqrt(2*10^0.5)))^2);
end

% Ecart en dB à TEB = 1e-4
f  = @(d) Q(sqrt(2*10.^(d/10)));
dG = fzero(@(d) log10(f(d))              + 4, [4 12]);
dN = fzero(@(d) log10(1.5*f(d)-f(d).^2)  + 4, [4 12]);
fprintf('TEB 1e-4 : Gray %.2f dB | naturel %.2f dB | ecart %.2f dB\n', dG, dN, dN-dG);

figure; semilogy(dB, thG,'k-', dB, thN,'r-', dB, berG,'ko', dB, berN,'rs', dB, sN,'m*', 'LineWidth',1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('Gray (théorie)','naturel (théorie)','Gray (Matlab)','naturel (Matlab)','naturel (Simulink)', ...
       'Location','southwest');
title('QPSK : mapping de Gray contre mapping naturel');
creer_chaine_qpsk('gray');                         % remet le modèle Gray