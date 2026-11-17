function [ber, nerr, nbits, d] = ber_hamming_simulink(EbN0dB)
%BER_HAMMING_SIMULINK  TEB sur les bits d'information, chaîne Hamming (7,4)
%   Sans bruit, on cherche le recalage dly (0..6 bits codés) et le retard d
%   (bits d'information) pour lesquels la chaîne est parfaite.
    mdl = 'chaine_ham74';
    A   = evalin('base','A');  L = evalin('base','L');  Tbi = evalin('base','Tbi');
    persistent dly d0

    if isempty(d0)
        assignin('base','sig2',0);
        for k = 0:6
            assignin('base','dly',k);
            o0 = sim(mdl,'StopTime',num2str(600*Tbi));
            t0 = double(o0.btx_sim(:));  r0 = double(o0.brx_sim(:));
            m  = min(numel(t0), numel(r0)) - 101;
            for j = 0:100
                if isequal(t0(1:m), r0(1+j:j+m)), dly = k; d0 = j; break; end
            end
            if ~isempty(d0), break; end
        end
        if isempty(d0), error('Retard introuvable : chaine sans bruit non conforme.'); end
    end
    d = d0;
    assignin('base','dly',dly);
    assignin('base','sig2', A^2*L/(2*10^(EbN0dB/10)));   % Eb/N0 de l'information
    out = sim(mdl);
    tx = double(out.btx_sim(:));  rx = double(out.brx_sim(:));
    n  = min(numel(tx), numel(rx)) - d;
    nerr = sum(tx(1:n) ~= rx(1+d:d+n));
    nbits = n;  ber = nerr/n;
end