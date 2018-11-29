%% GENERATES HEATMAPS FROM ACTIVATION PROFILES 

% Reads txt state files from a folder, sorts the states, saves into xlsx,
% and generates heatmaps of saved data

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_code = 'R-c100-r100-t5000';

file.data.states = [root '\Processed-Data\Dynamics-States-',experiment_code];
file.processed.xlsx = [root '\Dynamics\Processed-Data\Dynamics-States-' experiment_code, '.xlsx'];
file.output.heatmap = [root '\Dynamics\Output\Dynamics-States-' experiment_code];


%% *********************** GENERATING HEATMAP DATA ************************
%% LOADING DATA FROM FOLDERS

load(file.data.states);

% clearvars -except file root ; clc; close all;
% 
% files = dir(file.raw.states.folder);
% files(1:2) = []; % pattern directories
% 
% 
% % NOTE: HIF1 is not in the list, as well as in MAPK_gene_order.
% 
% nodes = {'ERK', 'p38', 'JNK', 'p53', 'p21', 'TGFBR', 'EGFR', 'FGFR3',...
%     'ATM', 'TAOK', 'MAX', 'GRB2', 'FRS2', 'PI3K', 'AP1', 'PPP2CA',...
%     'MEK1_2', 'DUSP1', 'MYC', 'AKT', 'PLCG', 'PKC', 'GADD45', 'ELK1',...
%     'FOS', 'ATF2', 'JUN', 'MSK', 'CREB', 'RSK', 'SMAD','MTK1', 'SPRY',...
%     'RAF', 'GAB1', 'PDK1', 'p70', 'p14', 'FOXO3', 'RAS', 'SOS', 'MDM2',...
%     'BCL2', 'TAK1', 'MAP3K1_3', 'PTEN', 'Proliferation','Apoptosis',...
%     'Growth Arrest'};
% 
% % Import and process txt files 
% 
% states = cell(length(files),2);
% 
% for i=1:length(files)
%     
%     file_name = [file.raw.states.folder files(i).name];
%     disp(['Processing file: ' file_name])
%     
%     states{i,1} = files(i).name(17:end-4);
%     states{i,2} = load_states(file_name);
%     
% end


%% MERGE ALL STATES PER CLONE AND SORT BY CELL-FATE DECISION AND SIMILARITY

for i = 1:length(files)
    
    disp(['Sorting: ' files{i}])
    
    temp = cellfun(@(x) transpose(x), data{i},'uniformoutput',false);
    x = [temp{:}]';
%     x = temp{i,1}'; % Display only first replicant
    
    proliferation = x(x(:,end-2) == 1,:);
    apoptosis = x(x(:,end-1) == 1,:);
    growth_arrest = x(x(:,end) == 1,:);
    no_decision = x(x(:,end-2) == 0 & x(:,end-1) == 0 & x(:,end) == 0,:);
    
    if(size(proliferation,1) > 1)
        [~,~,perm] = dendrogram(linkage(proliferation),size(proliferation,1));
        proliferation = proliferation(perm,:);
    end
    
    if(size(growth_arrest,1) > 1)
        [~,~,perm] = dendrogram(linkage(growth_arrest),size(growth_arrest,1));
        growth_arrest = growth_arrest(perm,:);
    end
    
    if(size(apoptosis,1) > 1)
        [~,~,perm] = dendrogram(linkage(apoptosis),size(apoptosis,1));
        apoptosis = apoptosis(perm,:);
    end
    
    if(size(no_decision,1) > 1)
        [~,~,perm] = dendrogram(linkage(no_decision),size(no_decision,1));
        no_decision = no_decision(perm,:);
    end
    
    heatdata{i,1} = [proliferation; apoptosis; growth_arrest; no_decision];
    
end

close all;


%% SAVE STATE DATA INTO FILE

clc;
warning('off')

for i=1:length(files)
    
    disp(['Writing: ' files{i}])
    A = [zeros(1,length(genes)); heatdata{i}];
    A = num2cell(A);
    A(1,:) = genes;
   
    xlswrite(file.processed.xlsx,A,files{i});
    
end


%% **************************** HEATMAPS **********************************
%% IMPORT DATA

% [~,sheet] = xlsfinfo(file.processed.xlsx);
% sheet(~cellfun(@isempty,strfind(sheet,'Sheet1'))) = []; % remove default sheet made by excel
% 
% 
% for i=1:length(sheet)
%     disp(sheet{i})
%     heatdata{i,1} = xlsread(file.processed.xlsx,sheet{i});
% end


%% GENERATE HEATMAPS

% colormap: white, grey, green, red, yellow
wggyr = [255 255 255; ...
    89 89 89; ...
    122 192 99; ...
    223 91 84; ...
    240 240 90]/255;


for i=1:length(files)
    
    figure;
    colormap(wggyr)
    
    % Color coding cell-fate decisions
    heatdata{i,1}(heatdata{i,1}(:,end-2)==1,end-2) = 2;   % proliferation
    heatdata{i,1}(heatdata{i,1}(:,end-1)==1,end-1) = 3;   % apoptosis
    heatdata{i,1}(heatdata{i,1}(:,end)==1,end) = 4;       % growth arrest
    
    h = imagesc(heatdata{i,1});
    caxis([0 4])
    hold on;
    
    ax = axis;
    plot([ax(1) ax(1)],[ax(3) ax(4)],'k')
    plot([ax(2) ax(2)],[ax(3) ax(4)],'k')
    plot([ax(1) ax(2)],[ax(3) ax(3)],'k')
    plot([ax(1) ax(2)],[ax(4) ax(4)],'k')
    
%     axis off;
%     title(files{i})
    %     xlabel('Genes')
    %     ylabel('Cells')
    
    savefig([file.output.heatmap '-' files{i}],3.7,2.6)
    
end






