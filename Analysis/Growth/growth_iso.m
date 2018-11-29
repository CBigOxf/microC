%% GROWTH OF ISOLATED CLONES (NO DIFFUSABLE SUBSTANCES)

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Growth-Iso-', experiment_mode, '-c100-r100-t2000.mat'];

file.processed.xlsx = [root '\Growth\Processed-Data\Growth-Iso-',experiment_mode ,'-c100-r100-t2000-Statistics.xlsx'];
file.output.tms = [root '\Growth\Output\Growth-Iso-',experiment_mode ,'-c100-r100-t2000-Tms'];


%% LOAD AND CLEAN DATA

load(file.data, 'files', 'data', 'reporters') % skip cell arrays

rep = 'count objects with [kind = "Cell"]';
keep = ~cellfun(@isempty,strfind(reporters,rep));

data = cellfun(@(x) x(2:end,keep),data,'UniformOutput',false);

nclones = length(files);
nreporters = 1;
nrepeats = 100;

%% **************************** STATISTICS ********************************
%% ABSOLUTE NUMBERS (NUMBER OF CELLS)

stats.avg = cell2mat(cellfun(@(x) mean(x,2),data,'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),data,'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),data,'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),data,'UniformOutput',false)');

stats.clones = files;

A = makesheet(stats);

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, A, '# Cells')


%% NORMALIZED DATA (POPULATION FRACTIONS)

x = [data{1:8}];

cx = cell(nrepeats,1);

for i=1:nrepeats
    cx{i} = x(:,i:nrepeats:end);
end

cxnorm = percnorm(cx); 

statsnorm.avg = cmean(cxnorm);
statsnorm.std = cstd(cxnorm); 
statsnorm.min = cmin(cxnorm);
statsnorm.max = cmax(cxnorm); 

statsnorm.clones = files;


A = makesheet(statsnorm);
xlswrite(file.processed.xlsx, A, 'Normalised')



%% **************************** FIGURES ***********************************

clear('data');

[data, txt] = xlsread(file.processed.xlsx,'# Cells');
avg = data(:,1:4:end);

colors = [128,128,128;...
    142,123,122;...
    155,117,115;...
    169,112,109;...
    182,107,103;...
    196,102,97;...
    209,96,90;...
    223,91,84]/255;

marker = 'osxv+dp^';


%% GROWTH CURVES (ONE FIGURE)

figure;
hold on;

for i=1:size(avg,2)
    plot(avg(1:250:end,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',marker(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 2000])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:500:2000,'yTickLabel',0:500:2000);

hold off;

savefig(file.output.tms,8.75,5);


%% GROWTH CURVES (TWO FIGURES)


colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;

% Part 1
mask = [1 3  4 5];

figure;
hold on;

for i = mask
    plot(avg(1:250:end,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',marker(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 300])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:100:300,'yTickLabel',0:100:300);

hold off;
legend(files(mask))
savefig([file.output.tms '-part1'],8.75,5);


%% Part 2
mask = [2 6 7 8];

figure;
hold on;

for i = mask
    plot(avg(1:250:end,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',marker(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 2000])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:500:2000,'yTickLabel',0:500:2000);

hold off;
legend(files(mask))

savefig([file.output.tms '-part2'],8.75,5);




