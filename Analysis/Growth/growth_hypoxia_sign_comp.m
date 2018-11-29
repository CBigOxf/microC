
clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data.comp = [root '\Processed-Data\Growth-HypoxiaSign-Comp-', experiment_mode, '-c500-r100-t3000.mat'];
file.data.iso = [root '\Processed-Data\Growth-HypoxiaSign-Iso-', experiment_mode, '-c500-r100-t2000.mat'];

file.processed.comp = [root '\Growth\Processed-Data\Growth-Hypoxia-Comp-',experiment_mode, '-c500-r100-t2000-Statistics.xlsx'];
file.processed.iso = [root '\Growth\Processed-Data\Growth-Hypoxia-Iso-', experiment_mode, '-c500-r100-t2000-Statistics.xlsx'];

file.output.bars = [root '\Growth\Output\Growth-HypoxiaSing-Comp-', experiment_mode, '-c500-r100-t2000-Bars'];
file.output.tms = [root '\Growth\Output\Growth-HypoxiaSing-Comp-', experiment_mode, '-c500-r100-t2000-Tms'];


%% LOADING AND SELECTING DATA

load(file.data.comp,'data');

nrepeats = 100;
nreporters = 2;
nsteps = 2002; % make sure it's the same with output/processed file name!!!

clones = {'WT','p53-','PTEN-','p53-PTEN-'};
nclones = length(clones);

% subtract necrotic cells
data = cellfun(@(x) x(2:nsteps,1:2:end) - x(2:nsteps,2:2:end), data, 'UniformOutput',false);




%% **************************** STATISTICS ********************************
%% ABSOLUTE NUMBERS (NUMBER OF CELLS)

cdata.normoxia = cell(nclones,1);
cdata.hypoxia = cell(nclones,1);
cdata.hypoxia_signalling = cell(nclones,1);


for i=1:nclones
    cdata.normoxia{i} = data{1}(:,i:nclones:end);
    cdata.hypoxia{i} = data{2}(:,i:nclones:end);
    cdata.hypoxia_signalling{i} = data{3}(:,i:nclones:end);
end


statsN.avg = cell2mat(cellfun(@(x) mean(x,2),cdata.normoxia,'UniformOutput',false)');
statsN.std = cell2mat(cellfun(@(x) std(x,[],2),cdata.normoxia,'UniformOutput',false)');
statsN.min = cell2mat(cellfun(@(x) min(x,[],2),cdata.normoxia,'UniformOutput',false)');
statsN.max = cell2mat(cellfun(@(x) max(x,[],2),cdata.normoxia,'UniformOutput',false)');
statsN.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsN), '#Cells-Normoxia')


statsH.avg = cell2mat(cellfun(@(x) mean(x,2),cdata.hypoxia,'UniformOutput',false)');
statsH.std = cell2mat(cellfun(@(x) std(x,[],2),cdata.hypoxia,'UniformOutput',false)');
statsH.min = cell2mat(cellfun(@(x) min(x,[],2),cdata.hypoxia,'UniformOutput',false)');
statsH.max = cell2mat(cellfun(@(x) max(x,[],2),cdata.hypoxia,'UniformOutput',false)');
statsH.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsH), '#Cells-Hypoxia')


statsHS.avg = cell2mat(cellfun(@(x) mean(x,2),cdata.hypoxia_signalling,'UniformOutput',false)');
statsHS.std = cell2mat(cellfun(@(x) std(x,[],2),cdata.hypoxia_signalling,'UniformOutput',false)');
statsHS.min = cell2mat(cellfun(@(x) min(x,[],2),cdata.hypoxia_signalling,'UniformOutput',false)');
statsHS.max = cell2mat(cellfun(@(x) max(x,[],2),cdata.hypoxia_signalling,'UniformOutput',false)');
statsHS.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsHS), '#Cells-HypoxiaSign')


%% NORMALIZED DATA (FRACTIONS OF TOTAL POPULATION)

cdata.experiment.normoxia = cell(nrepeats,1);
cdata.experiment.hypoxia = cell(nrepeats,1);
cdata.experiment.hypoxia_signalling = cell(nrepeats,1);

idx = reshape(1:size(data{1},2),nclones,nrepeats)';


for i=1:nrepeats
    cdata.experiment.normoxia{i} = data{1}(:,idx(i,:));
    cdata.experiment.hypoxia{i} = data{2}(:,idx(i,:));
    cdata.experiment.hypoxia_signalling{i} = data{3}(:,idx(i,:));
end


cdata.norm.normoxia = percnorm(cdata.experiment.normoxia);

statsNnorm.avg = cmean(cdata.norm.normoxia);
statsNnorm.std = cstd(cdata.norm.normoxia);
statsNnorm.min = cmin(cdata.norm.normoxia);
statsNnorm.max = cmax(cdata.norm.normoxia);
statsNnorm.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsNnorm), 'Normalised-Normoxia')


cdata.norm.hypoxia = percnorm(cdata.experiment.hypoxia);

statsHnorm.avg = cmean(cdata.norm.hypoxia);
statsHnorm.std = cstd(cdata.norm.hypoxia);
statsHnorm.min = cmin(cdata.norm.hypoxia);
statsHnorm.max = cmax(cdata.norm.hypoxia);
statsHnorm.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsHnorm), 'Normalised-Hypoxia')


cdata.norm.hypoxia_signalling = percnorm(cdata.experiment.hypoxia_signalling);

statsHSnorm.avg = cmean(cdata.norm.hypoxia_signalling);
statsHSnorm.std = cstd(cdata.norm.hypoxia_signalling);
statsHSnorm.min = cmin(cdata.norm.hypoxia_signalling);
statsHSnorm.max = cmax(cdata.norm.hypoxia_signalling);
statsHSnorm.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.comp, makesheet(statsHSnorm), 'Normalised-Hypoxia-Sign')


%% **************************** FIGURES ***********************************
%% Hypoxia Signalling

markers = 'osxv+dp^';

colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;


mask = [1 3 4 5];

colors = colors(mask,:);
markers = markers(mask);


data = xlsread(file.processed.comp,'#Cells-HypoxiaSign');
avg = data(1:250:2001,1:4:end);


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

axis([1 size(avg,1) 0 500])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:11,'xTickLabel',0:500:2000,...
    'yTick',0:100:500,'yTickLabel',0:100:500);

hold off;

savefig([file.output.tms '-HS'],8.75,5);


%% Hypoxia

data = xlsread(file.processed.comp,'#Cells-Hypoxia');
avg = data(1:250:2001,1:4:end);

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

axis([1 size(avg,1) 0 300])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:11,'xTickLabel',0:500:2000,...
    'yTick',0:100:500,'yTickLabel',0:100:500);

hold off;

savefig([file.output.tms '-H'],8.75,5);


%% Normoxia

[data, txt] = xlsread(file.processed.comp,'#Cells-Normoxia');

avg = data(1:250:2001,1:4:end);

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

axis([1 size(avg,1) 0 300])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:11,'xTickLabel',0:500:2000,...
    'yTick',0:100:500,'yTickLabel',0:100:500);

hold off;


savefig([file.output.tms '-N'],8.75,5);


%% Competing - Isolated clones under hypoxia and hypoxia signalling (Bar chart)


final.hypoxiasign.comp = cell2mat(cellfun(@(x) x(end,:), cdata.norm.hypoxia_signalling, 'UniformOutput', false));
final.hypoxia.comp = cell2mat(cellfun(@(x) x(end,:), cdata.norm.hypoxia, 'UniformOutput', false));
final.normoxia.comp = cell2mat(cellfun(@(x) x(end,:), cdata.norm.normoxia, 'UniformOutput', false));


load(file.data.iso)

rep1 = 'count objects with [kind = "Cell"]';
rep2 = 'count objects with [my-fate = "Necrosis"]';

total_cells = ~cellfun(@isempty,strfind(reporters,rep1));
necrotic = ~cellfun(@isempty,strfind(reporters,rep2));
nsteps = 2002; % use this number of steps (up to 2502)

data = cellfun(@(x) x(2:nsteps,total_cells) - x(2:nsteps,necrotic),data,'UniformOutput',false);

final.normoxia.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data(1:4), 'UniformOutput', false)'));
final.hypoxia.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data(5:8), 'UniformOutput', false)'));
final.hypoxiasign.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data(9:12), 'UniformOutput', false)'));


M = [(mean(final.normoxia.comp) - mean(final.normoxia.iso))' ...
     (mean(final.hypoxia.comp) - mean(final.hypoxia.iso))' ...
     (mean(final.hypoxiasign.comp) - mean(final.hypoxiasign.iso))'];

S = sqrt([ (std(final.normoxia.comp).^2 + std(final.normoxia.iso).^2)' ...
    (std(final.hypoxia.comp).^2 + std(final.hypoxia.iso).^2)' ...
     (std(final.hypoxiasign.comp).^2 + std(final.hypoxiasign.iso).^2)'])./sqrt(nrepeats);



for i=1:size(M,1)
    h = barwitherr(S,M);
    box off;
  
    h(1).FaceColor = [1 1 1];
    h(2).FaceColor = [0.87,0.36,0.33];
    h(3).FaceColor = [0.70,0.25,0.25];
    
    set(gca,'XtickLabel',{' '});
    set(gca,'YTick',-15:5:15)
    axis([0.5 4.5 -10 10])
    set(gca,'FontSize',8)    
end

savefig(file.output.bars,8.2,2.5);

%% Significance


% Normoxia vs Hypoxia
[p, stars] = check_significance(final.normoxia.comp - final.normoxia.iso, ...
    final.hypoxia.comp - final.hypoxia.iso);

disp(['Significance Levels (normoxia/hypoxia): ' num2str(diag(stars)')])



% Hypoxia vs Hypoxia + Signalling
[p, stars] = check_significance(final.hypoxia.comp - final.hypoxia.iso, ...
    final.hypoxiasign.comp - final.hypoxiasign.iso);

disp(['Significance Levels (hypoxia/hypoxiasign): ' num2str(diag(stars)')])













































