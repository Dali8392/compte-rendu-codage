function b = source(N, p1)
%SOURCE  N bits indépendants, P(1) = p1
    b = double(rand(N,1) < p1);
end