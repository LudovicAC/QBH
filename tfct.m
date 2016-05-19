function [] = tfct(x, Fe)
% analyse d'un signal à l'aide de la TFCT
% transformée de Fourier à Court Terme

x = x(:); % ainsi x est un vect. colonne
        % monovoie (voie gauche si stéréo)

N = length(x); % longueur du signal
Nw = 128;
w = hanning(Nw) / sqrt(1.5); % définition de la fenetre d'analyse
R = 0.25*Nw; % incrément sur les temps d'analyse,
          % appelé hop size, t_a=uR
M = Nw; % ordre de la tfd
L = M/2+1;

Nt = fix( (N-Nw)/R ); % calcul du nombre de tfd à calculer


Xtilde = zeros(M,Nt);


for k=1:Nt;  % boucle sur les trame
   deb = (k-1)*R +1; % début de trame
   fin = deb + Nw -1; % fin de trame
   tx = x(deb:fin).*w; % calcul de la trame  
   X = fft(tx,M); % tfd à l'instant b
   
   Xtilde(:,k) = X;
   
end



%soundsc(y,Fe)

    
freq = (0:M/2)/M*Fe;
b = [0:Nt-1]*R/Fe;

figure,
subplot(211)
tps = [0:N-1]/Fe;
plot(tps, x);

subplot(212)
imagesc(b,freq,db(abs(Xtilde(1:L,:)))), axis xy

end