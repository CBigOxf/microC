%% GROWTH OF COMPETING CLONES (NO DIFFUSABLE SUBSTANCES)

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data.comp = [root '\Processed-Data\Growth-Comp-', experiment_mode, '-c100-r100-t2000.mat'];
file.data.iso = [root '\Processed-Data\Growth-Iso-', experiment_mode, '-c100-r100-t2000.mat'];

file.processed.comp = [root '\Growth\Processed-Data\Growth-Comp-', experiment_mode, '-c100-r100-t2000-Statistics.xlsx'];
file.processed.iso = [root '\Growth\Processed-Data\Growth-Iso-', experiment_mode, '-c100-r100-t2000-Statistics.xlsx'];

file.output.bars = [root '\Growth\Output\Growth-Comp-', experiment_mode, '-c100-r100-t2000-Bars'];
file.output.tms = [root '\Growth\Output\Growth-Comp-', experiment_mode, '-c100-r100-t2000-Tms'];


%% LOAD AND CLEAN DATA

load(file.data.comp, 'files', 'data', 'reporters');

nclones = 8;
nrepeats = 100;

data = data{1};
data(1,:) = [];                     % remove experimental repeat
data(:,sum(isnan(data)) > 0) = [];  % remove lists are shown as nans

clones = {'WT', 'EGFR+', 'p53-', 'PTEN-', 'p53-PTEN-',...
    'EGFR+PTEN-', 'EGFR+p53-', 'EGFR+p53-PTEN-'};


%% **************************** STATISTICS ********************************

%% ABSOLUTE NUMBERS (NUMBER OF CELLS)

cdata = cell(nclones,1);

for i=1:nclones
    cdata{i} = data(:,i:nclones:end);
end

stats.avg = cell2mat(cellfun(@(x) mean(x,2),cdata,'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),cdata,'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),cdata,'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),cdata,'UniformOutput',false)');

stats.clones = clones;

A = makesheet(stats);

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, A, '# Cells')


%% NORMALIZED DATA (FRACTIONS OF TOTAL POPULATION)

cx = cell(nrepeats,1);
idx = reshape(1:size(data,2),nclones,nrepeats)';

for i=1:nrepeats
    cx{i} = data(:,idx(i,:));
end

cxnorm = percnorm(cx);

statsnorm.avg = cmean(cxnorm);
statsnorm.std = cstd(cxnorm);
statsnorm.min = cmin(cxnorm);
statsnorm.max = cmax(cxnorm);

statsnorm.clones = clones;


A = makesheet(statsnorm);

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, A, 'Normalised')


%% **************************** FIGURES ***********************************

clear('data');

[data, txt] = xlsread(file.processed.comp,'# Cells');
avg = data(:,1:4:end);

colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;

marker = 'osxv+dp^';


%% GROWTH CURVES SPLIT IN TWO FIGURES

% Part 1
mask = [1 3 4 5];

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

axis([1 9 0 40])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:10:40,'yTickLabel',0:10:40);

hold off;
savefig([file.output.tms '-part1'],8.75,5); % supplementary
% savefig([file.output.tms '-part1'],4.6,3.3); %


% Part 2
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

axis([1 9 0 500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:100:500,'yTickLabel',0:100:500);

hold off;


savefig([file.output.tms '-part2'],8.75,5);
% savefig([file.output.tms '-part2'],5.6,3.3);




%% BAR CHART OF ISOLATED VS COMPETING CLONES (FINAL COUNTS)

clear data;

data.iso = xlsread(file.processed.iso,'Normalised');
data.comp = xlsread(file.processed.comp,'Normalised');

colors = [1 1 1; 0.17 0.55 0.75];

nrepeats = 100;

h = barwitherr([data.iso(end,2:4:end)' data.comp(end,2:4:end)']./sqrt(nrepeats),...
    [data.iso(end,1:4:end)' data.comp(end,1:4:end)']);

for k=1:size(colors,1)
    h(k).FaceColor = colors(k,:);
end


set(gca,...
    'FontSize',8,...
    'XTickLabel',' ',...
    'YTick',0:10:50)

box off;
axis([0.5 8.5  0 50])
ylabel('# cells [% in pop.]')

savefig(file.output.bars,9,3);


%% TESTING FOR SIGNIFICANCE ON BAR CHART

final_normalised.comp = cell2mat(cellfun(@(x) x(end,:), cxnorm, 'UniformOutput', false));


load(file.data.iso, 'data', 'reporters')           % all data are required
rep = 'count objects with [kind = "Cell"]';
keep = ~cellfun(@isempty,strfind(reporters,rep));
data = cellfun(@(x) x(2:end,keep),data,'UniformOutput',false);


final_normalised.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data, 'UniformOutput', false)'));

[p, stars] = check_significance(final_normalised.iso, final_normalised.comp);
disp(['Significance Levels: ' num2str(diag(stars)')])






