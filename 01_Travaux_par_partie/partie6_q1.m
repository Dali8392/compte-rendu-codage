clear; clc; close all;
Parametres;
h  = ones(L,1)/sqrt(L);                          % filtre porte, énergie unité
ns = 5e4;  b = double(rand(2*ns,1) < 0.5);  s = qpsk_mod(b,'gray');

for dB = [0 4 8]
    sg = sqrt(1/(4*10^(dB/10)));
    [ys, ~, r] = chaine_filtree(s, h, L, sg, 0);
    % détecteur de la figure 3 : moyenne des L échantillons de chaque symbole
    zi = mean(reshape(r(1:L*ns), L, ns), 1).';
    b1 = qpsk_demod(ys, 'gray');                 % mise en forme + filtre adapté
    b2 = qpsk_demod(zi, 'gray');                 % intégrateur à remise à zéro
    fprintf('%d dB : decisions identiques ? %d | rapport ys/zi = %.4f (attendu sqrt(L)... )\n', ...
        dB, isequal(b1,b2), mean(real(ys)./real(zi)));
end

% TEB inchangé par rapport à la partie 5
dB = 0:9;  x = 10.^(dB/10);
th = Q(sqrt(2*x));  bf = zeros(size(dB));  bq = bf;
for i = 1:numel(dB)
    bf(i) = ber_filtre(dB(i), h, L, 0);
    bq(i) = ber_qpsk_matlab(dB(i), 'gray', false);       % QPSK au rythme symbole (partie 5)
end
fprintf('EbN0 | theorie  | filtre porte | partie 5\n');
for i = 1:numel(dB), fprintf('%4d | %.2e | %.2e     | %.2e\n', dB(i), th(i), bf(i), bq(i)); end
figure; semilogy(dB, th,'k-', dB, bf,'bo', dB, bq,'rs','LineWidth',1.2); grid on;
xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('théorie','porte + filtre adapté','partie 5 (sans filtre)','Location','southwest');
title('Filtre porte : TEB inchangé');