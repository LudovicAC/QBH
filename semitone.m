function [ pitchSemiTone ] = semitone( pitch )

pitchSemiTone = log2(pitch/440)*12 + 69;

end

