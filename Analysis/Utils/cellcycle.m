clear; clc; close all;
root = 'C:\Users\dvoukantsis\Google Drive\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';
% 
file.raw.xlsx = [root 'Raw Data\Cell-Cycle-Reversible-c100-r10-t10000.xlsx'];
file.raw.mat = [root 'Raw Data\Cell-Cycle-Reversible-c100-r10-t10000.mat'];

file.raw.states = [root 'Raw Data\States-Cell-Cycle\'];

%% Cell-Cycle Reversible cell-fate decisions (per cell type)

clearvars -except file root ; clc; close all;
load(file.raw.mat)

cell_type = {'-WT-','-EGFR-','-p53-','-PTEN-','-p53PTEN-','-EGFRPTEN-','-EGFRp53-','-EGFRp53PTEN-'};

markers = {'k','r','b','g','y','m','.k-','.r-','.b-'};


for j=1:length(cell_type)
    
    idx = find(~cellfun(@isempty, strfind(x(:,1),cell_type{j})));
    
    subplot(4,2,j)
    
    hold on;
    
    for i=1:length(idx)
        plot(mean(x{idx(i),2}(2:1000:end,1:6:end),2),markers{i})
    end
    
    hold off;
    
    if (j == 4)
        legend(cellfun(@(x) x(6:end), x(idx,1),'UniformOutput',false),...
            'location','NorthWest','FontSize',8)
        
    end
    title(cell_type{j})
    box on;
    xlabel('Cell Cycles')
    ylabel('Number of Cells')
    
end

%%


clearvars -except file root ; clc; %close all;
load(file.raw.mat)


pc = {'20pc','50pc','100pc','200pc','500pc','1000pc'};

markers = {'k','r','b','g','y','m','.k-','.r-','.b-'};

figure;
for j=1:length(pc)
    
    idx = find(~cellfun(@isempty, strfind(x(:,1),pc{j})));
    
    subplot(3,2,j)
    
    hold on;
    
    for i=1:length(idx)
        plot(mean(x{idx(i),2}(2:1000:end,1:6:end),2),markers{i})
    end
    
    hold off;
    
    if (j == 4)
        legend(cellfun(@(x) x(1:end-6), x(idx,1),'UniformOutput',false),...
            'location','NorthWest','FontSize',8)
        
    end
    title(pc{j})
    box on;
    xlabel('Cell Cycles')
    ylabel('Number of Cells')
    
end


%%

clearvars -except file root ; clc; close all;


% x = import_experiment(file.raw.xlsx);

cell_type = {'WT',...
    'EGFR',...
    'p53',...
    'PTEN',...
    'p53PTEN',...
    'EGFRPTEN',...
    'EGFRp53',...
    'EGFRp53PTEN'};

pc = {'20pc','50pc','100pc','200pc','500pc','1000pc'};

label = {'WT',...
    'EGFR+',...
    'p53-',...
    'PTEN-',...
    'p53-PTEN-',...
    'EGFR+PTEN-',...
    'EGFR+p53-',...
    'EGFR+p53-PTEN-'};

nodes = {'ERK', 'p38', 'JNK', 'p53', 'p21', 'TGFBR', 'EGFR', 'FGFR3',...
    'ATM', 'TAOK', 'MAX', 'GRB2', 'FRS2', 'PI3K', 'AP1', 'PPP2CA',...
    'MEK12', 'DUSP1', 'MYC', 'AKT', 'PLCG', 'PKC', 'GADD45', 'ELK1',...
    'FOS', 'ATF2', 'JUN', 'MSK', 'CREB', 'RSK', 'SMAD','MTK1', 'SPRY',...
    'RAF', 'GAB1', 'PDK1', 'p70', 'p14', 'FOXO3', 'RAS', 'SOS', 'MDM2',...
    'BCL2', 'TAK1', 'MAP3K13', 'PTEN', 'HIF1','Proliferation','Apoptosis',...
    'Growth Arrest'};


states = cell(length(length(cell_type) * length(pc)),2);

counter = 0;

for i=1:length(cell_type)
    
    for j=1:length(pc)
        counter = counter + 1;
        file_name = [file.raw.states 'Cell-Cycle-' cell_type{i} '-' pc{j} '.txt'];
        disp(['Processing file: ' file_name])
        
        states{counter,1} = [cell_type{i} '-' pc{j}];
        states{counter,2} = load_states(file_name);
    end
    
end




%%

for i = 1:size(states,1)
    disp(i)
    temp = cellfun(@(x) transpose(x), states{i,2},'uniformoutput',false);
    x = [temp{:}]';
    %     x = temp{i,1}';
    
    [~,~,perm] = dendrogram(linkage(x),size(x,1));
    x = x(perm,:);
    
    heatdata{i} = x;
    
    
end

close all;

%%

wg = [255 255 255; 89 89 89]/255;

for i=1:length(heatdata)
    
    subplot(8,6,i)
    colormap(wg)
    h = imagesc(64*heatdata{i});
    caxis([0 4])
    axis off
    hold on;
    ax = axis;
    plot([ax(1) ax(1)],[ax(3) ax(4)],'k')
    plot([ax(2) ax(2)],[ax(3) ax(4)],'k')
    plot([ax(1) ax(2)],[ax(3) ax(3)],'k')
    plot([ax(1) ax(2)],[ax(4) ax(4)],'k') 
    title(states{i,1})
    %     xlabel('Genes')
    %     ylabel('Cells')
%     savefig([file.output.heatmap '-' labels{i}],4.4,3.2)
end

% savefig(file.output.heatmap,4,3.2)

