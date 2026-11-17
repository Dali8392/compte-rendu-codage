function C = hamming_encode(M)
%HAMMING_ENCODE  M : matrice Nx4 de messages (une ligne = [m0 m1 m2 m3]) -> C : Nx7
    [G, ~] = hamming_matrices();
    C = mod(M*G, 2);
end