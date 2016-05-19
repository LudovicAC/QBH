function [ packets ] = envelope_detector( x )
% retourne les indices des points non nuls

windowlength = 150; % arbitraire
overlap = 20; % arbitraire
delta = windowlength - overlap;
E = rms(x, windowlength, overlap, 1)'; % mettre le param�tre zeropad � 1

seuil = 0.2*max(E); % arbitraire
E(E < seuil) = 0;
E = ignoreZerosConsecutifs(E, 5); % arbitraire
%figure, stem(E);
indicesEnvelope = find(E);
indicesEnvelope = indicesEnvelope(:);

packets = delimit_packets( indicesEnvelope );
packets = delta*packets; % homot�thie pour contrecarrer celle caus�e par rms

end

