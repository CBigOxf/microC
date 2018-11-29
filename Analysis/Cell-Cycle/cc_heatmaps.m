%% GENERATES HEATMAPS FROM ACTIVATION PROFILES 

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Cell-Cycle-States-',experiment_mode,'-c100-r10-t10000.mat'];
file.processed = [root '\Cell-Cycle\Processed-Data\Cell-Cycle-States-' experiment_mode '-c100-r10-t10000.xlsx'];
file.output = [root '\Cell-Cycle\Output\Cell-Cycle-States-' experiment_mode, '-c100-r10-t10000'];

%% LOAD AND SELECT DATA

load(file.data)


%% MERGE STATES, AND SORT BY DECISION (FIRST), SIMILARITY (SECOND)
clc;

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
    
    heatdata{i,1} = [proliferation; growth_arrest; apoptosis; no_decision];
    
end

close all;


%% EXPORT XLSX

clc;
warning('off') %#ok<WNOFF>

for i=1:length(files)
    disp(['Writing: ' files{i}])
    A = [zeros(1,length(genes)); heatdata{i}];
    A = num2cell(A);
    A(1,:) = genes;
    xlswrite(file.processed, A, files{i});
end


%% *********************** FIGURES ****************************************
% Heatmaps for # steps per cycle and clones


wggyr = [255 255 255;...  % white, grey, green, red, yellow
         89 89 89; ...
         122 192 99; ...
         223 91 84; ...
         240 240 90]/255;

for i=1:length(files)
    
    figure;
    colormap(wggyr)

    h = imagesc(heatdata{i,1}(:,1:end-3));
    caxis([0 4])
    hold on;
    
    ax = axis;
    plot([ax(1) ax(1)],[ax(3) ax(4)],'k')
    plot([ax(2) ax(2)],[ax(3) ax(4)],'k')
    plot([ax(1) ax(2)],[ax(3) ax(3)],'k')
    plot([ax(1) ax(2)],[ax(4) ax(4)],'k') 
    
    axis off;
%     title(label{i})
%     xlabel('Genes')
%     ylabel('Cells')
    
    savefig([file.output, '-' files{i}], 4, 3)

end

