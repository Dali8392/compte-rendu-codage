function Pb = pb_hamming_approx(p)
%PB_HAMMING_APPROX  Approximation de l'énoncé : somme_{j=2..7} (j/7) C(7,j) p^j (1-p)^(7-j)
    Pb = zeros(size(p));
    for j = 2:7
        Pb = Pb + (j/7)*nchoosek(7,j) * p.^j .* (1-p).^(7-j);
    end
end