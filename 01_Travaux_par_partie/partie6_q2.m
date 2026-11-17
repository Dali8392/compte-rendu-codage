clear; clc; close all;
Parametres;
raw = @(a,t) ((1-a)*sin(pi*(1-a)*t)./(pi*(1-a)*t) + 4*a/pi*cos(pi*(1+a)*t)) ./ (1-(4*a*t).^2);
for a = unique([alpha 0.22 0.35])
    [h, hc] = rrc_coef(a, L, span);
    c  = (numel(h)+1)/2;                                  % indice de t = 0
    k4 = round(L/(4*a));                                  % indice de t = 1/(4 alpha) si entier
    lim0 = 1 - a + 4*a/pi;
    limS = (a/sqrt(2))*((1+2/pi)*sin(pi/(4*a)) + (1-2/pi)*cos(pi/(4*a)));
    fprintf('alpha = %.2f : h(0) = %.5f (formule %.5f, numerique %.5f)\n', a, hc(c), lim0, raw(a,1e-6));
    tt = 1/(4*a);
    fprintf('             h(1/(4a)) formule %.5f | numerique (t = 1/(4a) +- 1e-6) %.5f %.5f\n', ...
        limS, raw(a,tt+1e-6), raw(a,tt-1e-6));
end

% Comparaison avec la fonction de la Signal Processing / Communications Toolbox
[h, ~] = rrc_coef(alpha, L, span);
if exist('rcosdesign','file') == 2
    hr = rcosdesign(alpha, span, L, 'sqrt');
    fprintf('\nrcosdesign : ecart max avec rrc_coef = %.2e\n', max(abs(hr(:) - h)));
else
    disp('rcosdesign non disponible : comparaison ignoree.');
end

% Tracé
figure; stem((-span*L/2:span*L/2)/L, h, '.'); grid on;
xlabel('t / T'); ylabel('h[n]'); title(sprintf('Filtre RRC, \\alpha = %.2f, L = %d, span = %d', alpha, L, span));
fprintf('Energie sum(h^2) = %.6f | nombre de coefficients = %d\n', sum(h.^2), numel(h));