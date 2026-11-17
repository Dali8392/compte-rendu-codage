clear; clc; close all;
Parametres;
ns = 4e4;  b = double(rand(2*ns,1) < 0.5);  s = qpsk_mod(b,'gray');
nfft = 64*L;

hP = ones(L,1)/sqrt(L);                           % porte
[hR, ~] = rrc_coef(alpha, L, span);               % RRC
[~, ~, ~, txP] = chaine_filtree(s, hP, L, 0, 0);
[~, ~, ~, txR] = chaine_filtree(s, hR, L, 0, 0);
[f, PP] = psd_moy(txP, nfft, L);
[~, PR] = psd_moy(txR, nfft, L);
PP = PP/max(PP);  PR = PR/max(PR);

figure; plot(f, 10*log10(PP), 'b', f, 10*log10(PR), 'r', 'LineWidth', 1.2); hold on; grid on;
xline((1+alpha)/2, 'k--'); xline(-(1+alpha)/2, 'k--');
xlim([-L/2 L/2]); ylim([-80 3]);
xlabel('f T'); ylabel('DSP normalisée (dB)');
legend('porte','RRC','\pm(1+\alpha)/(2T)'); title('Densité spectrale du signal émis');

function_b99 = @(f,P) deal_b99(f,P);
[b99P, b40P] = bande(f, PP);  [b99R, b40R] = bande(f, PR);
fprintf('(1+alpha)/(2T) = %.3f /T\n', (1+alpha)/2);
fprintf('Porte : demi-bande 99%% = %.3f /T | a -40 dB = %.3f /T\n', b99P, b40P);
fprintf('RRC   : demi-bande 99%% = %.3f /T | a -40 dB = %.3f /T\n', b99R, b40R);

function [b99, b40] = bande(f, P)
    [~, o] = sort(abs(f));  c = cumsum(P(o))/sum(P);
    b99 = abs(f(o(find(c >= 0.99, 1))));
    b40 = max(abs(f(P > 1e-4)));
end