% partie5_q2.m : modulateur / démodulateur QPSK, validation Matlab et Simulink
clear; clc; close all;
Parametres;
Nbq = 2e4;                 % test rapide ; mets 2e5 pour le compte rendu

% (a) Matlab : modulation puis démodulation sans bruit
b = double(rand(2e5,1) < 0.5);
for mp = {'gray','naturel'}
    ok = isequal(qpsk_demod(qpsk_mod(b,mp{1}), mp{1}), b);
    fprintf('Matlab %-8s : demod(mod(b)) = b ? %d\n', mp{1}, ok);
end

% (b) Simulink sans bruit : retard mesuré, puis erreurs
creer_chaine_qpsk('gray');
[ber, ne, nb, d] = ber_qpsk_simulink(Inf);
fprintf('Simulink Gray, sans bruit : retard = %d bits | erreurs = %d sur %d bits\n', d, ne, nb);

% (c) Les symboles Simulink sont bien e^{jk pi/4}
assignin('base','sigq2',0);
o  = sim('chaine_qpsk_sim','StopTime','400');
sy = o.tx_sym(:);
sy = sy(3:end);                              % on saute les symboles initiaux du Buffer
k  = round(mod(angle(sy),2*pi)/(pi/4));
fprintf('Valeurs de k observees dans Simulink : %s | |s| = %.4f\n', ...
    num2str(unique(k).'), mean(abs(sy)));

% (d) Table des 4 couples de bits (mapping de Gray)
B = [0 0; 0 1; 1 0; 1 1];
fprintf('\nbits | k | symbole\n');
for i = 1:4
    s  = qpsk_mod(B(i,:), 'gray');
    kk = round(mod(angle(s),2*pi)/(pi/4));
    fprintf(' %d%d  | %d | %+.3f %+.3fj\n', B(i,1), B(i,2), kk, real(s), imag(s));
end