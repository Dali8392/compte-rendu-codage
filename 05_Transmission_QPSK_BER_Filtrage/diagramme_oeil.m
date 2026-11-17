function diagramme_oeil(y, L, N, voie, ntr)
%DIAGRAMME_OEIL  Diagramme de l'oeil (sur 2 durées symbole) d'une voie de la sortie y du filtre adapté
%   N : longueur du filtre ; l'instant optimal de décision est au centre (t = 0)
    if nargin < 5, ntr = 300; end
    if strcmp(voie,'I'), z = real(y); else, z = imag(y); end
    k0  = 12;                                        % on saute le régime transitoire
    idx = N + L*(k0:k0+ntr-1).';                     % instants de décision
    M   = idx + (-L:L);                              % 2L+1 échantillons autour de chaque instant
    t   = (-L:L)/L;
    plot(t, z(M).', 'Color', [0 0.3 0.8 0.25]); hold on; grid on;
    xline(0, 'r--');  xlabel('t / T'); ylabel(['voie ' voie]);
end