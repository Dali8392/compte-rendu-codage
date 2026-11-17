function seq = lz78_decode(pairs)
%LZ78_DECODE  Reconstruit la séquence à partir des couples
    np = size(pairs,1);
    phr = cell(np,1);
    out = cell(np,1);
    for i = 1:np
        if pairs(i,1) == 0, pre = [];
        else,               pre = phr{pairs(i,1)};
        end
        phr{i} = [pre; pairs(i,2)];
        out{i} = phr{i};
    end
    seq = vertcat(out{:});
end