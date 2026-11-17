clear;
clc;
close all;
Parametres;
a = a_unif;
r = linspace(-A-a-0.3, A+a+0.3, 4000);
f1 = (abs(r-A)   <= a)/(2*a);       % f(r|1)
f0 = (abs(r+A)   <= a)/(2*a);       % f(r|0)

figure; hold on; grid on;
area(r, f0, 'FaceAlpha',0.3); area(r, f1, 'FaceAlpha',0.3);
if a > A
    xline(A-a,'k:'); xline(a-A,'k:');
    s_opt = a-A;                    % p1 < p0 : on décide 0 dans la zone de recouvrement
    xline(s_opt,'r-','s^*');
end
xlabel('r'); ylabel('densité'); legend('f(r|0)','f(r|1)');
title(sprintf('Bruit uniforme sur [-a,a], a = %.2f, A = %.1f', a, A));
fprintf('a = %.2f, A = %.1f -> zone de recouvrement [%.2f, %.2f]\n', a, A, A-a, a-A);
fprintf('p1 = %.2f < p0 : seuil optimal s* = a - A = %.2f\n', p1, a-A);