%% GROWTH OF ISOLATED CLONES (OXYGEN AND EGF DIFFUSION)

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Growth-HypoxiaSign-Iso-',experiment_mode,'-c500-r100-t2000.mat'];

file.processed.xlsx = [root '\Growth\Processed-Data\Growth-HypoxiaSign-Iso-',experiment_mode,'-c500-r100-t2000-Tms.xlsx'];

file.output.tms = [root '\Growth\Output\Growth-HypoxiaSign-Iso-',experiment_mode,'-c500-r100-t2000-Tms'];
file.output.bars = [root '\Growth\Output\Growth-HypoxiaSign-Iso-',experiment_mode,'-c500-r100-t2000-Bars'];


%% LOAD DATA OR READ FROM XLSX FILE

load(file.data)

rep1 = 'count objects with [kind = "Cell"]';
rep2 = 'count objects with [my-fate = "Necrosis"]';

total_cells = ~cellfun(@isempty,strfind(reporters,rep1));
necrotic = ~cellfun(@isempty,strfind(reporters,rep2));
nsteps = 2002; % use this number of steps (up to 2002)

data = cellfun(@(x) x(2:nsteps,total_cells) - x(2:nsteps,necrotic),data,'UniformOutput',false);

clones = {'WT','p53-','PTEN-','p53-PTEN-'};
nclones = length(clones);
nrepeats = 100;


%% **************************** STATISTICS ********************************
%% ABSOLUTE NUMBERS (NUMBER OF CELLS)

normoxia = data(1:4);
hypoxia = data(5:8); 
hypoxia_signalling = data(9:end); 

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

statshypoxiasign.avg = cell2mat(cellfun(@(x) mean(x,2),hypoxia_signalling,'UniformOutput',false)');
statshypoxiasign.std = cell2mat(cellfun(@(x) std(x,[],2),hypoxia_signalling,'UniformOutput',false)');
statshypoxiasign.min = cell2mat(cellfun(@(x) min(x,[],2),hypoxia_signalling,'UniformOutput',false)');
statshypoxiasign.max = cell2mat(cellfun(@(x) max(x,[],2),hypoxia_signalling,'UniformOutput',false)');
statshypoxiasign.clones = clones;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsnormoxia), '#Cells-Normoxia')

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statshypoxia), '#Cells-Hypoxia')

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statshypoxiasign), '#Cells-HypoxiaSign')



%% NORMALIZED DATA (FRACTIONS OF TOTAL POPULATION)

N = [normoxia{:}];
H = [hypoxia{:}];
HS = [hypoxia_signalling{:}];


cN = cell(nrepeats,1);
cH = cell(nrepeats,1);
cHS = cell(nrepeats,1);


for i=1:nrepeats
    cN{i} = N(:,i:100:end);
    cH{i} = H(:,i:100:end);
    cHS{i} = HS(:,i:100:end);
end

cNnorm = percnorm(cN); 
cHnorm = percnorm(cH); 
cHSnorm = percnorm(cHS); 


statsNnorm.avg = cmean(cNnorm);
statsNnorm.std = cstd(cNnorm); 
statsNnorm.min = cmin(cNnorm);
statsNnorm.max = cmax(cNnorm); 
statsNnorm.clones = clones;

statsHnorm.avg = cmean(cHnorm);
statsHnorm.std = cstd(cHnorm); 
statsHnorm.min = cmin(cHnorm);
statsHnorm.max = cmax(cHnorm); 
statsHnorm.clones = clones;

statsHSnorm.avg = cmean(cHnorm);
statsHSnorm.std = cstd(cHnorm); 
statsHSnorm.min = cmin(cHnorm);
statsHSnorm.max = cmax(cHnorm); 
statsHSnorm.clones = clones;


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsNnorm), 'Normalised-Normoxia')


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsHnorm), 'Normalised-Hypoxia')


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.xlsx, makesheet(statsHSnorm), 'Normalised-HypoxiaSign')


%% **************************** FIGURES ***********************************

clear('data');

markers = 'oxv+';
colors = [164 164 164;...
    243 136 68;...
    176 139 108;...
    240 240 90]/255;



%% NORMOXIA
[data, txt] = xlsread(file.processed.xlsx,'#Cells-Normoxia');
avg = data(1:250:nsteps,1:4:end);

figure;
hold on;

for i = 1:size(avg,2)
    plot(avg(:,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',markers(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 1500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:9,'xTickLabel',0:500:2000,...
    'yTick',0:500:2000,'yTickLabel',0:500:2000);


hold off;


savefig([file.output.tms '-N'],8.75,5);



%% HYPOXIA
data = xlsread(file.processed.xlsx,'#Cells-Hypoxia');
avg = data(1:250:nsteps,1:4:end);

figure;
hold on;

for i = 1:size(avg,2)
    plot(avg(:,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',markers(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 1500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:9,'xTickLabel',0:500:2000,...
    'yTick',0:500:2000,'yTickLabel',0:500:2000);


hold off;

savefig([file.output.tms '-H'],8.75,5);



%% HYPOXIA SIGNALLING
data = xlsread(file.processed.xlsx,'#Cells-HypoxiaSign');
avg = data(1:250:nsteps,1:4:end);

figure;
hold on;

for i = 1:size(avg,2)
    plot(avg(:,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',markers(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 1500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:9,'xTickLabel',0:500:2000,...
    'yTick',0:500:2000,'yTickLabel',0:500:2000);

hold off;

savefig([file.output.tms '-HS'],8.75,5);


%% BAR PLOT

close all; clear('data');

[data.hypoxia, ~] = xlsread(file.processed.xlsx,'#Cells-Hypoxia');
[data.hypoxiasignalling, ~] = xlsread(file.processed.xlsx,'#Cells-HypoxiaSign');

hcount_avg = data.hypoxia(end,1:4:end);
hscount_avg = data.hypoxiasignalling(end,1:4:end);

hcount_std = data.hypoxia(end,2:4:end);
hscount_std = data.hypoxiasignalling(end,2:4:end);

nrepeats = 100;


 colors = [1.0000    1.0000    1.0000; 
           0.7020    0.2510    0.2510];
       

h = barwitherr([hcount_std' hscount_std']./sqrt(nrepeats),[hcount_avg' hscount_avg']);

set(gca,'XtickLabel','',...
    'YTick',0:500:1500);

ylabel('# of cells (alive)')
axis([0.5 4.5 0 1500])
set(gca,'FontSize',8)
box off;

for k=1:size(colors,1)
    h(k).FaceColor = colors(k,:);
end

savefig(file.output.bars, 8.2, 2.0);



%% CHECK FOR SIGNIFICANCE

final.hypoxia = cell2mat(cellfun(@(x) x(end,:), cH, 'UniformOutput', false));
final.hypoxiasign = cell2mat(cellfun(@(x) x(end,:), cHS, 'UniformOutput', false));

[p, stars] = check_significance(final.hypoxia, final.hypoxiasign);
disp(['Significance Levels: ' num2str(diag(stars)')])






















