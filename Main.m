%% QBH
close all, clear all

[x, Fs] = wavread('sounds/Query00083.wav');
x = x(:,1); % stereo => mono
soundsc(x ,Fs);

%% Affichage signal
N = length(x);
tps = [0:N-1]/Fs;
figure, plot(tps, x);

tfct(x, Fs);

%% Dï¿½tection enveloppe
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

%% Lissage du pitch avec median filter d'ordre 5 ?

%% Transform pitch into semi-tone scale (to compare it to MIDI format)
pitchSemiTone = semitone(pitch);
figure, plot(pitchSemiTone, 'o'), title('pitch - semitone')
%pitchSemiTone = pitchSemiTone - median(pitchSemiTone); % idée : invariance au ton..
%pitchSemiTone = diff(pitchSemiTone);
%% Quelques Tests
pitchSemiTone_Music = [53 ; 53 ; 54 ; 53; 53; 53 ; pitchSemiTone ; 56;56;56;58;58];
[scoreSimilarity, S, w] = LADTW_Similarity(pitchSemiTone_Music, pitchSemiTone);
figure, imagesc(S), colorbar
hold on
plot(w(:,2), w(:,1), '+r')
hold off
scoreSimilarity

pitchSemiTone_Music = [pitchSemiTone ; 56;56;56;58;58];
[scoreSimilarity, S, w] = LADTW_Similarity(pitchSemiTone_Music, pitchSemiTone);
figure, imagesc(S), colorbar
hold on
plot(w(:,2), w(:,1), '+r')
hold off
scoreSimilarity

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

%% Compare query to bdd

top = 20; % arbitraire  < N_BddMidi
score = zeros(top, 2); % [scoreSimilarity, idBddMidi]
for id=1:N_BddMidi
    [scoreSimilarity, S, w] = LADTW_Similarity(cell2mat(pitch_BddMidi(id)), pitchSemiTone);
    [minn, idMin] = min(score(:,1));
    if scoreSimilarity > minn 
        score(idMin, :) = [scoreSimilarity, id];
    end
end

%%
%allNames(score(:,2))
% vrai song : 6, 40 217
i=6;
figure,
hold on
plot(cell2mat(pitch_BddMidi(i)), 'or')
plot(pitchSemiTone, '+b')
hold off
[scoreSimilarity, S, w] = LADTW_Similarity(cell2mat(pitch_BddMidi(i)), pitchSemiTone);
figure, imagesc(S), colorbar
hold on
plot(w(:,2), w(:,1), '+r')
hold off
scoreSimilarity

%%
music = cell2mat(pitch_BddMidi(6));
n=20;
music= music(1:n);
music = music - median(music);
pitchSemiTone =  pitchSemiTone - median(pitchSemiTone);

figure,
hold on
plot(music, 'or')
plot(pitchSemiTone, '+b')
hold off
[scoreSimilarity, S, w] = LADTW_Similarity(music, pitchSemiTone);
figure, imagesc(S), colorbar
hold on
plot(w(:,2), w(:,1), '+r')
hold off
scoreSimilarity


%%
% music = cell2mat(pitch_BddMidi(6));
% n=20;
% music = music(1:n);
% [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform([[1:9]',pitchSemiTone], [[1:n]',music], 'similarity');
% figure, 
% hold on
% plot(music, 'or')
% plot(pitchSemiTone, 'ob')
% plot(inlierDistorted(:,2) , '+b')
% plot(inlierOriginal(:,2), '+r')
% hold off
% 
% inlierDistorted = inlierDistorted(:,2);
% inlierDistorted = inlierDistorted - mean(inlierDistorted);
% inlierOriginal = inlierOriginal(:,2);
% inlierOriginal = inlierOriginal - mean(inlierOriginal);
% figure,
% hold on
% plot(inlierDistorted, '+b')
% plot(inlierOriginal, '+r')
% hold off
% 
% mean(abs(inlierDistorted - inlierOriginal).^2)