clear;
clc;
close all;
Parametres;
ps = logspace(-3, -0.8, 12);
Pa = pb_hamming_approx(ps);
Pe = pb_hamming_exact(ps);

% Simulation sur canal binaire symétrique
Pm = zeros(size(ps));
for i = 1:numel(ps)
    M  = double(rand(4e5, 4) < 0.5);
    C  = hamming_encode(M);
    Y  = cbs(C, ps(i));
    Mh = hamming_decode(Y);
    Pm(i) = mean(Mh(:) ~= M(:));
end

fprintf('      p     |  approx   |  exact    |  simule   | exact/approx\n');
for i = 1:numel(ps)
    fprintf('%.5f | %.3e | %.3e | %.3e | %.3f\n', ps(i), Pa(i), Pe(i), Pm(i), Pe(i)/Pa(i));
end
fprintf('Coefficient de p^2 : approx = 6, exact = 9 (limite exact/approx quand p -> 0 : 1.5)\n');

figure; loglog(ps, ps, 'k--', ps, Pa, 'b-', ps, Pe, 'r-', ps, Pm, 'go', 'LineWidth', 1.2);
grid on; xlabel('p (probabilité d''erreur par bit codé)'); ylabel('P_b');
legend('sans codage (P_b = p)', 'approximation', 'exact (énumération)', 'simulation', 'Location', 'southeast');
title('Probabilité d''erreur sur un bit d''information après décodage');