%% GROWTH OF ISOLATED CLONES (OXYGEN DIFFUSION)

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000.mat'];

file.processed.xlsx = [root '\Growth\Processed-Data\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000-Statistics.xlsx'];

file.output.tms = [root '\Growth\Output\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000-Tms'];
file.output.bars = [root '\Growth\Output\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000-Bars'];


%% LOAD DATA OR READ FROM XLSX FILE

load(file.data, 'files','data', 'reporters')

rep1 = 'count objects with [kind = "Cell"]';
rep2 = 'count objects with [my-fate = "Necrosis"]';

total_cells = ~cellfun(@isempty,strfind(reporters,rep1));
necrotic = ~cellfun(@isempty,strfind(reporters,rep2));
nsteps = 2002; % use this number of steps (up to 2502)

data = cellfun(@(x) x(2:nsteps,total_cells) - x(2:nsteps,necrotic),data,'UniformOutput',false);

nrepeats = 100;
clones = {'WT', 'EGFR+', 'p53-', 'PTEN-', 'p53-PTEN-',...
    'EGFR+PTEN-', 'EGFR+p53-', 'EGFR+p53-PTEN-'};


%% **************************** STATISTICS ********************************
%% ABSOLUTE NUMBERS (NUMBER OF CELLS)

normoxia = data(1:8);
hypoxia = data(9:end);

statsnormoxia.avg = cell2mat(cellfun(@(x) mean(x,2),normoxia,'UniformOutput',false)');
statsnormoxia.std = cell2mat(cellfun(@(x) std(x,[],2),normoxia,'UniformOutput',false)');
statsnormoxia.min = cell2mat(cellfun(@(x) min(x,[],2),normoxia,'UniformOutput',false)');
statsnormoxia.max = cell2mat(cellfun(@(x) max(x,[],2),normoxia,'UniformOutput',false)');
statsnormoxia.clones = clones;


statshypoxia.avg = cell2mat(cellfun(@(x) mean(x,2),hypoxia,'UniformOutput',false)');
statshypoxia.std = cell2mat(cellfun(@(x) std(x,[],2),hypoxia,'UniformOutput',false)');
statshypoxia.min = cell2mat(cellfun(@(x) min(x,[],2),hypoxia,'UniformOutput',false)');
statshypoxia.max = cell2mat(cellfun(@(x) max(x,[],2),hypoxia,'UniformOutput',false)');
statshypoxia.clones = clones;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsnormoxia), '#Cells-Normoxia')

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statshypoxia), '#Cells-Hypoxia')




%% NORMALIZED DATA (FRACTIONS OF TOTAL POPULATION)

H = [hypoxia{1:8}];
N = [normoxia{1:8}];

cH = cell(nrepeats,1);
cN = cell(nrepeats,1);


for i=1:nrepeats
    cH{i} = H(:,i:100:end);
    cN{i} = N(:,i:100:end);
end


cHnorm = percnorm(cH);

statsHnorm.avg = cmean(cHnorm);
statsHnorm.std = cstd(cHnorm); 
statsHnorm.min = cmin(cHnorm);
statsHnorm.max = cmax(cHnorm); 
statsHnorm.clones = clones;


cNnorm = percnorm(cN); 

statsNnorm.avg = cmean(cNnorm);
statsNnorm.std = cstd(cNnorm); 
statsNnorm.min = cmin(cNnorm);
statsNnorm.max = cmax(cNnorm); 
statsNnorm.clones = clones;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsHnorm), 'Normalised-Hypoxia')


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsNnorm), 'Normalised-Normoxia')


%% **************************** FIGURES ***********************************

clear('data')
[data, txt] = xlsread(file.processed.xlsx,'#Cells-Hypoxia');

avg = data(:,1:4:end);

marker = 'osxv+dp^';

colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;


%% GROWTH CURVES (TWO PARTS)

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

axis([1 9 0 300])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:100:300,'yTickLabel',0:100:300);

hold off;

savefig([file.output.tms '-part1'],8.75,5);



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

axis([1 9 0 1500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:500:1500,'yTickLabel',0:500:1500);

hold off;

savefig([file.output.tms '-part2'],8.75,5);


%% BAR PLOT OF LIVING CELLS UNDER NORMOXIA AND HYPOXIA

clear data

[data.hypoxia, ~] = xlsread(file.processed.xlsx,'#Cells-Hypoxia');
[data.normoxia, ~] = xlsread(file.processed.xlsx,'#Cells-Normoxia');

ncount_avg = data.normoxia(end,1:4:end);
hcount_avg = data.hypoxia(end,1:4:end);

ncount_std = data.normoxia(end,2:4:end);
hcount_std = data.hypoxia(end,2:4:end);

figure;
color = colors_and_markers();
h = barwitherr([ncount_std' hcount_std']./sqrt(nrepeats),[ncount_avg' hcount_avg']);

h(1).FaceColor = 'White';
h(2).FaceColor = color{2};

% plot_sign_stars(h,stars,100); % offset 100
set(gca,'XtickLabel',{' '},...
    'YTick',0:500:2000,...
    'FontSize',8);
% ylabel('Number of Cells (alive)','FontSize',11)
% legend({'Control','Hypoxia'},'Location','NorthWest');
axis([0.5 8.5 0 2000])
box off;

savefig(file.output.bars,9,3.5);


%% CHECK FOR SIGNIFICANCE

final_counts.hypoxia = cell2mat(cellfun(@(x) x(end,:), cH, 'UniformOutput', false));
final_counts.normoxia = cell2mat(cellfun(@(x) x(end,:), cN, 'UniformOutput', false));

[p, stars] = check_significance(final_counts.hypoxia, final_counts.normoxia);
disp(['Significance Levels: ' num2str(diag(stars)')])























