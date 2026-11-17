function [H, sym, p, cnt] = entropie_emp(seq)
%ENTROPIE_EMP  Entropie empirique (ordre 0) d'une séquence de symboles
%   sym : symboles distincts, cnt : effectifs, p : fréquences
    seq = seq(:);
    [sym, ~, idx] = unique(seq);
    cnt = accumarray(idx, 1);
    p   = cnt / sum(cnt);
    H   = -sum(p .* log2(p));     % p > 0 pour tous les symboles observés
end