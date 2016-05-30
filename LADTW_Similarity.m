function [ S, maxx ] = LADTW_Similarity( p,q )

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

maxx = max(max(S));

end

