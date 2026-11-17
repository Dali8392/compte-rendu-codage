clear;
clc;
close all;
Parametres;
N  = 1e6;
b  = source(N, p1);
y  = cbs(b, pe);
ber = mean(b ~= y);
ic  = 1.96*sqrt(ber*(1-ber)/N);
fprintf('pe = %.4f | TEB mesure = %.5f +/- %.5f (IC 95%%) | pe dans l''IC ? %d\n', ...
    pe, ber, ic, abs(ber-pe) <= ic);

% Le TEB ne dépend pas du bit émis
fprintf('P(erreur | 0) = %.4f | P(erreur | 1) = %.4f\n', ...
    mean(y(b==0)~=0), mean(y(b==1)~=1));

% Version Simulink
creer_cbs;
out = sim('cbs_sim');
tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));
ber_s = mean(tx ~= rx);
fprintf('Simulink : TEB = %.5f +/- %.5f\n', ber_s, 1.96*sqrt(ber_s*(1-ber_s)/numel(tx)));    