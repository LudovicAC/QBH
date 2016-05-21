%% QBH
close all, clear all

[x, Fs] = wavread('sounds/query.wav');
x = x(:,1); % stereo => mono
soundsc(x ,Fs);

%% Affichage signal
N = length(x);
tps = [0:N-1]/Fs;
figure, plot(tps, x);

tfct(x, Fs);

%% D�tection enveloppe
packets = envelope_detector(x, Fs);
packets = reshape(packets, max(size(packets)), 2);

figure, stem(x)
hold on
for i = 1 : size(packets,1)
    for j = 1 : 2
        plot([packets(i,j) packets(i,j)], [min(x) max(x)], 'r');
    end
end
hold off;

%% D�tection pitch
nbNotes = size(packets,1);
pitch = zeros(nbNotes, 1);
for i = 1 : nbNotes
   pitch(i) = pitch_detector(x(packets(i,1):packets(i,2)), Fs);
end

figure, plot(pitch, 'o'), title('pitch')

%% Lissage du pitch avec median filter d'ordre 5 ?

%% Transform pitch into semi-tone scale (to compare it to MIDI format)
pitchSemiTone = semitone(pitch)

