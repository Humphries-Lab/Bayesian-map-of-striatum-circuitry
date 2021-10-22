% launches monte-carlo simulations of sampling pairs of neurons within a
% given radius and with an exponential decay probability of connection
% given by arbitrary parameter beta

%% introduction

clearvars
close all

%% choose dataset you want to try and replicate, and number of simulations

study = 'Planert';
neuron = 'd2';
n_simulations = 10000;

%% get the number of samples (n) and of positive tests, as well as value of beta

load(['Posteriors for p/' study ' data.mat'])
if strcmp(neuron, 'd1')
    n_pairs = d1_dx.n;
    target_k = d1_dx.x;
    beta = 0.075; % this is the value of beta for the interception of the posterior curves for beta_D1 according to Taverna and Planert
elseif strcmp(neuron, 'd2')
    n_pairs = d2_dx.n;
    target_k = d2_dx.x;
    beta = 0.045; % same as above using posteriors for beta_D2
end

%% distance over which sampling takes place

if strcmp(study, 'Planert')
    max_distance = 100;
elseif strcmp(study, 'Taverna')
    max_distance = 50;
end

x = 0 : 0.1 : max_distance;
Prob =@(x) exp(-beta * x);

% plot probability of connection function for verification

figure()
plot(x, Prob(x))

n_connections = zeros(n_simulations, 1);

for s = 1 : n_simulations
    
    % generate a vector of random distances assuming equiprobable sampling
    % i.e. f(x) = 2x / R^2
    d = pdfrnd(x, 2*x / max_distance^2, n_pairs);
    
    % get corresponding probabilities of connection
    p = Prob(d);
    
    % for each distance, randomly decide whether it is connected based on p
    % and add up number of found connections in this simulation
    for t = 1 : n_pairs
        rnd = rand();
        if rnd < p(t)
            n_connections(s) = n_connections(s) + 1;
        end
    end
end

%% add up the number of simulations which give each possible outcome (e.g. k = 5 out of 40 pairs)

K = zeros(n_pairs+1,1); % possible values of k are 0, 1, 2, ..., n
i = 1;
for k = 0 : n_pairs
    a = n_connections == k;
    K(i) = sum(a);
    i = i + 1;
end

%% plot histogram of results

figure()
h=bar(K, 1, 'FaceColor', 'b');
h.FaceColor = 'flat';
h.CData(target_k,:) = [50,0,0];
xlabel(['Number of connections among ' num2str(n_pairs) ' tested pairs'])
ylabel('Number of simulations')
axis square
xlim([0 n_pairs/2])
