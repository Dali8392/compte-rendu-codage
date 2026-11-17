Parametres;

% Cas de l'énoncé
p_test = [0.4 0.2 0.2 0.1 0.1];
[code, Lbar] = huffman_code(p_test);
long  = cellfun(@numel, code);
Htest = -sum(p_test .* log2(p_test));
for k = 1:numel(p_test)
    fprintf('symbole %d  p = %.1f  mot = %s\n', k, p_test(k), code{k});
end
fprintf('Longueur moyenne = %.4f (attendu 2.2)\n', Lbar);
fprintf('Somme de Kraft   = %.4f (attendu 1)\n', sum(2.^(-long)));
fprintf('Code prefixe ?     %d\n', est_prefixe(code));
fprintf('H = %.4f <= L = %.4f < H+1 = %.4f\n', Htest, Lbar, Htest+1);

% Comparaison avec huffmandict (si Communications Toolbox)
if exist('huffmandict', 'file') == 2
    [~, Lh] = huffmandict(1:5, p_test);
    fprintf('huffmandict : longueur moyenne = %.4f\n', Lh);
end

% Test sur 1000 distributions aléatoires
ok = true;
for t = 1:1000
    M  = randi([2 40]);
    q  = rand(M,1); q = q/sum(q);
    [c, L] = huffman_code(q);
    H  = -sum(q.*log2(q));
    ok = ok && est_prefixe(c) && abs(sum(2.^(-cellfun(@numel,c))) - 1) < 1e-12 ...
            && L >= H - 1e-12 && L < H + 1;
end
fprintf('1000 tests aleatoires reussis : %d\n', ok);