function [ e_new ] = ignoreZerosConsecutifs( e, tolerance )
% choisir tolérance >= 1
m = max(e);
e_new = e;

indicesNonZero = find(e);
indicesNonZero = indicesNonZero(:);
N = size(indicesNonZero,1);

for k=1:N-1
    if (indicesNonZero(k+1)-indicesNonZero(k) >= 1) && (indicesNonZero(k+1)-indicesNonZero(k) < tolerance)
        for i=indicesNonZero(k)+1:indicesNonZero(k+1)-1
            e_new(i) = m; % on veut juste que ça soit > 0
        end
    end
end


end

