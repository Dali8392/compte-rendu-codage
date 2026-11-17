Parametres;
txt = lire_texte(fichier_texte);
N   = numel(txt);
[H, sym, p] = entropie_emp(txt);
M   = numel(sym);
[code, Lbar] = huffman_code(p);
long = cellfun(@numel, code);

% Coût de la table
b_sym   = 8;                          % bits pour désigner un caractère
b_long  = ceil(log2(max(long)+1));    % bits pour coder une longueur de mot
C_naif  = sum(b_sym + b_long + long); % symbole + longueur + mot explicite
C_canon = M*(b_sym + b_long);         % code canonique : seules les longueurs sont envoyées
corps   = N*Lbar;                     % bits du texte codé
fprintf('M = %d symboles, longueur max = %d bits\n', M, max(long));
fprintf('Table explicite : %d bits | table canonique : %d bits\n', C_naif, C_canon);
fprintf('Corps du message : %.0f bits\n', corps);
fprintf('Surcout (table canonique) : %.2f %% du total\n', 100*C_canon/(C_canon+corps));

% Longueur de texte pour laquelle le coût devient négligeable
for eps_ = [0.01 0.001]
    Nmin = C_canon*(1-eps_)/(eps_*Lbar);
    fprintf('Surcout < %.1f %%  pour N > %.0f caracteres\n', 100*eps_, Nmin);
end
Nrent = C_canon/(8 - Lbar);
fprintf('Compression rentable (table incluse) des N > %.0f caracteres\n', Nrent);

% Courbe du surcoût en fonction de N
Ns   = logspace(2, 7, 200);
surc = 100*C_canon ./ (C_canon + Ns*Lbar);
figure; loglog(Ns, surc, 'LineWidth', 1.5); hold on;
loglog(N, 100*C_canon/(C_canon+corps), 'ro', 'MarkerFaceColor', 'r');
yline(1, '--k'); grid on;
xlabel('longueur du texte N (caracteres)'); ylabel('surcout de la table (% du total)');
title('Cout de transmission de la table de Huffman');
legend('surcout', sprintf('ton texte (N = %d)', N), '1 %');