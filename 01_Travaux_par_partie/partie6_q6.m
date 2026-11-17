clear; clc; close all;
Parametres;
Nbq = 2e5;
ns = 4000;  b = double(rand(2*ns,1) < 0.5);  s = qpsk_mod(b,'gray');
alphas = [0.22 1];  dsh = L/4;
dB = 0:12;  x = 10.^(dB/10);  th = Q(sqrt(2*x));

figure('Position',[50 50 1200 800]);
res = zeros(2, numel(dB), 2);
for ia = 1:2
    h = rrc_coef(alphas(ia), L, span);  N = numel(h);

    % Oeil sans bruit, avec les deux instants
    [ys0, y] = chaine_filtree(s, h, L, 0, 0);
    subplot(3,4,(ia-1)*2+1); diagramme_oeil(y, L, N, 'I');
    xline(dsh/L, 'g--', 'T/4'); title(sprintf('oeil, \\alpha = %.2f', alphas(ia)));

    % Ouverture verticale de l'oeil aux deux instants (1 = idéal)
    [ysd] = chaine_filtree(s, h, L, 0, dsh);
    o0 = min(real(ys0).*sign(real(s)))*sqrt(2);
    o1 = min(real(ysd).*sign(real(s)))*sqrt(2);
    fprintf('alpha = %.2f : ouverture verticale : %.3f (optimal) | %.3f (decale de T/4)\n', alphas(ia), o0, o1);

    % Constellation à 15 dB, instant décalé
    sg = sqrt(1/(4*10^(15/10)));
    ys = chaine_filtree(s, h, L, sg, dsh);
    subplot(3,4,(ia-1)*2+2); plot(real(ys), imag(ys), '.', 'MarkerSize', 3); hold on;
    plot(real(exp(1j*(1:2:7)*pi/4)), imag(exp(1j*(1:2:7)*pi/4)), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    xline(0); yline(0); axis equal; grid on; xlim([-2 2]); ylim([-2 2]);
    title(sprintf('constellation 15 dB, decalage T/4, \\alpha = %.2f', alphas(ia)));

    % TEB
    for i = 1:numel(dB)
        res(ia,i,1) = ber_filtre(dB(i), h, L, 0);
        res(ia,i,2) = ber_filtre(dB(i), h, L, dsh);
    end
end
fprintf('EbN0 | th.       | a=0.22 opt | a=0.22 T/4 | a=1 opt   | a=1 T/4\n');
for i = 1:numel(dB)
    fprintf('%4d | %.2e | %.2e   | %.2e   | %.2e  | %.2e\n', dB(i), th(i), ...
        res(1,i,1), res(1,i,2), res(2,i,1), res(2,i,2));
end

subplot(3,4,[5 6 7 8 9 10 11 12]);
semilogy(dB, th,'k-', dB, squeeze(res(1,:,1)),'bo-', dB, squeeze(res(1,:,2)),'b^--', ...
         dB, squeeze(res(2,:,1)),'rs-', dB, squeeze(res(2,:,2)),'rv--', 'LineWidth',1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-6 1]);
legend('théorie','\alpha=0,22 optimal','\alpha=0,22, +T/4','\alpha=1 optimal','\alpha=1, +T/4','Location','southwest');
title('Sensibilité à l''erreur de synchronisation (T/4)');

% Point Simulink (RRC personnel, décalage T/4) à 8 dB
hcoef = rrc_coef(alpha, L, span);  assignin('base','hcoef',hcoef);
creer_chaine_filtree;
[b0, e0] = ber_filtre_simulink(8, 0);
[b1, e1] = ber_filtre_simulink(8, L/4);
fprintf('Simulink, alpha = %.2f, 8 dB : TEB optimal %.2e (%d err) | decale de T/4 : %.2e (%d err)\n', alpha, b0, e0, b1, e1);