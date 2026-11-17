Parametres;
out   = sim('source_bin');
b_sim = out.bits_sim(:);
fprintf('Simulink : %d bits, p1 estime = %.4f (p1 = %.2f)\n', ...
    numel(b_sim), mean(b_sim), p1);