%Returns a vector containing every prime number through n
function [vnew]=eratosthenes(n)
    v = 2 : n;
    for k = 2 : sqrt(n)
        for t = (k^2)-1 : k : n
            v(t) = 0;
        end
    end
    vnew = v((v>0));
end