clear;
clc;
close all;
Parametres;
N = 1e6;
b = source(N, p1);
r = A*(2*b - 1) + sigma*randn(N,1);

s_opt = sigma^2/(2*A)*log((1-p1)/p1);
ss    = sort([linspace(-1.5, 1.5, 61), s_opt]);
ber   = arrayfun(@(s) mean((r > s) ~= b), ss);
Pe    = @(s) (1-p1)*Q((s+A)/sigma) + p1*Q((A-s)/sigma);

figure; plot(ss, ber, 'o', ss, Pe(ss), '-', 'LineWidth', 1.2); hold on; grid on;
xline(s_opt, 'r--', 's^*'); xline(0, 'k:', 's = 0');
xlabel('seuil s'); ylabel('TEB'); legend('simulation', 'théorie');
title(sprintf('Bruit gaussien, \\sigma = %.2f', sigma));

[bmin, i0] = min(ber);
fprintf('s* theorique = %.4f | minimum simule en s = %.3f\n', s_opt, ss(i0));
fprintf('Pe(s*) = %.5f | Pe(0) = %.5f | gain = %.5f (%.1f %% relatif)\n', ...
    Pe(s_opt), Pe(0), Pe(0)-Pe(s_opt), 100*(Pe(0)-Pe(s_opt))/Pe(0));
fprintf('Simule : TEB(s*) = %.5f | TEB(0) = %.5f\n', mean((r>s_opt)~=b), mean((r>0)~=b));