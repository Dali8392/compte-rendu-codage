function [f, P] = psd_moy(x, nfft, L)
%PSD_MOY  Densité spectrale (périodogrammes fenêtrés moyennés). f en unités de 1/T
    x = x(:);  w = 0.5 - 0.5*cos(2*pi*(0:nfft-1).'/nfft);     % fenêtre de Hann
    nseg = floor(numel(x)/nfft);  P = zeros(nfft,1);
    for k = 1:nseg
        seg = x((k-1)*nfft+1 : k*nfft) .* w;
        P = P + abs(fft(seg)).^2;
    end
    P = fftshift(P/nseg);
    f = (-nfft/2 : nfft/2-1).'/nfft * L;
end