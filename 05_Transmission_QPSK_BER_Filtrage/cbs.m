function y = cbs(b, pe)
%CBS  Canal binaire symétrique : chaque bit est inversé avec la probabilité pe
    e = rand(size(b)) < pe;
    y = double(xor(b, e));
end