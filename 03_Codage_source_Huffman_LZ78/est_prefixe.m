function ok = est_prefixe(code)
%EST_PREFIXE  Vrai si aucun mot de code n'est le début d'un autre
    ok = true;  M = numel(code);
    for i = 1:M
        for j = 1:M
            if i ~= j && strncmp(code{i}, code{j}, numel(code{i}))
                ok = false; return;
            end
        end
    end
end