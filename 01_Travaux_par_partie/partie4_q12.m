clear;
clc;
close all;
Parametres;
creer_chaine_hamming;
[~,~,~,d] = ber_hamming_simulink(30);
fprintf('Retard mesure dans le modele : %d bits d''information = %d Tb\n', d, d);
fprintf('Debit utile Rb = 1/Tb ; debit canal Rc = 7/(4 Tb) = %.2f Rb\n', 7/4);
fprintf('Energie par bit code : 10 log10(4/7) = %.2f dB\n', 10*log10(4/7));