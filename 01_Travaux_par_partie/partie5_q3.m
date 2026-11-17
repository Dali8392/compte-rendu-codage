clear; clc; close all;
Parametres;
Nbq = 2e4;                                   % taille du modèle (le StopTime est fixé plus bas)
creer_chaine_qpsk('gray');
dBs = [0 5 10];
ideal = exp(1j*(1:2:7)*pi/4);                % les 4 points e^{jk pi/4}

figure('Position',[100 100 1100 650]);
for i = 1:3
    x  = 10^(dBs(i)/10);  sg = sqrt(1/(4*x));
    th = Q(sqrt(2*x));

    % Ligne 1 : Matlab
    b = double(rand(8000,1) < 0.5);
    s = qpsk_mod(b,'gray');
    r = s + sg*(randn(size(s)) + 1j*randn(size(s)));
    ber = mean(qpsk_demod(r,'gray') ~= b);
    subplot(2,3,i); plot(real(r), imag(r), '.', 'MarkerSize', 4); hold on;
    plot(real(ideal), imag(ideal), 'r+', 'MarkerSize', 12, 'LineWidth', 2);
    xline(0); yline(0); axis equal; grid on; xlim([-2 2]); ylim([-2 2]);
    title(sprintf('Matlab, E_b/N_0 = %d dB, TEB = %.3g (th. %.3g)', dBs(i), ber, th));
    xlabel('I'); ylabel('Q');

    % Ligne 2 : Simulink
    assignin('base','sigq2', sg^2);
    o  = sim('chaine_qpsk_sim','StopTime','16000');
    rs = o.rx_sym(:);  rs = rs(3:end);
    subplot(2,3,3+i); plot(real(rs), imag(rs), '.', 'MarkerSize', 4); hold on;
    plot(real(ideal), imag(ideal), 'r+', 'MarkerSize', 12, 'LineWidth', 2);
    xline(0); yline(0); axis equal; grid on; xlim([-2 2]); ylim([-2 2]);
    title(sprintf('Simulink, E_b/N_0 = %d dB', dBs(i))); xlabel('I'); ylabel('Q');

    fprintf('%2d dB : sigma par voie = %.3f | TEB Matlab %.3g | theorie %.3g | var(bruit Simulink) = %.4f (attendu %.4f)\n', ...
        dBs(i), sg, ber, th, var(real(rs - sign(real(rs))/sqrt(2) - 1j*sign(imag(rs))/sqrt(2))), sg^2);
end