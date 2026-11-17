function [H2, nbpaires] = entropie_paires(seq)
%ENTROPIE_PAIRES  H(X1X2)/2 : entropie empirique des paires consécutives, par caractère
    seq = seq(:);
    [~, ~, idx] = unique(seq);                 % symboles -> indices 1..M
    M   = max(idx);
    pa  = idx(1:end-1) + (idx(2:end)-1)*M;     % indice de la paire
    cnt = accumarray(pa, 1);
    cnt = cnt(cnt > 0);
    p   = cnt / sum(cnt);
    H2  = -sum(p .* log2(p)) / 2;
    nbpaires = numel(cnt);
end