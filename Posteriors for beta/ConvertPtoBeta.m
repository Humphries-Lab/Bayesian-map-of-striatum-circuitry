function beta = ConvertPtoBeta (p, R)
%given R, the maximum intersomatic distance , estimate the value of beta
%corresponding to every value of p

beta = zeros(1,length(p));

syms x b

% h = 10;
% N = 14.15 * 10^4 * 10^-9;  % according to Oorschoot 1996, (14.15 * 10^4) neurons 84900 per mm^3
% k = 2 * pi * h * N / (1 - exp(-pi * R^2 * h * N));
% f = @(x,b) k .* x .* exp(-x.*(pi * h * N .* x + b));

for i = 1 : length(p)
    P = p(i);
    beta(i) = vpasolve(P == 2 / R^2 * -1 / b * (exp(- 1 * R * b) * (R + 1 / b) - 1 / b), b);
    
    %beta(i) = fzero(@(b) integral(@(x) f(x,b), 0, R) - P, 0.5);
end