clear;
clc;
close all;
[G, H, P] = hamming_matrices();
disp('Restes x^3 m(x) mod g(x) = lignes de P :'); disp(P)
disp('G ='); disp(G)
disp('H ='); disp(H)
fprintf('G*H'' = 0 modulo 2 ? %d\n', ~any(any(mod(G*H.', 2))));

% Vérification : tous les mots-codes sont des multiples de g(x) (code cyclique)
g = [1 1 0 1];
M = dec2bin(0:15) - '0';                 % 16 messages (m3 m2 m1 m0 en lecture)
M = fliplr(M);                           % -> [m0 m1 m2 m3]
C = mod(M*G, 2);
ok = true;
for i = 1:16
    ok = ok && ~any(polymod2(C(i,:), g));   % c(x) mod g(x) = 0
end
fprintf('Les 16 mots-codes sont divisibles par g(x) ? %d\n', ok);