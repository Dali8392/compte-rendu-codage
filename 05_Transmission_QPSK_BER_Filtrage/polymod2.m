function r = polymod2(a, g)
%POLYMOD2  Reste de la division de a(x) par g(x) dans GF(2)[x]
%   a, g : vecteurs en puissances croissantes. r : deg(g) coefficients.
    a = mod(a(:).', 2);  g = mod(g(:).', 2);
    dg = numel(g) - 1;
    for i = numel(a):-1:dg+1
        if a(i) == 1
            a(i-dg:i) = xor(a(i-dg:i), g);
        end
    end
    r = a(1:dg);
end