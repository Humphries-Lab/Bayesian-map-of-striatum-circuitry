function [pdf, CI, MAP, a, b] = CalculatePosterior(prior_a, prior_b, X, N, alpha, x)
% given a prior and a set of observations, calculates the posterior beta
% distribution, its MAP, updated shape parameters and credibility interval

if alpha > 1 && alpha <= 100 % if alpha is between 1 and 100, we assume the user is giving alpha in % and we convert into decimal value, eg 5% becomes 0.05
    alpha = alpha / 100;
elseif alpha < 0 || alpha > 1
    error('alpha must be between 0 and 1')
end

unit = 1 / (length(x) - 1);
confidence_limits = [alpha / 2 1 - alpha / 2]; % eg 2.5% and 97.5% for centered 95% coverage

a = prior_a + X;
b = prior_b + (N - X);

pdf = betapdf(x, a, b);
CI = betainv(confidence_limits, a, b);
[~, arg] = max(pdf);
MAP = (arg-1) * unit;