function bits = huffman_encode(txt, sym, code)
%HUFFMAN_ENCODE  Texte -> vecteur ligne de bits (0/1)
    [~, idx] = ismember(txt(:), sym);
    mots = code(idx);
    bits = double([mots{:}] - '0');
end