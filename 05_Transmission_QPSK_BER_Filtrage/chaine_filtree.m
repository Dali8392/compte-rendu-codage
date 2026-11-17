function [ys, y, r, tx] = chaine_filtree(s, h, L, sg, shift)
%CHAINE_FILTREE  Symboles -> suréchantillonnage x L -> filtre h -> bruit -> filtre adapté -> échantillonnage
%   s : symboles (colonne), h : coefficients (énergie unité), sg : écart-type du bruit par voie
%   shift : décalage de l'instant d'échantillonnage en échantillons (0 = optimal)
%   ys : un échantillon par symbole ; y : sortie du filtre adapté ; r : signal reçu ; tx : signal émis
    s = s(:);  h = h(:);  N = numel(h);  ns = numel(s);
    u = zeros(L*ns + N - 1, 1);              % on ajoute N-1 zéros pour vider les filtres
    u(1:L:L*ns) = s;                         % un symbole tous les L échantillons
    tx = filter(h, 1, u);                    % mise en forme
    r  = tx + sg*(randn(size(tx)) + 1j*randn(size(tx)));
    y  = filter(h, 1, r);                    % filtre adapté h(-t) (h est symétrique)
    idx = N + shift + L*(0:ns-1).';          % retard N-1 échantillons
    ys  = y(idx);
end