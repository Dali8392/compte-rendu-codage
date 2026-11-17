clear;
clc;
close all;
M = fliplr(dec2bin(0:15) - '0');             % les 16 messages
C = hamming_encode(M);

% 1) Sans erreur
[Mh, ~, s] = hamming_decode(C);
fprintf('Sans erreur : messages retrouves ? %d | syndromes tous nuls ? %d\n', ...
    isequal(Mh, M), all(s == 0));

% 2) Une erreur simple à chacune des 7 positions, pour les 16 messages
ok = true;
for j = 1:7
    Y = C;  Y(:, j) = 1 - Y(:, j);
    [Mh, Ch, s] = hamming_decode(Y);
    ok_j = isequal(Mh, M) && isequal(Ch, C) && all(s ~= 0);
    fprintf('Erreur en position %d (bit %d) : corrigee pour les 16 messages ? %d\n', j, j-1, ok_j);
    ok = ok && ok_j;
end
fprintf('Toutes les erreurs simples corrigees ? %d\n', ok);

% 3) Deux erreurs : détectées (syndrome non nul) mais mal corrigées
nok = 0; ntot = 0;
for j1 = 1:6
    for j2 = j1+1:7
        Y = C;  Y(:,[j1 j2]) = 1 - Y(:,[j1 j2]);
        [Mh, ~, s] = hamming_decode(Y);
        nok  = nok + sum(all(Mh == M, 2));
        ntot = ntot + 16;
        assert(all(s ~= 0));                 % toujours détectées
    end
end
fprintf('Deux erreurs : syndrome toujours non nul, mais message juste dans %d/%d cas\n', nok, ntot);

% 4) Exemple détaillé
m = [1 0 1 1];
c = hamming_encode(m);          y = c;  y(3) = 1 - y(3);
[~, H] = hamming_matrices();
fprintf('m = %s -> c = %s\n', num2str(m,'%d'), num2str(c,'%d'));
fprintf('reçu y = %s (erreur en position 3) | syndrome = %s\n', ...
    num2str(y,'%d'), num2str(mod(y*H.',2),'%d'));
[mh, ch] = hamming_decode(y);
fprintf('corrigé = %s | message = %s\n', num2str(ch,'%d'), num2str(mh,'%d'));