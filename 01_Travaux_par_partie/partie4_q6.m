clear;
clc;
close all;
M = fliplr(dec2bin(0:15) - '0');
C = hamming_encode(M);

% Jeu de test : 0 erreur, 7 erreurs simples, 21 paires (x 16 messages)
Y = C;  Mref = M;  nerr = zeros(16,1);
for j = 1:7
    Z = C; Z(:,j) = 1 - Z(:,j);
    Y = [Y; Z]; Mref = [Mref; M]; nerr = [nerr; ones(16,1)];
end
for j1 = 1:6
    for j2 = j1+1:7
        Z = C; Z(:,[j1 j2]) = 1 - Z(:,[j1 j2]);
        Y = [Y; Z]; Mref = [Mref; M]; nerr = [nerr; 2*ones(16,1)];
    end
end
Yin = [(0:size(Y,1)-1)', Y];

% Référence Matlab et modèle Simulink
[Mh, ~, s] = hamming_decode(Y);
creer_decodeur_hamming(size(Y,1));
out = sim('hamming_dec');
mh_sim = out.mhat_sim;

fprintf('Simulink = decodeur Matlab sur les %d mots ? %d\n', size(Y,1), isequal(mh_sim, Mh));
fprintf('Syndromes identiques ? %d\n', isequal(out.synd_sim(:), s(:)));
fprintf('Drapeau = (syndrome ~= 0) ? %d\n', isequal(out.det_sim(:) > 0, s(:) ~= 0));
for ne = 0:2
    k = nerr == ne;
    fprintf('%d erreur(s) : message correct dans %.1f %% | detecte dans %.1f %%\n', ...
        ne, 100*mean(all(mh_sim(k,:) == Mref(k,:), 2)), 100*mean(out.det_sim(k) > 0));
end