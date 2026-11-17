function nb = lz78_bits(pairs, M)
%LZ78_BITS  Nombre total de bits : sum_i ceil(log2 i) + ceil(log2 M)
    np = size(pairs,1);
    i  = (1:np)';
    nb = sum(ceil(log2(i))) + np*ceil(log2(M));
end