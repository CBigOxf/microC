%% GENERATES TIMESERIES PLOTS FOR EACH CLONE

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Dynamics-Tms-' experiment_mode '-c100-r100-t5000.mat'];
file.processed.xlsx = [root '\Dynamics\Processed-Data\Dynamics-Tms-' experiment_mode '-c100-r100-t5000.xlsx'];
file.output.tms = [root '\Dynamics\Output\Dynamics-Tms-' experiment_mode,'-c100-r100-t5000'];
file.output.pie = [root '\Dynamics\Output\Dynamics-Pie-' experiment_mode,'-c100-r100-t5000'];


%% IMPORTING AND SHAPING DATA

load(file.data)

nclones = length(files);
nreporters = 5;  % Proliferation, Growth Arrest, Apoptosis, Necrosis, No Decision
nrepeats = 100;


%% **************************** STATISTICS ********************************
%% SUMMARY STATISTICS FOR FINAL TIME POINT

% Final decision count for each clone
temp = cellfun(@(x) x(end,:),data,'UniformOutput',false);
finaldata = cellfun(@(x) reshape(x,[nreporters,nrepeats])',temp,'UniformOutput',false);

M = cell2mat(cellfun(@mean,finaldata,'UniformOutput',false));
S = cell2mat(cellfun(@std,finaldata,'UniformOutput',false));

M = M(:,[1 3 2 5]); % remove necrosis, reorder Ap. and GA
S = S(:,[1 3 2 5]);

% Preparing excel sheet
n = size(M,1);
m = 2*size(M,2);

A = zeros(n,m);
A(:,1:2:m) = M; A(:,2:2:m) = S;
A = [zeros(2,m); A]; A = [zeros(n+2,1) A];
A = num2cell(A);

A(1,:) = {' ','Proliferation',' ','Apoptosis',' ','Growth Arrest',' ','No decision',' '};
A(2,:) = {' ','Mean','Std','Mean','Std','Mean','Std','Mean','Std',};
A(3:end,1) = files';


xlswrite(file.processed.xlsx,A,'Statistics-Final');


%% TIMESERIES SUMMARIES (AVG, STD, MIN, MAX)

reshapedata = cellfun(@(x) x(2:end,:),data,'UniformOutput',false);

stat.avg = cellfun(@(x) [mean(x(:,1:nreporters:end),2)...
    mean(x(:,2:nreporters:end),2)...
    mean(x(:,3:nreporters:end),2)...
    mean(x(:,5:nreporters:end),2)]...
    ,reshapedata,'UniformOutput',false);

stat.std = cellfun(@(x) [std(x(:,1:nreporters:end),[],2)...
    std(x(:,2:nreporters:end),[],2)...
    std(x(:,3:nreporters:end),[],2)...
    std(x(:,5:nreporters:end),[],2)]...
    ,reshapedata,'UniformOutput',false);

stat.min = cellfun(@(x) [min(x(:,1:nreporters:end),[],2)...
    min(x(:,2:nreporters:end),[],2)...
    min(x(:,3:nreporters:end),[],2)...
    min(x(:,5:nreporters:end),[],2)]...
    ,reshapedata,'UniformOutput',false);

stat.max = cellfun(@(x) [max(x(:,1:nreporters:end),[],2)...
    max(x(:,2:nreporters:end),[],2)...
    max(x(:,3:nreporters:end),[],2)...
    max(x(:,5:nreporters:end),[],2)]...
    ,reshapedata,'UniformOutput',false);

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist

C = [];

for i=1:size(data,1)
    
    A = [];
    for j=1:4
        A = [A stat.avg{i}(:,j) stat.std{i}(:,j) stat.min{i}(:,j) stat.max{i}(:,j)];
    end
    
    C = [C A];
    
end


C = num2cell([zeros(3,size(C,2)); C]); % dummy rows to be replaced


C(1,:) = cell(1,size(C,2));
C(1,:) = repmat({' '},1,size(C,2));
C(1,1:16:end) = files';

A = {'Proliferation',' ',' ',' ','Growth Arrest',' ',' ',' ','Apoptosis',' ',' ',' ','No decision',' ',' ',' '};
C(2,:) = repmat(A(:),19,1)';

C(3,:) = repmat({'Mean','Std','Min','Max'},1,4*length(files));


xlswrite(file.processed.xlsx,C,'Statistics-Tms');



%% **************************** FIGURES ***********************************

[~,sheet] = xlsfinfo(file.processed.xlsx);
[data,txt] = xlsread(file.processed.xlsx,sheet{end});


% TNBC clones
% idx = [257; 1; 273; 241; 289; 49; 97; 113];

% All clones
clones = txt(1,1:16:end);
idx = 1:16:size(txt,2);


for i=1:length(idx)
    cidx{i} = idx(i):4:idx(i)+15;
end

colors = [122 192 99; 240 240 90; 223 91 84; 164 164 164]/255;


for i=1:length(clones)
    
    figure;
    colormap(colors)
    h = bar(data(:,cidx{i}),'stacked');
    
    for k = 1:size(colors,1)
        h(k).FaceColor = colors(k,:);
    end
    
    axis([0 5000 0 100])
    box on;
    
    %     ylabel('Number of Cells');
    %     xlabel('Time [steps]');
    title(clones{i})
    set(gca,'FontSize',8,....
        'XTick',0:2500:5000,...
        'YTick',0:20:100)
    
    savefig([file.output.tms '-' files{i}],5,3.5);
    
end

%% Pie Charts

colors = [122 192 99; 240 240 90; 223 91 84; 164 164 164]/255;

mask = [17 1 18 16 19 4 7 8];

for i=1:length(mask)
    figure;
    colormap(colors)
    pie_data = data(105,cidx{mask(i)});
    pie_data(pie_data == 0) = 1e-8;
    h = pie(pie_data,{'','','',''});
    for j=1:2:length(h); h(j).LineStyle = 'none'; end
    axis off;
    savefig([file.output.pie '-' files{mask(i)}],5,5);
    
end






















