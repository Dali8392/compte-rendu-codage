function s = qpsk_mod(b, mapping)
%QPSK_MOD  Bits -> symboles complexes e^{jk pi/4}, Es = 1
%   mapping = 'gray' (défaut) ou 'naturel'. b : longueur paire.
    if nargin < 2, mapping = 'gray'; end
    B = reshape(b(:), 2, []).';                  % une ligne = (b1 b2)
    switch mapping
        case 'gray'                              % I <- b1, Q <- b2
            s = ((1-2*B(:,1)) + 1j*(1-2*B(:,2)))/sqrt(2);
        case 'naturel'                           % 00,01,10,11 -> k = 1,3,5,7
            k = 2*B(:,1) + B(:,2);
            s = exp(1j*(2*k+1)*pi/4);
        otherwise
            error('mapping inconnu');
    end
end