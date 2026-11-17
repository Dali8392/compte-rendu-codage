clear;
clc;
close all;
Parametres;
txt = lire_texte(fichier_texte);
[H, sym, p] = entropie_emp(txt);
[code, Lbar] = huffman_code(p);
bits = huffman_encode(txt, sym, code);
Nb   = numel(bits);

% Proportion de 1
p1s = mean(bits);
ic  = 1.96*sqrt(p1s*(1-p1s)/Nb);
fprintf('Nb bits = %d | proportion de 1 = %.4f +/- %.4f (IC 95%%)\n', Nb, p1s, ic);
fprintf('H(bit) = %.4f bit/bit\n', entropie_emp(bits));

% Entropie des paires de bits
H2b = entropie_paires(bits);          % H(B1B2)/2
fprintf('H(B1B2)/2 = %.4f bit/bit\n', H2b);

% Probabilités des 4 paires
pa  = bits(1:end-1)*2 + bits(2:end);
pp  = accumarray(pa(:)+1, 1, [4 1]) / numel(pa);
fprintf('Paires 00, 01, 10, 11 : %.4f %.4f %.4f %.4f (equiprobable = 0.25)\n', pp);

% Comparaison avec une source de Bernoulli(0.5) de même longueur
ref = source(Nb, 0.5);
fprintf('Reference Bernoulli(0.5) : p1 = %.4f | H(B1B2)/2 = %.4f\n', mean(ref), entropie_paires(ref));

% Corrélation entre bits voisins
r = corrcoef(bits(1:end-1), bits(2:end));
fprintf('Correlation entre bits consecutifs = %.4f\n', r(1,2));

figure; bar(pp); grid on;
set(gca, 'XTickLabel', {'00','01','10','11'}); yline(0.25, 'r--');
ylabel('probabilite'); title('Paires de bits en sortie du codeur de Huffman');