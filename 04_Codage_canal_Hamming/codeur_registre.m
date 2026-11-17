function c = codeur_registre(m)
%CODEUR_REGISTRE  Registre à décalage. m = [m0 m1 m2 m3]
%   Sortie série c = [m3 m2 m1 m0 r2 r1 r0]
    s = [0 0 0];  c = zeros(1,7);
    for t = 1:7
        if t <= 4, in = m(5-t); g = 1;
        else,      in = 0;      g = 0;
        end
        f = double(xor(in, s(3)) & g);
        c(t) = g*in + (1-g)*s(3);
        s = [f, double(xor(s(1), f)), s(2)];
    end
end