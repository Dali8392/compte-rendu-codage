clear;
clc;
close all;
M  = fliplr(dec2bin(0:15) - '0');            % 16 messages [m0 m1 m2 m3]
C  = hamming_encode(M);                      % codeur matriciel (référence)
Cs = [fliplr(C(:,1:4)), fliplr(C(:,5:7))];   % même mot, ordre d'émission

% (a) Registre simulé en Matlab pur
ok_reg = true;
for i = 1:16, ok_reg = ok_reg && isequal(codeur_registre(M(i,:)), Cs(i,:)); end
fprintf('Registre (Matlab) = codeur matriciel pour les 16 messages ? %d\n', ok_reg);

% (b) Modèle Simulink
U       = [fliplr(M), zeros(16,3)];          % ligne i : m3 m2 m1 m0 0 0 0
t       = (0:111)';
uin     = [t, reshape(U.', [], 1)];
gate_in = [t, repmat([1 1 1 1 0 0 0]', 16, 1)];
creer_codeur_hamming;
out  = sim('codeur_hamming');
cs   = out.cout_sim(1:112);
Cout = reshape(cs, 7, 16).';
fprintf('Simulink = codeur matriciel pour les 16 messages ? %d\n', isequal(Cout, Cs));

%(c) Table des états pour m = [1 0 1 1]
i = find(ismember(M, [1 0 1 1], 'rows'));
S = out.S_sim;                               % ligne k = état avant le coup k
fprintf('\nm = [1 0 1 1] -> entrée m3 m2 m1 m0 = 1 1 0 1, puis vidage\n');
fprintf('coup | entree | etat apres (s0 s1 s2) | sortie\n');
fprintf('   0 |        | 0 0 0\n');
for k = 1:7
    fprintf('%4d | %6d | %d %d %d                 | %d\n', ...
        k, U(i,k), S((i-1)*7+k+1,:), Cout(i,k));
end