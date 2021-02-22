function [pdf, CI, MAP, a, b] = CalculatePosterior(prior_a, prior_b, X, N, alpha, x)
% given a prior and a set of observations, calculates the posterior beta
% distribution, its MAP, updated shape parameters and credibility interval

unit = 1 / (length(x) - 1);
confidence_limits = [alpha / 2 1 - alpha / 2]; % eg 2.5% and 97.5% for centered 95% coverage

a = prior_a + X;
b = prior_b + (N - X);

pdf = betapdf(x, a, b);
CI = betainv(confidence_limits, a, b);
[~, arg] = max(pdf);
MAP = (arg-1) * unit;