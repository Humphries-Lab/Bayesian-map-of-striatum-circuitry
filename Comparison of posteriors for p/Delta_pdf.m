function P_delta = Delta_pdf(p1, p2, step)
% returns a pdf for k = p1 - p2 by computing the integral of
% p2(a).p1(a+k)da over the domain [bound1, bound2] of p1 (and p2)

n = length(p1);

P_delta = zeros(1, n * 2 - 1); % | k=-n+1 | k=-n+2 | ... | k=0 | k=1 | ... | k=n-1 |

for i = 1 : n
    v = p2(i) .* p1; % a vector of p2(a)*p1(a+k) for one given a and for all possible k
    
    % we now want to add this vector to the relevant cells of P_delta
    
    start = n + 1 - i;
    last = start + n - 1;
    
    P_delta(start : last) = P_delta(start : last) + v;
end

P_delta = P_delta * step;