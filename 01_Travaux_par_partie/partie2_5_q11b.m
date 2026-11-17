clear;
clc;
close all;
Parametres;
ph = p1_ext;
H  = -ph*log2(ph) - (1-ph)*log2(1-ph);
Ns = round(logspace(3, 6, 7));        % 1e3 ... 1e6
R  = zeros(size(Ns));
for j = 1:numel(Ns)
    b = source(Ns(j), ph) + 1;        % symboles 1 et 2
    pairs = lz78_encode(b);
    R(j)  = lz78_bits(pairs, 2) / Ns(j);
    fprintf('N = %7d | LZ78 = %.4f bit/bit | H = %.4f | ecart = %.4f\n', Ns(j), R(j), H, R(j)-H);
end

figure; semilogx(Ns, R, 'o-', 'LineWidth', 1.5); hold on;
yline(H, 'r-', 'LineWidth', 1.2); yline(1, 'Color',[.5 .5 .5], 'LineStyle','-.');
grid on; xlabel('longueur du message N (bits)'); ylabel('bit de code par bit de source');
title(sprintf('LZ78 sur source binaire (p_1 = %.2f)', ph));
legend('LZ78', 'entropie H', '1 bit/bit (sans codage)');