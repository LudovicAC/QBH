function [No] = noise (x, temps) 
    signal = x(1:temps).^2;
    No = sqrt(mean(signal));

end