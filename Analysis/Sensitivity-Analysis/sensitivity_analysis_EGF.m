%% SENSITIVITY ANALYSIS FOR DIFFUSABLES (EGF)
% EGF sensitivity analysis with p53-PTEN- clone
% O2 sensitivity analysis with EGFR+p53- clone

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Sensitivity-Analysis-EGF-', experiment_mode, '-c500-r10-t3000.mat'];
file.processed.EGF = [root '\Sensitivity-Analysis\Processed-Data\Sensitivity-Analysis-EGF-', experiment_mode, '-c100-r10-t2000-Statistics.xlsx'];
file.output.EGF = [root '\Sensitivity-Analysis\Output\Sensitivity-Analysis-', experiment_mode, '-c500-r10-t2000-EGF-heatmap'];


%% **************************** # CELLS ***********************************
%% LOAD AND CLEAN EGF DATA

load(file.data, 'files','data', 'reporters')

rep1 = 'count objects with [kind = "Cell"]';
rep2 = 'count objects with [my-fate = "Necrosis"]';

total_cells = ~cellfun(@isempty,strfind(reporters,rep1));
necrotic_cells = ~cellfun(@isempty,strfind(reporters,rep2));

data = cellfun(@(x) x(2:end,total_cells) - x(2:end,necrotic_cells), data, 'UniformOutput', false);

nrepeats = 10;
nsteps = 2001;
data_avg = cell2mat(cellfun(@(x) mean(x(nsteps,:),2),data,'UniformOutput',false)');

%% Save statistics

stats.avg = cell2mat(cellfun(@(x) mean(x,2),data,'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),data,'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),data,'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),data,'UniformOutput',false)');
stats.clones = files;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.EGF, makesheet(stats), 'EGF')


%% ***************************** FIGURES **********************************
% image plot

R = unique(cellfun(@(x) x(6:11),files,'UniformOutput',false));
[~, idx] = sort(str2double(R),'descend');
R = R(idx);

ACT = unique(cellfun(@(x) x(16:21),files,'UniformOutput',false));
[~, idx] = sort(str2double(ACT));
ACT = ACT(idx);


for i=1:length(R)
    for j=1:length(ACT)
        files_table{i,j} = ['EGF-R', R{i}, '-ACT', ACT{j}];
        idx = find(~cellfun(@isempty, strfind(files,files_table{i,j})));
        cells_table(i,j) = data_avg(idx);
    end
end


s.data = cells_table;
s.xlabel = ACT;
s.ylabel = R;
myheatmap(s);

colormap(colorGradient([1 1 1], [224 95 88]/255, 64))
xlabel('Activation Threshold (ACT_{EGF})')
ylabel('Consumption Rate (R_{EGF})')

c = colorbar('NorthOutside');
c.Label.String = '# Cells';
c.Label.FontSize = 8;



savefig(file.output.EGF,7,8);


