function [beta_posterior, beta_MAP, beta_CI] = TransformPosterior(a, b, p, beta, y_scaling, alpha)
% given a and b, the shape parameters of a (posterior) distribution
% function, calculates the values of the corresponding beta distribution at
% the set of desired values p. Then transforms this vector-form pdf into a
% density function for beta by multiplying by the vertical scaling factor.
% Also returns alpha-level confidence interval.

if alpha > 1 && alpha <= 100 % if alpha is between 1 and 100, we assume the user is giving alpha in % and we convert into decimal value, eg 5% becomes 0.05
    alpha = alpha / 100;
elseif alpha < 0 || alpha > 1
    error('alpha must be between 0 and 1')
end

unit = beta(2) - beta(1); % assuming beta values are spread out evenly, which is necessary to numerically integrate

beta_posterior = betapdf(p(1:end-1), a, b) .* y_scaling;
beta_MAP = beta(beta_posterior == max(beta_posterior));

beta_CI =  [beta(find(cumsum(beta_posterior)* unit >= alpha / 2, 1)),...
            beta(find(cumsum(beta_posterior)* unit >= (1 - alpha / 2), 1))];