
% returns a pdf for k = beta_taverna - beta_Planert by computing the 
% integral of beta_Planert(a).beta_Taverna(a+k)da over the 
% domain [bound1, bound2] of beta1 (and beta2)

clear all
close all

load('beta pdfs')

min_beta = beta(1);

step = beta(2) - beta(1);
max_beta = beta(end) - step;
beta = min_beta : step : max_beta;
Delta = min_beta - max_beta : step : max_beta - min_beta;

f_delta_d1 = zeros(length(Delta), 1);
f_delta_d2 = zeros(length(Delta), 1);
i = 1;

for k = Delta
    
    inf_bnd = max(min_beta, min_beta - k);
    sup_bnd = min(max_beta, max_beta - k);
    
    domain = inf_bnd : step : sup_bnd;
    S_d1 = 0;
    S_d2 = 0;
    
    for j = domain
        beta1_coor = floor((k+j) *1000);
        beta2_coor = floor(j*1000);
        S_d1 = S_d1+ Taverna_beta_pdf.d1_dx(beta1_coor) * Planert_beta_pdf.d1_dx(beta2_coor);
        S_d2 = S_d2+ Taverna_beta_pdf.d2_dx(beta1_coor) * Planert_beta_pdf.d2_dx(beta2_coor);
    end
    
    f_delta_d1(i) = step* S_d1;
    f_delta_d2(i) = step* S_d2;
    
    i = i + 1;
end

P_positive_d1 = sum(f_delta_d1(500:end)) / sum(f_delta_d1)
P_positive_d2 = sum(f_delta_d2(500:end)) / sum(f_delta_d2)

figure()
hold on
plot(Delta, f_delta_d1)
plot(Delta, f_delta_d2)
title('Distribution of beta Taverna - beta Planert')
legend('d1->SPN', 'd2->SPN')
saveas(gcf, 'delta for betas', 'png')
