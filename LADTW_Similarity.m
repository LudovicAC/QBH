function [ scoreSimilarity, S, w ] = LADTW_Similarity( p, q )
% p : music & q : query

p = p(:);
q = q(:);
n = size(q,1);
m = size(p,1);

Cdtw = 1.5; % empirique
w = 0.5; % empirique

S = zeros(n,m);
S(:,:) = -Inf;
S(1,1) = 0;

S(:,1) = max([ -abs(q - repmat(p(1), n, 1)) + Cdtw, zeros(n,1) ], [], 2);
S(1,2:end) = max([ -abs(repmat(q(1), m-1, 1) - p(2:end)) + Cdtw, zeros(m-1,1) ], [], 2);


for i=2:n
    for j=2:m
        s = -sqrt(abs(q(i) - p(j)));
        S(i,j) = max([S(i-1,j-1)+s+Cdtw, S(i-1, j)+s+w*Cdtw, S(i, j-1)+s+w*Cdtw, 0]);
    end
end

% idée : au lieu de prendre le max de S, prendre la moyenne sur les k denières
% valeurs de S (où k paramètre à déterminé < n (taille de la query) et la dernière valeur est
% celle du max de S)  et retrancher la similarity cumulée à la k+1ème
% valeur (en partant de la fin)

k = n-1; % < n   à ajuster

maxx = max(S);
[maxx, j_max] = max(maxx);
[maxx, i_max] = max(S(:,j_max));

w = [i_max j_max];
score_tmp = maxx;

i = i_max;
j = j_max;

while i+j>2  % i+j~=2
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

l = length(score_tmp);
if (l > k)
    tmp = k;
else
   tmp = l-1; 
end
%scoreSimilarity = mean(score_tmp(1:tmp));
%scoreSimilarity = scoreSimilarity - score_tmp(tmp+1);
scoreSimilarity = score_tmp(1) - score_tmp(tmp+1);

end

