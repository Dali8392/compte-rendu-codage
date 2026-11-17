function txt = huffman_decode(bits, code, sym)
%HUFFMAN_DECODE  Bits -> texte, par parcours d'un arbre binaire (tableaux)
    fils = [0 0];  nn = 1;            % fils(n,b+1) : noeud suivant ou -(indice feuille)
    for s = 1:numel(code)
        n = 1;  w = code{s};
        for k = 1:numel(w)
            b = w(k) - '0' + 1;
            if k == numel(w)
                fils(n,b) = -s;                    % feuille
            else
                if fils(n,b) == 0
                    nn = nn + 1;  fils(nn,:) = [0 0];  fils(n,b) = nn;
                end
                n = fils(n,b);
            end
        end
    end
    out = zeros(1, numel(bits));  m = 0;  n = 1;
    for i = 1:numel(bits)
        nxt = fils(n, bits(i)+1);
        if nxt < 0
            m = m + 1;  out(m) = -nxt;  n = 1;     % feuille atteinte : on émet le symbole
        else
            n = nxt;
        end
    end
    sym = sym(:);
    txt = sym(out(1:m)).';
end