function [ scoreSimilarity, S, w ] = LADTW_Similarity( p, q )
% p : music & q : query

p = p(:);
q = q(:);
n = size(q,1);
m = size(p,1);

Cdtw = 0.8; % empirique
w = 1.6; % empirique

S = zeros(n,m);
S(:,:) = -Inf;
S(1,1) = 0;

S(:,1) = max([ -abs(q - repmat(p(1), n, 1)) + Cdtw, zeros(n,1) ], [], 2);
S(1,2:end) = max([ -abs(repmat(q(1), m-1, 1) - p(2:end)) + Cdtw, zeros(m-1,1) ], [], 2);

for i=2:n
    for j=2:m
        s = -abs(q(i) - p(j));
        S(i,j) = max([S(i-1,j-1)+s+Cdtw, S(i-1, j)+s+w*Cdtw, S(i, j-1)+s+w*Cdtw, 0]);
    end
end

% id�e : au lieu de prendre le max de S, prendre la moyenne sur les k deni�res
% valeurs de S (o� k param�tre � d�termin� < n (taille de la query) et la derni�re valeur est
% celle du max de S)  et retrancher la similarity cumul�e � la k+1�me
% valeur (en partant de la fin)

k = n-1; % < n   � ajuster

maxx = max(S);
[maxx, j_max] = max(maxx);
[maxx, i_max] = max(S(:,j_max));

w = [i_max j_max];
score_tmp = maxx;

i = i_max;
j = j_max;

while i+j~=2
    if i == 1
        j = j-1;
        maxx = S(1,j);
    elseif j == 1
        i = i-1;
        maxx = S(i,j);
    else
        [maxx, ind] = max([S(i-1,j), S(i,j-1), S(i-1,j-1)]);
        
        switch ind
            case 1
                i=i-1;
            case 2
                j=j-1;
            case 3
                i=i-1;
                j=j-1;
        end
    end
    w = [w; i j];
    score_tmp = [score_tmp ; maxx];
end

    scoreSimilarity = mean(score_tmp(1:k));
    scoreSimilarity = scoreSimilarity - score_tmp(k+1);
end

