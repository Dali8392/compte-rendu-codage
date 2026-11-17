clear;
clc;
close all;


nom = 'Mohamed ali mhadhbi';

P = parametres_perso(nom);

disp('Parametres personnels :');
disp(P);
N = 1e5;

bits = source(N, P.p1);

frequence_1 = mean(bits);

fprintf('p1 théorique     = %.4f\n', P.p1);
fprintf('p1 expérimental  = %.4f\n', frequence_1);