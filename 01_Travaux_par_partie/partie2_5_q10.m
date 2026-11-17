clear;
clc;
close all;
% Validation sur ABAABABAABAB
s = 'ABAABABAABAB';
[sym, ~, idx] = unique(s(:));
pairs = lz78_encode(idx);
fprintf('Couples (indice, symbole) :\n');
for i = 1:size(pairs,1)
    if pairs(i,1)==0, ph = ''; else, ph = '?'; end
    fprintf('(%d,%s) ', pairs(i,1), sym(pairs(i,2)));
end
fprintf('\n');
attendu = [0 1; 0 2; 1 1; 2 1; 4 1; 4 2];   % A=1, B=2
fprintf('Conforme a l''enonce ? %d\n', isequal(pairs, attendu));

rec = sym(lz78_decode(pairs)).';
fprintf('Decodage = %s | identique ? %d\n', rec, strcmp(rec, s));
fprintf('Cout : %d bits pour %d symboles\n', lz78_bits(pairs, numel(sym)), numel(s));

% Test aléatoire (messages de fin quelconque)
ok = true;
for t = 1:200
    x = randi(3, randi([1 300]), 1);
    ok = ok && isequal(lz78_decode(lz78_encode(x)), x);
end
fprintf('200 tests aleatoires reussis : %d\n', ok);