function [ resTab ] = compareQueryToBdd(query, pitch_BddMidi, allNames, top, w, overlap )
% top < N_BddMidi

N_BddMidi = length(pitch_BddMidi);
resTab = cell(top,3);

score = zeros(top, 2); % [scoreSimilarity, idBddMidi]
for id=1:N_BddMidi
    [scoreSimilarity, ~, ~] = LADTW_Similarity_Glissante(cell2mat(pitch_BddMidi(id)), query, w, overlap);
    [minn, idMin] = min(score(:,1));
    if scoreSimilarity > minn 
        score(idMin, :) = [scoreSimilarity, id];
    end
end

for k=1:top
    resTab(k,1) = allNames(score(k,2));
    resTab(k,2) = {score(k,1)};
    resTab(k,3) = {score(k,2)};
end

end

