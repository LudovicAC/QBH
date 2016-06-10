%% QBH
close all, clear all

%% Traitement préalabale de notre dossier de Midi
allMidiFiles = dir( 'sounds/Midi' );
allNames = {allMidiFiles.name};
allNames = allNames(3:end);  % se débarasser des '.' et '..'

N_BddMidi = length(allNames);
pitch_BddMidi = cell(N_BddMidi, 1);

for id=1:N_BddMidi
    name = allNames(id);
    nameString = cell(1,2);
    nameString(1) = {'sounds/Midi/'};
    nameString(2) = name;
    midi = readmidi(strjoin(nameString, ''));
    notes = midiInfo(midi,0);
    pitch = notes(:,3);
    %pitch = pitch - median(pitch); % idée pour s'affranchir un peu du ton...
    %pitch = diff(pitch);
    pitch_BddMidi(id) = {pitch};
end
% acces à une séquence de pitch par : cell2mat(pitch_BddMidi(id))

%% Query

[x, Fs] = wavread('sounds/Query00083.wav');
x = x(:,1); % stereo => mono
%soundsc(x ,Fs);

%% Affichage query
N = length(x);
tps = [0:N-1]/Fs;
figure, plot(tps, x);

tfct(x, Fs);

%% Dï¿½tection enveloppe Query
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

%% Dï¿½tection pitch
nbNotes = size(packets,1);
pitch = zeros(nbNotes, 1);
for i = 1 : nbNotes
    pitch(i) = pitch_detector(x(packets(i,1):packets(i,2)), Fs);
end

figure, plot(pitch, 'o'), title('pitch')


%% Transform pitch into semi-tone scale (to compare it to MIDI format)
pitchSemiTone = semitone(pitch);
figure, plot(pitchSemiTone, 'o'), title('pitch - semitone')
%pitchSemiTone = pitchSemiTone - median(pitchSemiTone); % idée : invariance au ton..
%pitchSemiTone = diff(pitchSemiTone);
%%
query = pitchSemiTone;
query(5) = 52;
w = length(query)*2;
overlap  = 0.25;
top = 10;

tab = compareQueryToBdd(query, pitch_BddMidi, allNames, top, w, overlap)

%%


%% Quelques Tests

i=200;
music = cell2mat(pitch_BddMidi(i));
query = pitchSemiTone;
query(5) = 52;
w = length(query)*2;
overlap  = 0.25;
[scoreSimilarity_max, S_max, path_max] = LADTW_Similarity_Glissante(music, query, w, overlap);
scoreSimilarity_max

% figure,
% hold on
% plot(cell2mat(pitch_BddMidi(i)), 'or')
% plot(query, '+b')
% hold off
% 
% figure, imagesc(S_max), colorbar
% hold on
% plot(path_max(:,2), path_max(:,1), '+r')
% hold off

