function p = Convert_beta_to_p (beta, R, method)
%given R, the maximum intersomatic distance , estimates the value of p
%corresponding to every value of beta depending on the neuron sampling
%method

p = zeros(1,length(beta));

if strcmp(method, 'Equiprobable')
    fun = @(r, b) 2 / R^2 .* r .* exp(-b .* r);
elseif strcmp(method, 'Nearest-Neighbour')
    h = 0.1;
    N = 80500 * 10^-9;  % going with Hjorth 2020 (and Rosen 2001) with 80500/mm^3
    k = 2 * pi * h * N / (1 - exp(-pi * R^2 * h * N));
    fun = @(r,b) k .* r .* exp(-r.*(pi * h * N .* r + b));
elseif strcmp(method, 'DistanceSquared') 
    fun = @(r, b) 2 / R^2 .* r .* exp(-b .* r.^2);
end

for i = 1 : length(p)
    p(i) = integral(@(r) fun(r, beta(i)), 0, R);
end