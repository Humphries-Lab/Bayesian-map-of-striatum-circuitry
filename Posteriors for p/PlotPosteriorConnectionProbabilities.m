% plots the figures of the different posteriors for p

clearvars
close all
% addpath('../../BrewerMap')

%% choose dataset and pairs of interest

source = 'Taverna';
prior = 'literature';
data = load([source ' posterior with ' prior ' prior.mat']);
%data = load([source '/' source ' posterior with ' prior ' prior.mat']);

%either detect all the pairs in the data or manually choose those you want

%list_of_pairs = fieldnames(data.posterior);
list_of_pairs = {'d1_dx', 'd2_dx'};

%% figure specs

% scheme_d1 = 'Blues';
% scheme_d2 = 'Reds';
% cm = colormap([brewermap(2,scheme_d1); brewermap(2,scheme_d2)]);
cm = colormap(lines);
close gcf

format = 'svg';

%% plot and save figure

figure()
hold on

for c = 1 : numel(list_of_pairs)
    pair = list_of_pairs{c};
    [n_repeats, n_p] = size(data.posterior.(pair).pdf); % number of repeated measurements of that pair, and number of values where p has been evaluated
    for i = 1 : n_repeats
        p = 0 : 1 / (n_p - 1) : 1;
        plot(p, data.posterior.(pair).pdf(i,:), 'LineWidth',2, 'Color', cm(c,:), 'DisplayName', pair)
        line(data.posterior.(pair).CI(i,:), [-0.5 -0.5] - c * 0.2, 'LineWidth',2, 'Color', cm(c,:), 'HandleVisibility', 'off')
    end
end

legend show
title(['P(connect) for ' source])
ylim([-0.5 - c * 0.2 - 0.5, 20])
axis square
% saveas(gcf, [source '/connection rates with ' prior ' prior.' format])

%% postface

% rmpath('../../../BrewerMap')