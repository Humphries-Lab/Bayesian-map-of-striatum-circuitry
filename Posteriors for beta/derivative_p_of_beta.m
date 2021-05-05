function dp = derivative_p_of_beta(R, beta)
% in the case of equiprobable sampling, there exists a closed form for the
% derivative of p woth respect to beta which is what this function returns
% for different values of beta and a given maximum distance R

% because the numerical method used in case of the nearest-neighbour
% is not defined for the very last point, we voluntarily do not calculate
% it for the equiprobable closed form for consistency
dp = zeros(1, length(beta)-1); 

for i = 1 : length(beta)-1
    b = beta(i);
    dp(i) = 2 / (R^2 * b^3) * (exp(-b * R) * ((R * b + 1)^2 + 1) - 2);
end