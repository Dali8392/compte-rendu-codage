function [h, hc] = rrc_coef(alpha, L, span)
%RRC_COEF  Coefficients du filtre en racine de cosinus surélevé (T = 1)
%   h  : coefficients normalisés à énergie unité (sum h^2 = 1), longueur span*L+1
%   hc : valeurs brutes de h_alpha(t) (avec 1/sqrt(T) = 1), avant normalisation
    t  = (-span*L/2 : span*L/2).'/L;
    hc = zeros(size(t));
    t0 = abs(t) < 1e-12;                                   % t = 0
    ts = abs(abs(t) - 1/(4*alpha)) < 1e-9 & ~t0;           % t = +-T/(4 alpha)
    nn = ~t0 & ~ts;
    tn = t(nn);
    hc(nn) = ((1-alpha)*sinc_(1-alpha, tn) + (4*alpha/pi)*cos(pi*(1+alpha)*tn)) ...
             ./ (1 - (4*alpha*tn).^2);
    hc(t0) = 1 - alpha + 4*alpha/pi;
    hc(ts) = (alpha/sqrt(2)) * ((1+2/pi)*sin(pi/(4*alpha)) + (1-2/pi)*cos(pi/(4*alpha)));
    h = hc / sqrt(sum(hc.^2));
end

function y = sinc_(a, t)
%  sinc(a t) = sin(pi a t)/(pi a t), avec sinc(0) = 1 (cas alpha = 1 : a = 0)
    x = a*t;  y = ones(size(x));  k = x ~= 0;
    y(k) = sin(pi*x(k))./(pi*x(k));
end