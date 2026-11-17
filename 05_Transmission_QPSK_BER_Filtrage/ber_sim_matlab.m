function ber = ber_sim_matlab(dB, coded, A)
%BER_SIM_MATLAB  TEB sur bits d'information, canal gaussien + intégrateur, seuil nul
%   coded = true : Hamming (7,4), amplitude A*sqrt(4/7) ; false : sans codage.
%   Bruit après intégration : variance A^2/(2 Eb/N0) (Tb = 1).
    x  = 10^(dB/10);  sg = A/sqrt(2*x);
    e = 0;  n = 0;  c = 5e4;
    while e < 100 && n < 1e7
        b = double(rand(c,4) < 0.5);
        if coded
            C  = hamming_encode(b);
            y  = double(A*sqrt(4/7)*(2*C-1) + sg*randn(size(C)) > 0);
            Mh = hamming_decode(y);
        else
            Mh = double(A*(2*b-1) + sg*randn(size(b)) > 0);
        end
        e = e + sum(Mh(:) ~= b(:));
        n = n + numel(b);
    end
    ber = e/n;
end