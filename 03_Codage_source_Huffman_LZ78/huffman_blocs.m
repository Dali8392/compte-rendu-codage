function [code, p, long, Lbar] = huffman_blocs(ph, k)
%HUFFMAN_BLOCS  Code de Huffman de la k-ième extension d'une source binaire
%   Le bloc d'indice m (0..2^k-1) correspond à l'écriture binaire de m (MSB en tête).
%   Lbar : longueur moyenne par BLOC (à diviser par k pour avoir des bit/bit)
    M = 2^k;
    w = sum(dec2bin(0:M-1) - '0', 2);        % poids (nb de 1) de chaque bloc
    p = ph.^w .* (1-ph).^(k-w);              % probabilités des blocs
    [code, Lbar] = huffman_code(p);
    long = cellfun(@numel, code);
end