function txt = lire_texte(fichier)
%LIRE_TEXTE  Lit un fichier UTF-8 et rend un vecteur ligne de caractères
    txt = fileread(fichier, 'Encoding', 'UTF-8');
    txt = strrep(txt, char(13), '');      % supprime les retours chariot Windows
    txt(txt == char(65279)) = [];         % supprime un éventuel BOM
    txt = txt(:).';
end