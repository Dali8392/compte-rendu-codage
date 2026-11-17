function b = qpsk_demod(r, mapping)
%QPSK_DEMOD  Décision par quadrant (signe de chaque voie) -> bits
    if nargin < 2, mapping = 'gray'; end
    r = r(:);
    switch mapping
        case 'gray'
            B = [real(r) < 0, imag(r) < 0];
        case 'naturel'
            I = real(r); Qd = imag(r);
            kq = zeros(size(r));                 % indice 0..3 = bits 00,01,10,11
            kq(I <  0 & Qd >= 0) = 1;
            kq(I <  0 & Qd <  0) = 2;
            kq(I >= 0 & Qd <  0) = 3;
            B = [floor(kq/2), mod(kq,2)];
        otherwise
            error('mapping inconnu');
    end
    b = reshape(double(B).', [], 1);
end