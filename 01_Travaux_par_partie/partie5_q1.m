clear;
clc;
close all;
Parametres;
B = [0 0; 0 1; 1 0; 1 1];
for mp = {'gray','naturel'}
    mp = mp{1};
    s = zeros(4,1);
    for i = 1:4, s(i) = qpsk_mod(B(i,:), mp); end
    k = round(mod(angle(s), 2*pi)/(pi/4));           % 1,3,5,7
    fprintf('\nMapping %s\n bits |  k |   I      Q\n', mp);
    for i = 1:4
        fprintf('  %d%d  | %d  | %+.3f %+.3f\n', B(i,1), B(i,2), k(i), real(s(i)), imag(s(i)));
    end
    [~, o] = sort(k);                                % ordre autour du cercle
    d = zeros(4,1);
    for i = 1:4
        d(i) = sum(B(o(i),:) ~= B(o(mod(i,4)+1),:)); % distance de Hamming entre voisins
    end
    fprintf('Distances de Hamming entre symboles voisins : %s\n', num2str(d.'));
end

% Indépendance des voies (Gray)
s = zeros(4,1); for i = 1:4, s(i) = qpsk_mod(B(i,:),'gray'); end
fprintf('\nGray : I = (1-2 b1)/sqrt2 ? %d | Q = (1-2 b2)/sqrt2 ? %d\n', ...
    all(abs(real(s) - (1-2*B(:,1))/sqrt(2)) < 1e-12), ...
    all(abs(imag(s) - (1-2*B(:,2))/sqrt(2)) < 1e-12));

% Energies
b = source(1e5,0.5);  s = qpsk_mod(b,'gray');
Es_mes = mean(abs(s).^2);
fprintf('Es = %.4f | Eb = Es/2 = %.4f | amplitude par voie = %.4f = sqrt(Eb)\n', ...
    Es_mes, Es_mes/2, sqrt(Es_mes/2));