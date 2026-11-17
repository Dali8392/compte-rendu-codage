clear;
clc;
close all;
[G, H] = hamming_matrices();
cols = H.';                                       % une ligne = une colonne de H
fprintf('Colonnes non nulles ? %d\n', all(any(cols,2)));
fprintf('Colonnes distinctes ? %d\n', size(unique(cols,'rows'),1) == 7);

% Distance minimale par énumération des 16 mots-codes
M = fliplr(dec2bin(0:15) - '0');
C = mod(M*G, 2);
poids = sum(C, 2);
dmin = min(poids(poids > 0));
fprintf('Distance minimale = %d\n', dmin);
fprintf('Detection : %d erreurs | Correction : %d erreur\n', dmin-1, floor((dmin-1)/2));

% Distribution des poids (code de Hamming : 1 mot de poids 0, 7 de poids 3, 7 de poids 4, 1 de poids 7)
disp('Poids des mots-codes (poids : effectif) :'); disp([(0:7).', histcounts(poids, -0.5:1:7.5).'])

% Code parfait : les 7 erreurs simples donnent 7 syndromes distincts non nuls
S = mod(eye(7)*H.', 2);
fprintf('Syndromes des 7 erreurs simples tous distincts et non nuls ? %d\n', ...
    size(unique(S,'rows'),1)==7 && all(any(S,2)));