function [code, Lbar] = huffman_code(p)
%HUFFMAN_CODE  Code de Huffman binaire pour les probabilités p
%   code{i} : mot de code (chaîne de '0'/'1') du symbole i
%   Lbar    : longueur moyenne  sum(p .* longueurs)
    p = p(:) / sum(p);
    M = numel(p);
    if M == 1
        code = {'0'}; Lbar = 1; return;
    end
    code    = repmat({''}, M, 1);
    poids   = p;                    % poids des noeuds en cours
    membres = num2cell((1:M)');     % symboles-feuilles sous chaque noeud
    while numel(poids) > 1
        [~, ord] = sort(poids, 'ascend');
        i1 = ord(1);  i2 = ord(2);                % les deux moins probables
        for s = membres{i1}', code{s} = ['0' code{s}]; end
        for s = membres{i2}', code{s} = ['1' code{s}]; end
        poids(end+1,1)   = poids(i1) + poids(i2); % noeud fusionné
        membres{end+1,1} = [membres{i1}; membres{i2}];
        poids([i1 i2])   = [];
        membres([i1 i2]) = [];
    end
    Lbar = sum(p .* cellfun(@numel, code));
end