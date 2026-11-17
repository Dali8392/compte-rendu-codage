Parametres;
if ~bdIsLoaded('huffman_ext') && ~exist('huffman_ext.slx','file')
    creer_huffman_ext;
end
Nbits  = 1e5;
ph     = p1_ext;
ks     = 1:10;
Lk_sl  = zeros(size(ks));

for k = ks
    kk       = k;                                 % lu par le modèle
    poids    = 2.^(k-1:-1:0);                     % vecteur ligne 1xk
    [~, ~, long, Lbar] = huffman_blocs(ph, k);
    tab_long = long(:);                           % table des longueurs
    out = sim('huffman_ext');
    L   = out.long_blocs(:);
    L   = L(2:end);                               % 1er bloc = condition initiale du Buffer
    Lk_sl(k) = sum(L) / (numel(L)*k);
    fprintf('k=%2d | Simulink %.4f | theorie %.4f\n', k, Lk_sl(k), Lbar/k);
end

H = -ph*log2(ph) - (1-ph)*log2(1-ph);
figure; hold on; grid on;
plot(ks, Lk_sl, 'o-', 'LineWidth', 1.5);
plot(ks, H+1./ks, 'k:'); yline(H, 'r-');
xlabel('k'); ylabel('L_k/k'); title('Simulink : longueur moyenne par bit');
legend('Simulink', 'H+1/k', 'H');