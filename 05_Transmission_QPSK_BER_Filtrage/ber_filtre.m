function ber = ber_filtre(dB, h, L, shift)
%BER_FILTRE  TEB (QPSK de Gray) avec filtre de mise en forme h et filtre adapté, jusqu'à 100 erreurs
    x = 10^(dB/10);  sg = sqrt(1/(4*x));
    e = 0;  n = 0;  c = 4e4;
    while e < 100 && n < 4e6
        b  = double(rand(c,1) < 0.5);
        s  = qpsk_mod(b, 'gray');
        ys = chaine_filtree(s, h, L, sg, shift);
        bh = qpsk_demod(ys, 'gray');
        e  = e + sum(bh ~= b);  n = n + c;
    end
    ber = e/n;
end