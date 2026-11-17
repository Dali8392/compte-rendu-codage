% Parametres.m : à exécuter avant chaque simulation
nom    = 'MOHAMED ALI MHADHBI';   % orthographe de la liste d'appel
P      = parametres_perso(char(nom));   % char() évite le piège des "string"

Tb     = 1;              % durée d'un bit (unité de référence)
p1     = P.p1;           % P(bit = 1)
p0     = 1 - p1;
p1_ext = P.p1_ext;       % source très déséquilibrée (2.3)
pe     = P.pe_cbs;
A      = P.A;
a_unif = P.a_unif;
sigma  = P.sigma;
L      = P.L;
alpha  = P.alpha;
beta   = P.beta;
tau    = P.retard_trajet;
graine = P.graine;
rng(graine);             % tirages reproductibles
fichier_texte = 'texte_fr.txt'; 
% --- Partie 3 : paramètres de la chaîne
Te     = Tb/L;            % période d'échantillonnage (L échantillons par bit)
psrc   = 0.5;             % bits équiprobables pour la chaîne (Q10 à Q13)
seuil  = 0;               % seuil de décision (Q10 à Q13)
Nb     = 2e5;             % nombre de bits pour les simulations Simulink
EbN0dB = 6;               % valeur par défaut, écrasée par les scripts
sig2   = A^2*L/(2*10^(EbN0dB/10));   % variance du bruit par échantillon
Q      = @(x) 0.5*erfc(x/sqrt(2));   % fonction Q
% --- Partie 4 : codage de canal Hamming (7,4)
Rc    = 4/7;                  % rendement
Tbi   = 7*L/4;                % durée d'un bit d'information, en ticks (1 tick = 1 échantillon canal)
a_c   = A*sqrt(4/7);          % amplitude d'un bit codé
[Gm, Hm] = hamming_matrices();
Gt    = Gm.';                 % 7x4 : c = Gt*m  (modulo 2), m = [m0 m1 m2 m3]'

% --- Partie 5 : QPSK
Es    = 1;                    % énergie par symbole
Eb_q  = Es/2;                 % énergie par bit sans codage (2 bits/symbole)
Nbq   = 2e5;                  % bits d'information par simulation Simulink (2e4 pour tester)
sigq2 = 1/(4*10^(6/10));      % variance par voie, écrasée par les scripts
dly   = 0;                    % recalage des mots (chaîne codée)

%% --- Partie 6 : filtres
span  = 10;                   % troncature des filtres (en symboles)
Nfilt = span*L + 1;           % nombre de coefficients