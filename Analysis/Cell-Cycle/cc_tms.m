
clearvars -except 'root'
clc; close all;


% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';
 
file.data = [root '\Processed-Data\Cell-Cycle-Tms-', experiment_mode, '-c100-r10-t10000.mat'];
file.processed = [root '\Cell-Cycle\Processed-Data\Cell-Cycle-Tms-', experiment_mode, '-c100-r10-t10000.xlsx'];
file.output = [root '\Cell-Cycle\Output\Cell-Cycle-Tms-', experiment_mode, '-c100-r10-t10000'];


%% LOAD AND CLEAN DATA

load(file.data)

rep = 'count objects with [kind = "Cell"]';
total_cells = ~cellfun(@isempty,strfind(reporters,rep));

data = cellfun(@(x) x(2:end,total_cells), data, 'UniformOutput', false);

nrepeats = 100;

clones = {'WT', 'EGFR+', 'p53-', 'PTEN-', 'p53-PTEN-',...
    'EGFR+PTEN-', 'EGFR+p53-', 'EGFR+p53-PTEN-'};

pc = {'pc0020','pc0050','pc0100','pc0200','pc0500','pc1000'};


%% WRITE TMS STATISTICS

stats.avg = cell2mat(cellfun(@(x) mean(x,2),data,'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),data,'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),data,'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),data,'UniformOutput',false)');
stats.clones = files;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed, makesheet(stats), '#Cell-Cycle')

%% *************************** FIGURES ***********************************


colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;

markers = '>o*xsd^v';


avg = cell2mat(cellfun(@(x) mean(x,2),data,'UniformOutput',false)');

figure;

for j=1:length(pc)
    
    idx = find(~cellfun(@isempty, strfind(files,pc{j})));
    
    subplot(3,2,j)
    
    hold on;
    
    for i=1:length(idx)
        plot(avg(1:1000:end,idx(i)),'color',colors(i,:),...
            'marker',markers(i),'MarkerFaceColor','White');
    end
    
    
    hold off;

    % legend is printed in different plot and cut and paste to figures
    
%     if(j==6) 
%         legend(cellfun(@(x) x(1:end-7),txt(1,idx),'UniformOutput',false),...
%     'location','SouthOutside',...
%     'Orientation','Horizontal',...
%     'FontSize',6)
%     end
    
    ax = axis;
    axis([1 11 ax(3:4)])
    
    
    title(['Decision Window: ' num2str(str2double((pc{j}(3:end)))) ' steps'])
    box on;
    xlabel('Cell Cycles')
    ylabel('Number of Cells')
    set(gca,'XTick',1:11,'XTickLabel',0:10);

    
end

savefig(file.output, 18, 23)
