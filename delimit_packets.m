function [ packets ] = delimit_packets( x )

indicesNonZero = find(x);
N = size(indicesNonZero,1);

packets = [];
tmpO = indicesNonZero(1);
tmpC = -1;

for k=1:N-1
    if (indicesNonZero(k+1) - indicesNonZero(k) > 1) 
           tmpC = indicesNonZero(k);
           packets = [packets ; tmpO tmpC];
           tmpO = indicesNonZero(k+1);   
    end
end

% pour fermer la dernière note :
packets = [packets ; tmpO indicesNonZero(end)];

end