function [ packets ] = envelope_detector( x, Fs )

windowlength = 900; % arbitraire
overlap = 50; % arbitraire
delta = windowlength - overlap;
RMS = rms(x, windowlength, overlap, 1)'; % mettre le paramètre zeropad à 1

%% Enlève bruit de fond

%suppose que les premiers instants = bruit de fond et que celui constant
%au cours de l'enregistrement
tmps = 0.5*Fs;  % arbitraire
bruitFond = noise(x, tmps);
coeff = 5; % arbitraire
E = RMS;
E(E < bruitFond*coeff) = 0;
figure, stem(E);
packets = delimit_packets( E );

%% Sépare 2 notes proches
newPackets = [];
for i = 1 : size(packets,1)
    packets_tmp = distinguishNotesInPacket( E(packets(i,1):packets(i,2)));
    packets_tmp = packets_tmp +  packets(i,1); % on remet l'offset...
    newPackets = [newPackets ; packets_tmp];
end
packets = newPackets;

%% Corrige la tendance à détecter un peu trop tard les attaques (du au seuillage)
avance = 2; % arbitraire
packets(:,1) = packets(:,1) - avance; 

%% Compense la compression RMS
packets = delta* packets;


end

