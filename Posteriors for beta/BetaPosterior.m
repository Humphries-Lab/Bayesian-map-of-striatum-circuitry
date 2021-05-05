%% prologue

clear all
close all

% addpath('../../../../BrewerMap')
% scheme_d1 = 'Blues';
% scheme_d2 = 'Reds';
% cm = colormap([brewermap(2,scheme_d1); brewermap(2,scheme_d2)]);
cm = colormap(lines);
close gcf

%% select datasets and prior and load corresponding posterior distribution

prior = 'literature';
sampling_method = 'Equiprobable'; % or 'Nearest-Neighbour'

Taverna = load(['../Posteriors for p/Taverna posterior with ' prior ' prior']);
Planert = load(['../Posteriors for p/Planert posterior with ' prior ' prior']);

% maximum intersomatic distance (in um)
R_Taverna = 50;
R_Planert = 100;

MSN_pairs = {'d1_dx', 'd2_dx'};
alpha = 0.05;

%% either calculate the reparameterisation or load from previous save as this calculation is relatively long

min_beta = 0.001;
max_beta = 0.5;
beta_step = 0.0001;
beta = min_beta : beta_step : max_beta;

p_Taverna = Convert_beta_to_p(beta, R_Taverna, sampling_method);
p_Planert = Convert_beta_to_p(beta, R_Planert, sampling_method);

if strcmp(sampling_method, 'Equiprobable') % use the closed form of the derivative
    dp_Taverna = -1 * derivative_p_of_beta(R_Taverna, beta);
    dp_Planert = -1 * derivative_p_of_beta(R_Planert, beta);
else % numerical method 
    dp_Taverna = -1 * diff(p_Taverna) ./ diff(beta);
    dp_Planert = -1 * diff(p_Planert) ./ diff(beta);
end
% load('betas')

%% calculate the new posterior for y (the beta parameter) according to the formula g(y) = f(x(y)). dx/dy with x the binomial parameter

for pair = MSN_pairs
    [Taverna_beta_pdf.(pair{1}), Taverna_MAP.(pair{1}), Taverna_beta_CI.(pair{1})] = TransformPosterior(Taverna.posterior.(pair{1}).a, Taverna.posterior.(pair{1}).b, p_Taverna, beta, dp_Taverna, alpha);
    [Planert_beta_pdf.(pair{1}), Planert_MAP.(pair{1}), Planert_beta_CI.(pair{1})] = TransformPosterior(Planert.posterior.(pair{1}).a, Planert.posterior.(pair{1}).b, p_Planert, beta, dp_Planert, alpha);
end

%% figures

% because the derivative is not defined for the very last value of beta, we
% remove it from the x-axis

x_beta = beta(1:end-1);

for pair = MSN_pairs
    
    figure()
    hold on
    Curve_Taverna = plot(x_beta, Taverna_beta_pdf.(pair{1}), 'Linewidth', 2);
    CI_Taverna_curve = line(Taverna_beta_CI.(pair{1}), [-0.5 -0.5], 'LineWidth',2, 'HandleVisibility', 'off');
    Curve_Planert = plot(x_beta, Planert_beta_pdf.(pair{1}), 'Linewidth', 2);
    CI_Planert_curve = line(Planert_beta_CI.(pair{1}), [-1 -1], 'LineWidth',2, 'HandleVisibility', 'off');
    legend('Taverna', 'Planert')
    axis square
    
    if strcmp(pair{1}(2), '1') % ie if the presynaptic neuron is a D1 neuron
        xlim([0 0.3])
        ylim([-3 50])
        Curve_Taverna.Color = cm(1,:);
        CI_Taverna_Curve.Color = cm(1,:);
        Curve_Planert.Color = cm(2,:);
        CI_Planert_Curve.Color = cm(2,:);
    else % ie if the presynaptic neuron is a D2 neuron instead
        xlim([0 0.15])
        ylim([-5 90])
        Curve_Taverna.Color = cm(3,:);
        CI_Taverna_Curve.Color = cm(3,:);
        Curve_Planert.Color = cm(4,:);
        CI_Planert_Curve.Color = cm(4,:);
    end
    
    saveas(gcf, ['beta posterior ' pair{1}], 'svg')
    
    x = 0 : 1 : 120;
    y1 = exp(-Taverna_MAP.(pair{1}) * x);
    y2 = exp(-Planert_MAP.(pair{1}) * x);
    
    figure()
    hold on
    Taverna_exp = plot(x, y1, 'Color', cm(2,:), 'LineWidth', 1);
    Planert_exp = plot(x, y2, 'Color', cm(2,:), 'LineWidth', 1);
    axis square
    legend('Taverna', 'Planert')
    %xticks([0 : 1 : 120])
    if strcmp(pair{1}(2), '1') % ie if the presynaptic neuron is a D1 neuron
        Taverna_exp.Color = cm(1,:);
        Planert_exp.Color = cm(2,:);
    else % ie if the presynaptic neuron is a D2 neuron instead
        Taverna_exp.Color = cm(3,:);
        Planert_exp.Color = cm(4,:);
    end
    %saveas(gcf, ['../figures/beta posterior/' pair{1} ' exponential'], 'svg')
end

%% postface

% save('betas', 'p', 'beta_Taverna', 'beta_Planert', 'derivative_Taverna', 'derivative_Planert', 'Taverna_beta_pdf', 'Planert_beta_pdf', 'Taverna_MAP', 'Planert_MAP')
% rmpath('../../../../BrewerMap')