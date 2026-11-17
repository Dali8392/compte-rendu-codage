clear;
clc;
close all;
Parametres;
txt = lire_texte(fichier_texte);
[H0, sym] = entropie_emp(txt);
M = numel(sym);
[~, ~, idx] = unique(txt(:));

for n = [numel(txt), min(5000, numel(txt))]
    x = idx(1:n);
    pairs = lz78_encode(x);
    nb = lz78_bits(pairs, M);
    ok = isequal(lz78_decode(pairs), x);
    fprintf('N = %6d | couples = %5d | LZ78 = %.4f bit/car | H0 = %.4f | decodage OK : %d\n', ...
        n, size(pairs,1), nb/n, H0, ok);
end