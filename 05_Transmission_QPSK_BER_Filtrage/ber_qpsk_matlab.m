function ber = ber_qpsk_matlab(dB, mapping, coded)
%BER_QPSK_MATLAB  TEB sur les bits d'information, QPSK au rythme symbole, Es = 1
%   coded = true : Hamming (7,4) sur le flux continu, R = 4/7
    x = 10^(dB/10);
    if coded, R = 4/7; else, R = 1; end
    sg = sqrt(1/(4*R*x));                          % écart-type par voie
    e = 0; n = 0; c = 4e4;                         % c multiple de 8 : pas de bourrage
    while e < 100 && n < 2e7
        b = double(rand(c,1) < 0.5);
        if coded
            C  = hamming_encode(reshape(b,4,[]).');     % (c/4) x 7
            tx = reshape(C.', [], 1);                    % flux codé continu
            s  = qpsk_mod(tx, mapping);
            r  = s + sg*(randn(size(s)) + 1j*randn(size(s)));
            ty = qpsk_demod(r, mapping);
            Mh = hamming_decode(reshape(ty,7,[]).');
            bh = reshape(Mh.', [], 1);
        else
            s  = qpsk_mod(b, mapping);
            r  = s + sg*(randn(size(s)) + 1j*randn(size(s)));
            bh = qpsk_demod(r, mapping);
        end
        e = e + sum(bh ~= b);  n = n + c;
    end
    ber = e/n;
end