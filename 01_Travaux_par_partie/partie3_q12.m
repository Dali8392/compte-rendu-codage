clear;
clc;
close all;
Parametres;
creer_chaine_base;                       % génère le modèle (une fois)
dB  = 0:1:9;
th  = Q(sqrt(2*10.^(dB/10)));            % TEB théorique avec intégration
th1 = Q(sqrt(2*10.^(dB/10)/L));          % TEB théorique sans intégration

% (a) Référence Matlab vectorisée : on simule jusqu'à >= 100 erreurs
rng(graine);
berM = zeros(size(dB)); ber1M = berM; nM = berM;
for i = 1:numel(dB)
    sg = sqrt(A^2*L/(2*10^(dB(i)/10)));
    e = 0; e1 = 0; n = 0;
    while (e < 100 || e1 < 100) && n < 2e7
        c  = 2e5;
        b  = rand(c,1) < 0.5;
        x  = A*(2*b-1);
        bruit = sg*randn(c, L);          % L échantillons de bruit par bit
        z  = x + mean(bruit, 2);         % intégrateur : moyenne sur le bit
        z1 = x + bruit(:, round(L/2));   % un seul échantillon
        e  = e  + sum((z  > 0) ~= b);
        e1 = e1 + sum((z1 > 0) ~= b);
        n  = n + c;
    end
    berM(i) = e/n;  ber1M(i) = e1/n;  nM(i) = n;
end

% (b) Simulation Simulink (Nb bits par point)
berS = zeros(size(dB)); ber1S = berS;
for i = 1:numel(dB)
    [berS(i), ber1S(i)] = ber_simulink(dB(i));
end

figure; semilogy(dB, th, 'k-', dB, berM, 'bo', dB, berS, 'r*', ...
                 dB, th1, 'k--', dB, ber1M, 'bs', dB, ber1S, 'm+', 'LineWidth', 1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('théorie Q(\surd(2E_b/N_0))', 'Matlab, intégrateur', 'Simulink, intégrateur', ...
       'théorie sans intégration', 'Matlab, 1 échantillon', 'Simulink, 1 échantillon', ...
       'Location', 'southwest');
title(sprintf('Chaîne de base, L = %d', L));

fprintf('Ecart d''Eb/N0 entre les deux courbes theoriques : 10 log10(L) = %.2f dB\n', 10*log10(L));