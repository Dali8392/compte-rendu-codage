Parametres;
txt = lire_texte(fichier_texte);
N   = numel(txt);
[H, sym, p] = entropie_emp(txt);
M   = numel(sym);

[code, Lbar] = huffman_code(p);
fprintf('H = %.4f | Lbar = %.4f | efficacite H/Lbar = %.4f\n', H, Lbar, H/Lbar);
fprintf('H <= Lbar < H+1 ? %d\n', (H <= Lbar+1e-12) && (Lbar < H+1));

% Codage / décodage
bits = huffman_encode(txt, sym, code);
txt2 = huffman_decode(bits, code, sym);
fprintf('Texte restitue sans erreur ? %d\n', strcmp(txt, txt2));
fprintf('Nombre de bits = %d | longueur moyenne mesuree = %.4f\n', numel(bits), numel(bits)/N);

%Taux de compression
nbits_fixe = ceil(log2(M));
fprintf('Taux de compression vs 8 bits   : %.3f (gain %.1f %%)\n', 8*N/numel(bits), 100*(1-numel(bits)/(8*N)));
fprintf('Taux de compression vs %d bits  : %.3f (gain %.1f %%)\n', nbits_fixe, nbits_fixe*N/numel(bits), 100*(1-numel(bits)/(nbits_fixe*N)));