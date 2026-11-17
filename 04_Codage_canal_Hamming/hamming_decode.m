function [Mh, Ch, synd] = hamming_decode(Y)
%HAMMING_DECODE  Décodage par syndrome (correction d'une erreur)
%   Y    : matrice Nx7 de mots reçus (bits 0/1)
%   Mh   : Nx4 messages estimés, Ch : Nx7 mots-codes corrigés
%   synd : Nx1 valeur entière du syndrome (0 = aucune erreur détectée)
    [~, H] = hamming_matrices();
    S    = mod(Y*H.', 2);                    % syndromes, une ligne par mot
    synd = S * [4; 2; 1];                    % valeur entière 0..7
    tab  = zeros(8,1);                       % tab(synd+1) = position de l'erreur (0 = aucune)
    for j = 1:7
        tab(H(:,j).'*[4;2;1] + 1) = j;
    end
    pos = tab(synd + 1);
    Ch = Y;
    for n = find(pos).'
        Ch(n, pos(n)) = 1 - Ch(n, pos(n));   % on inverse le bit fautif
    end
    Mh = Ch(:, 1:4);
end