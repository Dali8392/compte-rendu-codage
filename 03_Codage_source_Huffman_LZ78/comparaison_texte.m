function R = comparaison_texte(txt, nom)
%COMPARAISON_TEXTE  Bits par caractère pour plusieurs codages
    N = numel(txt);
    [H0, sym, p] = entropie_emp(txt);
    M = numel(sym);
    [code, Lbar] = huffman_code(p);
    H2 = entropie_paires(txt);

    % Fichier temporaire contenant le texte en UTF-8
    f = [tempname '.txt'];
    fid = fopen(f, 'w', 'n', 'UTF-8'); fwrite(fid, txt, 'char'); fclose(fid);
    d = dir(f); octets_src = d.bytes;

    % gzip (natif Matlab)
    gzip(f);  d = dir([f '.gz']);  bits_gz = 8*d.bytes;  delete([f '.gz']);

    % bzip2 et 7z (programmes externes, optionnels)
    bits_bz = NaN;  bits_7z = NaN;
    [st, ~] = system('bzip2 --version');
    if st == 0
        system(['bzip2 -k -9 "' f '"']); d = dir([f '.bz2']);
        bits_bz = 8*d.bytes;  delete([f '.bz2']);
    end
    [st, ~] = system('7z');
    if st == 0 || st == 7
        system(['7z a -t7z "' f '.7z" "' f '" -bso0 -bsp0']); d = dir([f '.7z']);
        if ~isempty(d), bits_7z = 8*d.bytes; delete([f '.7z']); end
    end
    delete(f);

    R.nom    = nom;   R.N = N;
    R.val    = [ceil(log2(M)), H0, Lbar, H2, bits_gz/N, bits_bz/N, bits_7z/N];
    R.noms   = {'Longueur fixe','H ordre 0','Huffman','H(X1X2)/2','gzip','bzip2','7z'};
    fprintf('\n--- %s (N = %d caracteres, %d octets UTF-8, M = %d) ---\n', nom, N, octets_src, M);
    for i = 1:numel(R.val)
        if ~isnan(R.val(i)), fprintf('%-14s : %.4f bit/car\n', R.noms{i}, R.val(i)); end
    end
end