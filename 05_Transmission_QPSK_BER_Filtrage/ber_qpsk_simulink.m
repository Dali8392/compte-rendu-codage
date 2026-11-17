function [ber, nerr, nbits, d] = ber_qpsk_simulink(EbN0dB)
%BER_QPSK_SIMULINK  TEB de la chaîne 'chaine_qpsk_sim' (EbN0dB = Inf : sans bruit)
    mdl = 'chaine_qpsk_sim';
    persistent d0
    if isempty(d0)                                   % retard mesuré sans bruit
        assignin('base','sigq2',0);
        o0 = sim(mdl,'StopTime','4000');
        t0 = double(o0.btx_sim(:));  r0 = double(o0.brx_sim(:));
        m  = min(numel(t0), numel(r0)) - 51;
        for j = 0:50
            if isequal(t0(1:m), r0(1+j:j+m)), d0 = j; break; end
        end
        if isempty(d0), error('Retard introuvable : chaine sans bruit non conforme.'); end
    end
    d = d0;
    x = 10^(EbN0dB/10);
    assignin('base','sigq2', 1/(4*x));               % Es = 1, R = 1
    out = sim(mdl);
    tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));
    n  = min(numel(tx), numel(rx)) - d;
    nerr = sum(tx(1:n) ~= rx(1+d:d+n));
    nbits = n;  ber = nerr/n;
end