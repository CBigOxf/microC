%% CLONAL EVOLUTION FOR EGFR+, p53-, PTEN-
% First mutation introduced at t1 = 750, second mutation at t2 = 1500.
% Total duration of experiment 4000 steps

clearvars -except 'root'
clc; close all;


% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Clonal-Evolution-Tms-',experiment_mode,'-init50-c1-r100-t4000.mat'];
file.processed.bars = [root '\Clonal-Evolution\Processed-Data\CE-init50-c1-r100-t4000-Statistics.xlsx'];
file.output.bars = [root '\Clonal-Evolution\Output\CE-init50-c1-r100-t4000-Statistics-Stacked-Bars'];

%% LOAD AND FORMAT DATA PER POPULATION

load(file.data,'data','files','reporters');

nsteps = 4002;
npopulations = 3;

pop = cell(npopulations,1);

for mutation_group=1:npopulations
    rep = ['count objects with [kind = "Cell" and my-mutation-group = ',num2str(mutation_group),']'];
    is_group = ~cellfun(@isempty,strfind(reporters,rep));
    pop{mutation_group} = cell2mat(cellfun(@(x) x(nsteps,is_group), data, 'UniformOutput', false))';
end

total = pop{1} + pop{2} + pop{3};

%% ***************************** STATISTICS *******************************

for i=1:npopulations
    A = num2cell([zeros(1,size(pop{i},2)); pop{i}]);
    A(1,:) = files';
    
    warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
    xlswrite(file.processed.bars, A, ['Population-', num2str(i)])
end

A = num2cell([zeros(1,size(total,2)); total]);
A(1,:) = files';

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.bars, A, 'Total-Cells')


%% STACKED BAR PLOT

gw = 0.7; % 1.0 is touching
len = 1:3;

colors = colors_and_markers([1 2 7]);
colors = cell2mat(colors');


hold on;
h1 = bar(len - gw/4, [mean(pop{1}(:,1:2:end)); mean(pop{2}(:,1:2:end)); mean(pop{3}(:,1:2:end))]', gw/3, 'stacked');
h2 = bar(len + gw/4, [mean(pop{1}(:,2:2:end)); mean(pop{2}(:,2:2:end)); mean(pop{3}(:,2:2:end))]', gw/3, 'stacked');

for k = 1:size(colors,2)
    h1(k).FaceColor = colors(k,:);
    h2(k).FaceColor = colors(k,:);
end

set(gca,'XTickLabels','')
set(gca,'YTick',0:500:2500)

e = errorbar(len - gw/4, mean(total(:,1:2:end)), std(total(:,1:2:end))./size(total,1),'k.');
e = errorbar(len + gw/4, mean(total(:,2:2:end)), std(total(:,2:2:end))./size(total,1),'k.');

ylabel('Number of Cells')

box off;
set(gca,'FontSize',8);

savefig(file.output.bars,13.5,4.5);






