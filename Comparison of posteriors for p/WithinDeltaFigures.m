function WithinDeltaFigures(data, pairings, cm)

n_tests = size(pairings, 1);
[n_stages, n_steps] = size(data.posterior.(pairings{1,1}).pdf);
step = 1 / (n_steps - 1);

for stage = 1 : n_stages
    
    for test = 1 : n_tests
        
        p(test,:) = Delta_pdf(data.posterior.(pairings{test,1}).pdf(stage, :), data.posterior.(pairings{test,2}).pdf(stage, :), step);
        label(test) = {[pairings{test,1} ' vs ' pairings{test,2}]};
        figure()
        plot(-1:0.001:1 , p(test,:), 'color', cm(2,:), 'Linewidth', 2)
        %title([data.folder_name ' '  label{test}])
        xlim([-0.5 0.5])
        xticks(-0.5 : 0.1 : 0.5)
        axis square
        
%         if n_stages > 1
%             saveas(gcf, ['figures/Probability difference/Bayesian delta/' data.folder_name '/' label{test} ' at stage ' num2str(stage)], 'svg')
%         else
%             saveas(gcf, ['figures/Probability difference/Bayesian delta/' data.folder_name '/' label{test}], 'svg')
%         end
        
    end
end