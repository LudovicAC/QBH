%% Initialisation
close all; clear all; clc;

%% récupérer le pitch d'un fichier midi
% midi = readmidi('usa05.mid');
midi = readmidi('sounds/Midi/00083.mid');
notes = midiInfo(midi,0);
% % notice: midiInfo renvoie une matrice dans laquelle les colonnes sont:
% 1. track number
% 2. channel number
% 3. note number (midi encoding of pitch)
% 4. velocity
% 5. start time (seconds)
% 6. end time (seconds)
% 7. message number of note_on
% 8. message number of note_off
pitch = notes(:,3);
xx = notes(:,5);

%% synthese audio
% (y = audio samples.  Fs = sample rate.  Here, uses default 44.1k.)
[y,Fs] = midi2audio(midi);    

% listen in matlab:
soundsc(y, Fs);  % FM-synth

%% représentation graphique
% classique
figure; plot(xx,pitch,'bx'); xlabel('time'); ylabel('note number (pitch)');
title('pitch in midi convention');

% % avec piano_roll
% % compute piano-roll:
% [PR,t,nn] = piano_roll(notes);
% 
% % display piano-roll:
% figure;
% imagesc(t,nn,PR);
% axis xy;
% xlabel('time (sec)');
% ylabel('note number');
% 
% % % also, can do piano-roll showing velocity:
% % [PR,t,nn] = piano_roll(notes,1);
% % 
% % figure;
% % imagesc(t,nn,PR);
% % axis xy;
% % xlabel('time (sec)');
% % ylabel('note number');

%% Change midi pitch to frequency
f = midi2freq(pitch);