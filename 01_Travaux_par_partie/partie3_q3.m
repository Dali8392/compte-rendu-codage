clear;
clc;
close all;
Parametres;
Hb = @(q) -q.*log2(q) - (1-q).*log2(1-q);
C  = @(q) 1 - Hb(q);

fprintf('pe = %.3f : H(pe) = %.4f | C = %.4f bit/bit\n', pe, Hb(pe), C(pe));

R = 4/7;
pe_max = fzero(@(q) Hb(q) - (1-R), [1e-6 0.5-1e-6]);   % C(pe_max) = R
fprintf('Rendement R = 4/7 = %.4f : transmission fiable possible si pe < %.4f\n', R, pe_max);
fprintf('Ton canal : C = %.4f %s R = %.4f -> fiable ? %d\n', C(pe), '>', R, C(pe) > R);

q = linspace(1e-6, 1-1e-6, 2000);
figure; plot(q, C(q), 'LineWidth', 1.5); hold on; grid on;
plot(pe, C(pe), 'ro', 'MarkerFaceColor','r');
yline(R, 'k--', 'R = 4/7');
xlabel('p_e'); ylabel('C [bit/utilisation]'); title('Capacité du canal binaire symétrique');
legend('C(p_e)', sprintf('p_e = %.3f', pe), 'Location','south');