clear;
clc;
close all;
Parametres;
dB = 0:9;  x = 10.^(dB/10);
q  = Q(sqrt(2*x));              % bit non codé, énergie Eb
p  = Q(sqrt(2*(4/7)*x));        % bit codé, énergie Ec = 4/7 Eb
Pu = (1-q).^4;                  % bloc de 4 bits juste, sans codage
Pc = (1-p).^7 + 7*p.*(1-p).^6;  % bloc de 4 bits juste, avec codage

fprintf('EbN0(dB) |  q (sans) |  p (coude) | P_juste sans | P_juste avec\n');
for i = 1:numel(dB)
    fprintf('%8d | %.3e | %.3e | %.6f | %.6f\n', dB(i), q(i), p(i), Pu(i), Pc(i));
end

figure; semilogy(dB, 1-Pu, 'o-', dB, 1-Pc, 's-', 'LineWidth', 1.3); grid on;
xlabel('E_b/N_0 (dB)'); ylabel('probabilité de bloc faux (4 bits utiles)');
legend('sans codage', 'avec Hamming (7,4)', 'Location', 'southwest');
title('Probabilité qu''un bloc de 4 bits soit faux');