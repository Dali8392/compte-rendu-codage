function Pe = pe_uniforme(s, A, a, p1)
%PE_UNIFORME  Probabilité d'erreur théorique, bruit uniforme, seuil s
    p0 = 1 - p1;
    clip = @(x) min(max(x, 0), 1);
    Pe = p0*clip((a - A - s)/(2*a)) + p1*clip((s - A + a)/(2*a));
end