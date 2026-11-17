function [ber, ber1, nerr, nbits] = ber_simulink(EbN0dB)
%BER_SIMULINK  TEB de la chaîne pour un Eb/N0 donné (lit les variables du workspace de base)
    A  = evalin('base','A');   L = evalin('base','L');   Tb = evalin('base','Tb');
    mdl = 'chaine_base';
    assignin('base','sig2', A^2*Tb/(2*10^(EbN0dB/10)) * L/Tb);   % = A^2 L /(2 Eb/N0)
    out = sim(mdl);
    tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));

    % Retard : cherché une fois sans bruit (la sortie est alors exacte)
    persistent d
    if isempty(d)
        assignin('base','sig2', 0);
        o0 = sim(mdl); t0 = double(o0.btx_sim(:)); r0 = double(o0.brx_sim(:));
        for k = 0:3
            if isequal(t0(1:end-k-10), r0(1+k:end-10)), d = k; break; end
        end
        assignin('base','sig2', A^2*Tb/(2*10^(EbN0dB/10)) * L/Tb);
    end
    n  = min(numel(tx), numel(rx)) - d;
    tx = tx(1:n); rx = rx(1+d:d+n);
    nerr = sum(tx ~= rx);  nbits = n;  ber = nerr/n;

    % Sans intégration : un seul échantillon au milieu de chaque bit
    r   = out.r_sim(:);
    mid = r(round(L/2):L:end);
    m   = min(numel(mid), numel(tx));
    ber1 = mean((mid(1:m) > 0) ~= tx(1:m));
end