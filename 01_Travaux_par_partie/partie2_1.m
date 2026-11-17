Parametres;
disp(P)

% Fréquence empirique des 1 sur 1e5 bits
N      = 1e5;
b      = source(N, p1);
p1_hat = mean(b);
ic     = 1.96*sqrt(p1_hat*(1-p1_hat)/N);   % IC à 95 %
fprintf('p1 = %.3f | p1 estime = %.4f +/- %.4f (IC 95%%)\n', p1, p1_hat, ic);
fprintf('p1 dans l''IC ? %d\n', abs(p1_hat-p1) <= ic);

% Entropie binaire (avec 0*log2(0) = 0)
Hb = @(p) arrayfun(@(q) -(q>0)*q*log2(q+(q==0)) - (q<1)*(1-q)*log2(1-q+(q==1)), p);
H  = Hb(p1);
fprintf('H(p1) = %.4f bit/symbole\n', H);
fprintf('Debit d''information = %.4f bit/s (1 symbole/s)\n', H/Tb);

% trace de H(p)
p = linspace(0,1,1001);
figure; plot(p, Hb(p), 'LineWidth', 1.5); hold on;
plot(p1, H, 'ro', 'MarkerFaceColor', 'r');
grid on; xlabel('p'); ylabel('H(p) [bit/symbole]');
title('Entropie d''une source binaire');
legend('H(p)', sprintf('p_1 = %.2f', p1), 'Location', 'south');