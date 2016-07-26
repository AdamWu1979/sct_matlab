function [ dBA, CR, ICC, CVintra, CVinter] = plot_bland_altman( measures1, measures2, show_fig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Defaults
if ~exist('show_fig','var') || isempty(show_fig)
    show_fig = 1; % display figure by default
end
 

% check if 'measures1' and 'measures2' are row vectors (if not transpose it):
if ~isrow(measures1)
    measures1 = measures1';
end
if ~isrow(measures2)
    measures2 = measures2';
end

measures_cat = cat(1,measures2,measures1);

average = mean(measures_cat);

diff_between_measures = diff(measures_cat,1,1);

% Plot the Bland-Altman graph
mean_diff = mean(diff_between_measures);
std_diff = std(diff_between_measures);


if show_fig == 0
    figure('visible','off');
else
    figure
end

hold on
plot(average, diff_between_measures, 'b.', 'MarkerSize',30.0)
plot(average, mean_diff*ones(1,length(average)),'b-', 'LineWidth',3.0)
plot(average, mean_diff+1.96*std_diff*ones(1,length(average)),'r:')
plot(average, mean_diff-1.96*std_diff*ones(1,length(average)),'r:')
hold off
[xa_nfu,ya_nfu] = ds2nfu([average(1),average(1)],[mean_diff-1.96*std_diff,mean_diff+1.96*std_diff]);
% annotation('doublearrow',[0.8,0.8],ya_nfu,'Color','red')
coord_tb = ds2nfu([max(average) mean_diff 1 1]);
% annotation('textbox', [0.8 coord_tb(2)+0.01 0.001 0.001],'String', '95%', 'Color','red');
coord_tb2 = ds2nfu([max(average) mean_diff 1 1]);
% annotation('textbox', [0.7 ya_nfu(1)-0.001 0.001 0.001],'String', '-1.96.STD', 'Color','red');
% annotation('textbox', [0.7 ya_nfu(2)+0.01 0.001 0.001],'String', '+1.96.STD', 'Color','red');
grid minor
xlabel('Average of the 2 measures', 'FontSize', 30.0);
ylabel('Difference between the 2 measures', 'FontSize', 30.0);
title('Bland-Altman plot', 'FontSize', 50.0)
set(gca,'FontSize',20);

% Compute the normalized Bland-Altman difference
dBA = 100*mean_diff/mean(average);
% Compute the Coefficient of Repeatability
CR = 1.96*sqrt(sum(diff_between_measures.^2)/length(diff_between_measures)); % maybe a *sqrt(2) missing
% Compute Intra-Class Correlation (ICC) coeff
intra_subj_var = mean(sum((measures_cat-repmat(average,2,1)).^2,1)); % different from mean(std(measures_cat,1).^2)
inter_subj_var = sum((average-mean(average)).^2)/(length(average)-1); % =std(mean(measures_cat,1))^2
ICC = inter_subj_var/(intra_subj_var+inter_subj_var);
% Compute intra- and inter-subjects Coefficient of Variation
CVintra = 100*(sqrt(intra_subj_var)/mean(average));
CVinter = 100*(sqrt(inter_subj_var)/mean(average));


end

