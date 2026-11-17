clear;
clc;
close all;
Parametres;
a = a_unif;  N = 1e6;
b = source(N, p1);
x = A*(2*b - 1);
r = x + a*(2*rand(N,1) - 1);              % bruit uniforme sur [-a, a]

ss = sort([linspace(-a-A-0.2, a+A+0.2, 61), a-A]);
ber = zeros(size(ss));
for i = 1:numel(ss)
    ber(i) = mean((r > ss(i)) ~= b);
end
th = pe_uniforme(ss, A, a, p1);

figure; plot(ss, ber, 'o', ss, th, '-', 'LineWidth', 1.2); hold on; grid on;
xline(a-A, 'r--', 's^*');
xlabel('seuil s'); ylabel('TEB'); legend('simulation', 'théorie');
title('Bruit uniforme : TEB en fonction du seuil');

[bmin, i0] = min(ber);
fprintf('Seuil optimal simule : s = %.3f (TEB = %.5f) | theorie : s* = %.3f\n', ss(i0), bmin, a-A);
fprintf('Pe theorique en s*   = %.5f | en s = 0 : %.5f (simule %.5f)\n', ...
    pe_uniforme(a-A,A,a,p1), pe_uniforme(0,A,a,p1), mean((r>0)~=b));