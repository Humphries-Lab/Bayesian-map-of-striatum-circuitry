function BetweenDeltaFigures(data1, data2, pairs, cm)

n_tests = length(pairs);
%label = [data1.folder_name ' vs ' data2.folder_name];

figure()
hold on
for test = 1 : n_tests
    n_steps = length(data1.posterior.(pairs{1,test}).pdf);
    step = 1 / (n_steps - 1);
    p(test,:) = Delta_pdf(data1.posterior.(pairs{test}).a,...
        data1.posterior.(pairs{test}).b,...
        data2.posterior.(pairs{test}).a,...
        data2.posterior.(pairs{test}).b,...
        step);
    plot(-1: step : 1 , p(test,:), 'Color', cm(test, :), 'LineWidth',2)
end
legend(pairs)
%title(label)
xlim([-0.5 0.5])
xticks(-0.5 : 0.1 : 0.5)
axis square
%saveas(gcf, ['figures/Probability difference/Bayesian delta/Cross-comparisons/' label], 'svg')