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

Taverna = load(['../Posteriors for p/Taverna posterior with ' prior ' prior']);
Planert = load(['../Posteriors for p/Planert posterior with ' prior ' prior']);

% maximum intersomatic distance (in um)
R_Taverna = 50;
R_Planert = 100;

MSN_pairs = {'d1_dx', 'd2_dx'};
alpha = 0.05;

%% either calculate the reparameterisation or load from previous save as this calculation is relatively long

min_beta = 0.001;
max_beta = 0.2;
beta_step = 0.0001;
beta = min_beta : beta_step : max_beta;

p_Taverna = Convert_beta_to_p(beta, R_Taverna);
p_Planert = Convert_beta_to_p(beta, R_Planert);

derivative_Taverna = abs(diff(p_Taverna) ./ diff(beta));
derivative_Planert = abs(diff(p_Planert) ./ diff(beta));



% beta_Taverna = ConvertPtoBeta (p, R_Taverna);
% beta_Planert = ConvertPtoBeta (p, R_Planert);
% derivative_Taverna = abs(diff(p) ./ diff(beta_Taverna));
% derivative_Planert = abs(diff(p) ./ diff(beta_Planert));

% load('betas')

%% calculate the new posterior for y (the beta parameter) according to the formula g(y) = f(x(y)). dx/dy with x the binomial parameter

for pair = MSN_pairs
%     Taverna_beta_pdf.(pair{1}) = Taverna.posterior.(pair{1}).pdf(2:999) .* derivative_Taverna;
%     [~, arg] = max(Taverna_beta_pdf.(pair{1}));
%     Taverna_MAP.(pair{1}) = beta_Taverna(arg);
%     Taverna_convertedMAP.(pair{1}) = ConvertPtoBeta (Taverna.posterior.(pair{1}).MAP, R_Taverna);
%     Taverna_convertedCI.(pair{1}) =  ConvertPtoBeta (Taverna.posterior.(pair{1}).CI, R_Taverna);
    [Taverna_beta_pdf.(pair{1}), Taverna_MAP.(pair{1}), Taverna_beta_CI.(pair{1})] = TransformPosterior(Taverna.posterior.(pair{1}).a, Taverna.posterior.(pair{1}).b, p_Taverna, beta, derivative_Taverna, alpha);
    [Planert_beta_pdf.(pair{1}), Planert_MAP.(pair{1}), Planert_beta_CI.(pair{1})] = TransformPosterior(Planert.posterior.(pair{1}).a, Planert.posterior.(pair{1}).b, p_Planert, beta, derivative_Planert, alpha);
end

%% figures

% because the derivative is not defined for the very last value of beta, we
% remove it from the x-axis

beta = beta(1:end-1);

for pair = MSN_pairs
    
    figure()
    hold on
    Curve_Taverna = plot(beta, Taverna_beta_pdf.(pair{1}), 'Linewidth', 2);
    CI_Taverna_curve = line(Taverna_beta_CI.(pair{1}), [-3 -3], 'LineWidth',2, 'HandleVisibility', 'off');
    Curve_Planert = plot(beta, Planert_beta_pdf.(pair{1}), 'Linewidth', 2);
    CI_Planert_curve = line(Planert_beta_CI.(pair{1}), [-6 -6], 'LineWidth',2, 'HandleVisibility', 'off');
    legend('Taverna', 'Planert')
    axis square
    
    if strcmp(pair{1}(2), '1') % ie if the presynaptic neuron is a D1 neuron
        xlim([0 0.2])
        Curve_Taverna.Color = cm(1,:);
        CI_Taverna_Curve.Color = cm(1,:);
        Curve_Planert.Color = cm(2,:);
        CI_Planert_Curve.Color = cm(2,:);
    else % ie if the presynaptic neuron is a D2 neuron instead
        xlim([0 0.2])
        Curve_Taverna.Color = cm(3,:);
        CI_Taverna_Curve.Color = cm(3,:);
        Curve_Planert.Color = cm(4,:);
        CI_Planert_Curve.Color = cm(4,:);
    end
    
    %saveas(gcf, ['../figures/beta posterior/' pair{1}], 'svg')
    
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