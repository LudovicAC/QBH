function [ maxScoreSimilarity, maxS, maxPath ] = LADTW_Similarity_Glissante( p, q, w, overlap )
% p : music
% q : query (suppose < q)
% w : size of the window (ordre de grandeur de la taille de q)
% overlap : between 0 and 1

p = p(:);
q = q(:);
n = size(p, 1);
m = size(q, 1);

R = floor(w*(1-overlap)); % hop
q = q - median(q);
quantile_q = quantile(q ,[0.75 0.25]);
dyn_q = quantile_q(1) - quantile_q(2);

N = floor(n/R); % nombre de LADTW calculées

scoreSimilarity = zeros(N, 1);

%maxS = 0; % init bidon
%maxPath = 0; % init bidon

compt = 0;
for i=1:R:n-w+1
    compt = compt + 1;
    if compt == N
        % on agrandit la dernière window pour faire rentrer tout le signal p...
        w = n - i + 1;
    end
    p_tmp = p(i:i+w-1);
    p_tmp = p_tmp - median(p_tmp);
    quantile_p = quantile(p_tmp, [0.75 0.25]);
    dyn_p = quantile_p(1) - quantile_p(2);
    p_tmp = p_tmp * dyn_q/dyn_p;
    [scoreSimilarity_tmp, S, path] = LADTW_Similarity(p_tmp, q);
    
    if scoreSimilarity_tmp > max(scoreSimilarity)
        maxS = S;
        maxPath = path;
    end
    
    scoreSimilarity(compt) = scoreSimilarity_tmp;
    
%         figure,
%         hold on
%         plot(p_tmp, 'or')
%         plot(q, '+b')
%         hold off
%     
%         figure, imagesc(S), colorbar
%         hold on
%         plot(path(:,2), path(:,1), '+r')
%         hold off
    
    
end

%scoreSimilarity

maxScoreSimilarity = max(scoreSimilarity);

end

