clear;
clc;
close all;
Parametres;
dB = 0:9;  x = 10.^(dB/10);
q  = Q(sqrt(2*x));                      % sans codage
p  = Q(sqrt(2*(4/7)*x));                % codé, Ec = 4/7 Eb (comparaison honnête)
p_faux = q;                             % comparaison trompeuse : Ec = Eb

Pu   = q;
Pc_e = pb_hamming_exact(p);
Pc_a = pb_hamming_approx(p);
Pc_f = pb_hamming_exact(p_faux);

Ps_u = zeros(size(dB));  Ps_c = Ps_u;
for i = 1:numel(dB)
    Ps_u(i) = ber_sim_matlab(dB(i), false, A);
    Ps_c(i) = ber_sim_matlab(dB(i), true,  A);
end

figure; semilogy(dB, Pu, 'k-', dB, Pc_e, 'r-', dB, Pc_a, 'b--', dB, Pc_f, 'm:', ...
                 dB, Ps_u, 'ko', dB, Ps_c, 'r*', 'LineWidth', 1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('TEB'); ylim([1e-7 1]);
legend('sans codage (théorie)', 'Hamming exact, E_c = 4/7 E_b', 'Hamming approx', ...
       'comparaison trompeuse (E_c = E_b)', 'sans codage (simulé)', 'Hamming (simulé)', ...
       'Location', 'southwest');
title('Hamming (7,4) : comparaison à E_b fixé');

% Eb/N0 à partir duquel le codage devient avantageux
d  = 0:0.01:12;  xx = 10.^(d/10);
diff_ = pb_hamming_exact(Q(sqrt(2*(4/7)*xx))) - Q(sqrt(2*xx));
i0 = find(diff_(1:end-1) > 0 & diff_(2:end) <= 0, 1);
if ~isempty(i0), fprintf('Croisement des courbes vers Eb/N0 = %.2f dB\n', d(i0)); end
fprintf('Perte d''energie par bit code : 10 log10(7/4) = %.2f dB\n', 10*log10(7/4));