clear;
clc;
close all;
Parametres;
txt = lire_texte(fichier_texte);

R1 = comparaison_texte(txt, 'Texte complet');
R2 = comparaison_texte(txt(1:min(5000,numel(txt))), '5000 premiers caracteres');

% Histogramme comparatif
figure;
V = [R1.val(:), R2.val(:)];
bar(V); grid on;
set(gca, 'XTickLabel', R1.noms);
ylabel('bit par caractere');
title('Codages du texte : effet de la memoire et de la longueur');
legend(sprintf('N = %d', R1.N), sprintf('N = %d', R2.N), 'Location', 'northeast');