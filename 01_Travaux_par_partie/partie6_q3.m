clear; clc; close all;
Parametres;
[h, ~] = rrc_coef(alpha, L, span);
N  = numel(h);
g  = conv(h, h);                                  % h * h : cosinus surélevé
c  = N;                                           % indice du maximum de g (t = 0)
k  = (-6:6);

fprintf('k | h(kT)      | (h*h)(kT)\n');
for kk = k
    hk = 0;  ih = (N+1)/2 + kk*L;
    if ih >= 1 && ih <= N, hk = h(ih); end
    fprintf('%2d | %+.5f   | %+.2e\n', kk, hk, g(c + kk*L));
end
fprintf('max |(h*h)(kT)|, k ~= 0 : %.2e (apres troncature a %d symboles)\n', ...
    max(abs(g(c + L*setdiff(-(span):span, 0)))), span);

% Tracés
figure;
subplot(2,1,1); stem((-span*L/2:span*L/2)/L, h, '.'); hold on; grid on;
stem((-span/2:span/2), h((N+1)/2 + L*(-span/2:span/2)), 'r', 'filled');
xlabel('t / T'); title('h : ne s''annule pas aux multiples de T');
subplot(2,1,2); plot((-(N-1):(N-1))/L, g, '.-'); hold on; grid on;
plot(-span:span, g(c + L*(-span:span)), 'ro', 'MarkerFaceColor','r');
xlabel('t / T'); title('h * h : nul aux multiples non nuls de T (cosinus surélevé)');

% Effet de la troncature
fprintf('\nspan | max |(h*h)(kT)|, k ~= 0\n');
for sp = [2 4 6 10 20]
    hh = rrc_coef(alpha, L, sp);  gg = conv(hh, hh);  cc = numel(hh);
    ks = setdiff(-sp:sp, 0);
    fprintf('%4d | %.2e\n', sp, max(abs(gg(cc + L*ks))));
end