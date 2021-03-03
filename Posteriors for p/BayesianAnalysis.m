% this script uses a Bayesian method to determine the posterior
% probabilities of MSN connections given a chosen dataset and a chosen
% prior.

%% prelude

clearvars
close all

%% select dataset: Taverna, Planert, Krajeski, Cepeda, Combined etc.

source = 'Planert';
data = load([source ' data']);

% folder_name = source;
% %data = load([folder_name '/' source ' data']);
% data = load([folder_name '/HD model data']);

%% introduction

prior = 'literature';
alpha = 0.05; % confidence level for the credibility interval eg 5% for a 95% credibility interval
p = 0 : 0.001 : 1; % values of p at which I want the posterior function evaluated

%% define prior parameters

switch prior % in each case set prior parameters for the beta (a and b)
    
    case 'Haldane'
        prior_a = 0;
        prior_b = 0;
        
    case 'uniform'
        prior_a = 1;
        prior_b = 1;
        
    case 'Jeffreys' % should check whether this is the real Jeffreys prior for Dirichlet distribution
        prior_a = 1/2;
        prior_b = 1/2;
        
    case 'literature'
        m = (13 + 2 + 5 + 39) / (38 * 2 + 38 * 2 + 325);
        % average number of connections between SPNs from Taverna et al 2004 (13 unidirectional connections + 1 bidirectional in 38 pairs), Czubayko and Plenz 2002 (5 connected pairs out of 38), and Koos et al 2004 (39 unidirectional connections for 325 tested pairs)
        v = 0.005; % desired variance
        prior_a = m * (m * (1-m) - v) / v;
        prior_b = prior_a * (1 - m) / m;
        
end

%% plot prior to check shape

format = 'svg';

prior_pdf = betapdf(p, prior_a, prior_b);
figure()
plot(p, prior_pdf, 'LineWidth',1.5)
title([prior ' prior'])
axis square

% savefig(['figures of priors/' prior])
% saveas(gcf, ['figures of priors/' prior], format)

%% compute posterior pdfs for P(connect) of each pair

list_of_pairs = fieldnames(data);

for c = 1 : numel(list_of_pairs)
    pair = list_of_pairs{c};
    n_repeats = length(data.(pair).n); % number of times this pair has been assessed in this study, eg 3 different development stages in Krajeski
    for i = 1 : n_repeats
        [posterior.(pair).pdf(i,:), posterior.(pair).CI(i,:), posterior.(pair).MAP(i,:), posterior.(pair).a(i,:), posterior.(pair).b(i,:)] = CalculatePosterior(prior_a, prior_b, data.(pair).x(i), data.(pair).n(i), alpha, p);
    end
end 

%% postface

save([source ' posterior with ' prior ' prior'], 'posterior')
%save([source '/' source ' posterior with ' prior ' prior'], 'posterior', 'folder_name')