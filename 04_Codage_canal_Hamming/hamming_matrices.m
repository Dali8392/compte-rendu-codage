function [G, H, P] = hamming_matrices()
%HAMMING_MATRICES  Matrices systématiques du code cyclique (7,4), g(x) = 1 + x + x^3
    g = [1 1 0 1];
    P = zeros(4,3);
    for i = 1:4
        m = zeros(1,4);  m(i) = 1;                % message de poids 1 : x^(i-1)
        P(i,:) = polymod2([0 0 0 m], g);          % reste de x^3 m(x)
    end
    G = [eye(4), P];
    H = [P.', eye(3)];
end