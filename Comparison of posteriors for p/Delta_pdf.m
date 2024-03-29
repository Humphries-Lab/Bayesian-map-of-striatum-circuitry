function P_delta = Delta_pdf(a1, b1, a2, b2, step)
% returns a pdf for k = p1 - p2 by computing the integral of
% p2(a).p1(a+k)da over the domain [bound1, bound2] of p1 (and p2)

fun = @(x,k) betapdf(x+k, a1, b1) .* betapdf(x, a2, b2);

P_delta = zeros(length(-1 : step : 1), 1);
i = 1;

for k = -1 : step : 1
    P_delta(i) = integral(@(x) fun(x, k), max(0, -k), min(1,1-k));
    i = i + 1;
end

index_zero = length(-1 : step : 0);
X = -1 : step : 0;
p_less_than_zero = trapz(X, P_delta(1 : index_zero));
p_more_than_zero = 1 - trapz(X, P_delta(1 : index_zero));
p_more_extreme = min(p_less_than_zero, p_more_than_zero)