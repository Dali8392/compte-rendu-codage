function [ber, nerr, nbits, d] = ber_qpsk_ham_simulink(EbN0dB)
%BER_QPSK_HAM_SIMULINK  TEB sur les bits d'information (Hamming + QPSK Gray)
    mdl = 'chaine_qpsk_ham_sim';
    persistent dly d0
    if isempty(d0)
        assignin('base','sigq2',0);
        for k = 0:6
            assignin('base','dly',k);
            o0 = sim(mdl,'StopTime','4200');                 % 600 bits d'information
            t0 = double(o0.btx_sim(:));  r0 = double(o0.brx_sim(:));
            m  = min(numel(t0), numel(r0)) - 201;
            for j = 0:200
                if isequal(t0(1:m), r0(1+j:j+m)), dly = k; d0 = j; break; end
            end
            if ~isempty(d0), break; end
        end
        if isempty(d0), error('Retard introuvable : chaine sans bruit non conforme.'); end
    end
    d = d0;
    assignin('base','dly',dly);
    x = 10^(EbN0dB/10);
    assignin('base','sigq2', 7/(16*x));                     % Es = 1, R = 4/7
    out = sim(mdl);
    tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));
    n  = min(numel(tx), numel(rx)) - d;
    nerr = sum(tx(1:n) ~= rx(1+d:d+n));
    nbits = n;  ber = nerr/n;
end