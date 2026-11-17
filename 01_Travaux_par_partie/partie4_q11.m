clear;
clc;
close all;
Parametres;
pU = @(d) Q(sqrt(2*10.^(d/10)));
pC = @(d) pb_hamming_exact(Q(sqrt(2*(4/7)*10.^(d/10))));

% Eb/N0 à partir duquel le codage est avantageux (croisement)
d_cross = fzero(@(d) pC(d) - pU(d), [4 8]);
fprintf('Le codage devient avantageux a partir de Eb/N0 = %.2f dB\n', d_cross);

% Gain de codage à TEB = 1e-4
cible = 1e-4;
dU = fzero(@(d) log10(pU(d)) - log10(cible), [5 12]);
dC = fzero(@(d) log10(pC(d)) - log10(cible), [5 12]);
fprintf('TEB = %.0e : sans codage %.2f dB | Hamming %.2f dB | gain de codage = %.2f dB\n', ...
        cible, dU, dC, dU - dC);

% Ecart à la limite de Shannon
R = 4/7;
lim_R = 10*log10((2^(2*R)-1)/(2*R));   lim_abs = 10*log10(log(2));
fprintf('Limite Shannon R=4/7 : %.2f dB | limite absolue : %.2f dB\n', lim_R, lim_abs);
fprintf('Ecart a Shannon (TEB 1e-4) : sans codage %.2f dB | Hamming %.2f dB (limite R=4/7)\n', ...
        dU - lim_R, dC - lim_R);
fprintf('Ecart a la limite absolue  : sans codage %.2f dB | Hamming %.2f dB\n', dU - lim_abs, dC - lim_abs);