Parametres;
ph    = p1_ext;
H     = -ph*log2(ph) - (1-ph)*log2(1-ph);
Nbits = 1e5;
b     = source(Nbits, ph);                   % source très déséquilibrée
ks    = 1:10;

Lk_th = zeros(size(ks));  Lk_sim = Lk_th;  Lmax = Lk_th;  ok_dec = false(size(ks));
for k = ks
    [code, p, long, Lbar] = huffman_blocs(ph, k);
    Lk_th(k) = Lbar/k;                       % valeur théorique
    Lmax(k)  = max(long);

    % codage réel de 1e5 bits de source
    nb   = floor(Nbits/k);
    B    = reshape(b(1:nb*k), k, nb).';      % une ligne = un bloc de k bits
    idx  = B * 2.^(k-1:-1:0)' + 1;           % indice (1..2^k) du bloc
    sym  = (1:2^k)';
    bits = huffman_encode(idx, sym, code);   % flux binaire codé
    Lk_sim(k) = numel(bits) / (nb*k);

    %  décodage : on doit retrouver les blocs
    idx2 = huffman_decode(bits, code, sym);
    ok_dec(k) = isequal(idx2(:), idx(:));
end

% Tableau récapitulatif
fprintf('H = %.4f bit/bit  (p1_ext = %.2f)\n', H, ph);
fprintf(' k | 2^k  | Lmax | Lk/k theo | Lk/k simu | H+1/k  | decodage OK\n');
for k = ks
    fprintf('%2d | %4d | %4d | %.4f    | %.4f    | %.4f | %d\n', ...
        k, 2^k, Lmax(k), Lk_th(k), Lk_sim(k), H+1/k, ok_dec(k));
end
fprintf('Encadrement H <= Lk/k < H+1/k verifie ? %d\n', ...
    all(Lk_th >= H-1e-12 & Lk_th < H+1./ks));

% Courbe
figure; hold on; grid on;
plot(ks, Lk_th,  'o-',  'LineWidth', 1.5);
plot(ks, Lk_sim, 's--', 'LineWidth', 1.2);
plot(ks, H+1./ks, 'k:', 'LineWidth', 1.2);
yline(H, 'r-', 'LineWidth', 1.2);
yline(1, 'Color', [.5 .5 .5], 'LineStyle', '-.');
xlabel('k (bits par bloc)'); ylabel('longueur moyenne par bit de source');
title(sprintf('Huffman sur la k-ieme extension (p_1 = %.2f)', ph));
legend('L_k/k theorique', 'L_k/k simule (1e5 bits)', 'H + 1/k', 'H', ...
       '1 bit/bit (sans codage)', 'Location', 'northeast');
set(gca, 'XTick', ks);