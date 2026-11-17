function pairs = lz78_encode(seq)
%LZ78_ENCODE  seq : vecteur de symboles entiers (1..M)
%   pairs : matrice [indice_phrase_connue, symbole_ajoute]  (indice 0 = phrase vide)
    seq = seq(:);
    n = numel(seq);
    dict = containers.Map('KeyType','char','ValueType','double');
    pairs = zeros(n, 2);  np = 0;
    cur = 0;                      % indice de la phrase en cours (0 = vide)
    for t = 1:n
        key = sprintf('%d,%d', cur, seq(t));
        if isKey(dict, key)
            cur = dict(key);      % on prolonge la phrase connue
        else
            np = np + 1;
            pairs(np,:) = [cur, seq(t)];
            dict(key) = np;       % nouvelle phrase d'indice np
            cur = 0;
        end
    end
    if cur ~= 0                   % dernière phrase incomplète (déjà connue)
        % on la code comme (indice du préfixe, dernier symbole) : forme sans ambiguïté
        [~, last] = deal(0, seq(end));
        parent = 0;
        % retrouver le parent de cur
        ks = keys(dict);  vs = cell2mat(values(dict));
        k = ks{vs == cur};
        v = sscanf(k, '%d,%d');
        np = np + 1;  pairs(np,:) = [v(1), v(2)];
    end
    pairs = pairs(1:np, :);
end