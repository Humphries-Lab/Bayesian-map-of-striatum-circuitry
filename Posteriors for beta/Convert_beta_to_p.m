function p = Convert_beta_to_p (beta, R)
%given R, the maximum intersomatic distance , estimates the value of p
%corresponding to every value of beta

p = zeros(1,length(beta));

for i = 1 : length(p)
    p(i) = 2 / R^2 * -1 / beta(i) * (exp(- 1 * R * beta(i)) * (R + 1 / beta(i)) - 1 / beta(i));
end