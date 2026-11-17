function Pb = pb_hamming_exact(p)
%PB_HAMMING_EXACT  Probabilité exacte d'erreur sur un bit d'information (décodeur par syndrome)
%   Le code est linéaire : on peut supposer que le mot-code envoyé est nul.
    E  = fliplr(dec2bin(0:127) - '0');   % les 128 motifs d'erreur (une ligne = un motif)
    Mh = hamming_decode(E);              % message décodé = erreurs restantes sur les 4 bits
    W  = sum(E, 2);                      % poids du motif
    Mn = sum(Mh, 2);                     % nb de bits d'information faux après décodage
    Pb = zeros(size(p));
    for i = 1:numel(p)
        Pb(i) = sum(p(i).^W .* (1-p(i)).^(7-W) .* Mn) / 4;
    end
end