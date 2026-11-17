clear; clc; close all;
Parametres;
Nbq = 2e5;
hP = ones(L,1)/sqrt(L);
[hR, ~] = rrc_coef(alpha, L, span);  N = numel(hR);
ns = 6000;  b = double(rand(2*ns,1) < 0.5);  s = qpsk_mod(b,'gray');
ideal = exp(1j*(1:2:7)*pi/4);

% Constellations et oeil
figure('Position',[50 50 1200 700]);
for ifil = 1:2
    if ifil == 1, h = hP; nom = 'porte'; else, h = hR; nom = sprintf('RRC \\alpha = %.2f', alpha); end
    Nh = numel(h);
    for jd = 1:2
        dBc = [5 10];  sg = sqrt(1/(4*10^(dBc(jd)/10)));
        ys = chaine_filtree(s, h, L, sg, 0);
        subplot(3,4,(ifil-1)*4 + jd); plot(real(ys), imag(ys), '.', 'MarkerSize', 3); hold on;
        plot(real(ideal), imag(ideal), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
        xline(0); yline(0); axis equal; grid on; xlim([-2 2]); ylim([-2 2]);
        title(sprintf('%s, %d dB', nom, dBc(jd)));
    end
    [~, y] = chaine_filtree(s, h, L, 0, 0);                 % oeil sans bruit
    subplot(3,4,(ifil-1)*4 + 3); diagramme_oeil(y, L, Nh, 'I'); title(['oeil I, ' nom ', sans bruit']);
    [~, y] = chaine_filtree(s, h, L, sqrt(1/(4*10^(15/10))), 0);   % oeil à 15 dB
    subplot(3,4,(ifil-1)*4 + 4); diagramme_oeil(y, L, Nh, 'I'); title(['oeil I, ' nom ', 15 dB']);
end

% TEB : théorie, Matlab porte, Matlab RRC
dB = 0:9;  x = 10.^(dB/10);  th = Q(sqrt(2*x));
bP = zeros(size(dB)); bR = bP;
for i = 1:numel(dB)
    bP(i) = ber_filtre(dB(i), hP, L, 0);
    bR(i) = ber_filtre(dB(i), hR, L, 0);
end

% TEB : Simulink (RRC)
hcoef = hR;  assignin('base','hcoef',hcoef);  assignin('base','phs',0);
creer_chaine_filtree;
bS = zeros(size(dB)); eS = bS;
for i = 1:numel(dB), [bS(i), eS(i)] = ber_filtre_simulink(dB(i), 0); end

fprintf('EbN0 | theorie  | porte    | RRC Matlab | RRC Simulink (erreurs)\n');
for i = 1:numel(dB)
    fprintf('%4d | %.2e | %.2e | %.2e   | %.2e (%d)\n', dB(i), th(i), bP(i), bR(i), bS(i), eS(i));
end
disp('Points Simulink a moins de 100 erreurs : peu fiables.');

subplot(3,4,[9 10 11 12]);
semilogy(dB, th,'k-', dB, bP,'bo', dB, bR,'rs', dB, bS,'m*', 'LineWidth',1.2); grid on;
xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('théorie Q(\surd(2E_b/N_0))','porte','RRC (Matlab)','RRC (Simulink)','Location','southwest');
title('TEB avec filtre de mise en forme et filtre adapté');