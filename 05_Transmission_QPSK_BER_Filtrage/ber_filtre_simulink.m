function [ber, nerr, nbits, d] = ber_filtre_simulink(EbN0dB, phs)
%BER_FILTRE_SIMULINK  TEB de 'chaine_filtree_sim' ; phs = décalage d'échantillonnage (0..L-1)
    mdl = 'chaine_filtree_sim';
    L   = evalin('base','L');
    persistent d0
    if isempty(d0)                                     % retard (bits) mesuré sans bruit et sans décalage
        assignin('base','sigq2',0);  assignin('base','phs',0);
        o0 = sim(mdl,'StopTime',num2str(3000*L/2));
        t0 = double(o0.btx_sim(:));  r0 = double(o0.brx_sim(:));
        m  = min(numel(t0), numel(r0)) - 301;
        for j = 0:300
            if isequal(t0(1:m), r0(1+j:j+m)), d0 = j; break; end
        end
        if isempty(d0), error('Retard introuvable : chaine sans bruit non conforme.'); end
    end
    d = d0;
    assignin('base','phs',phs);
    assignin('base','sigq2', 1/(4*10^(EbN0dB/10)));    % Es = 1
    out = sim(mdl);
    tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));
    n  = min(numel(tx), numel(rx)) - d;
    nerr = sum(tx(1:n) ~= rx(1+d:d+n));
    nbits = n;  ber = nerr/n;
end