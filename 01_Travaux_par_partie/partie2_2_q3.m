Parametres;
txt = lire_texte(fichier_texte);
N   = numel(txt);

% Validation de la fonction sur la source binaire de la partie 2.1
b = source(1e5, p1);
Hb_th = -p1*log2(p1) - (1-p1)*log2(1-p1);
fprintf('Validation : H estimee = %.4f | H theorique = %.4f\n', entropie_emp(b), Hb_th);

% Statistiques du texte
[H, sym, p, cnt] = entropie_emp(txt);
M          = numel(sym);
nbits_fixe = ceil(log2(M));
fprintf('Fichier : %s\n', fichier_texte);
fprintf('Nombre de caracteres N = %d\n', N);
fprintf('Taille de l''alphabet M = %d\n', M);
fprintf('Entropie H = %.4f bit/caractere (max log2(M) = %.4f)\n', H, log2(M));
fprintf('Code de longueur fixe : %d bits/caractere\n', nbits_fixe);
fprintf('Redondance vs 8 bits  : %.4f bit/car = %.1f %%\n', 8-H, 100*(1-H/8));
fprintf('Redondance vs %d bits : %.4f bit/car = %.1f %%\n', nbits_fixe, nbits_fixe-H, 100*(1-H/nbits_fixe));

% Fréquences des caractères les plus fréquents
[ps, ord] = sort(p, 'descend');
K   = min(25, M);
lab = cell(K,1);
for k = 1:K
    c = sym(ord(k));
    if c == ' ',           lab{k} = 'esp';
    elseif c == char(10),  lab{k} = 'LF';
    else,                  lab{k} = c;
    end
end
figure; bar(ps(1:K));
set(gca, 'XTick', 1:K, 'XTickLabel', lab, 'TickLabelInterpreter', 'none');
grid on; xlabel('caractere'); ylabel('frequence');
title(sprintf('Les %d caracteres les plus frequents (N = %d)', K, N));