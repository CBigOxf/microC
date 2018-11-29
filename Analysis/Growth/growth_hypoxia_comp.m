%% COMPETING CLONES GROWN UDER NORMOXIA AND HYPOXIA (OXYGEN DIFFUSION)

clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data.comp = [root '\Processed-Data\Growth-Hypoxia-Comp-', experiment_mode, '-c100-r100-t2000.mat'];
file.data.iso = [root '\Processed-Data\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000.mat'];

file.processed.comp = [root '\Growth\Processed-Data\Growth-Hypoxia-Comp-',experiment_mode, '-c100-r100-t2000-Statistics.xlsx'];
file.processed.iso = [root '\Growth\Processed-Data\Growth-Hypoxia-Iso-', experiment_mode, '-c100-r100-t2000-Statistics.xlsx'];

file.output.bars = [root '\Growth\Output\Growth-Hypoxia-Comp-', experiment_mode, '-Bars'];
file.output.tms = [root '\Growth\Output\Growth-Hypoxia-Comp-', experiment_mode, '-Tms'];


%% LOADING DATA

load(file.data.comp,'data');


nclones = 8;
nrepeats = 100;
nreporters = 2;

clones = {'WT','EGFR+','p53-','PTEN-','p53-PTEN-',...
    'EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'};

% subtract necrotic cells
data = cellfun(@(x) x(2:end,1:2:end) - x(2:end,2:2:end), data, 'UniformOutput',false);



%%

cdata.normoxia = cell(nclones,1);
cdata.hypoxia = cell(nclones,1);

for i=1:nclones
    cdata.normoxia{i} = data{1}(:,i:nclones:end);
    cdata.hypoxia{i} = data{2}(:,i:nclones:end);
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



%% STATISTICS FOR NORMALIZED DATA (FRACTIONS OF TOTAL POPULATION)

cdata.experiment.normoxia = cell(nrepeats,1);
cdata.experiment.hypoxia = cell(nrepeats,1);

idx = reshape(1:size(data{1},2),nclones,nrepeats)';


for i=1:nrepeats
    cdata.experiment.normoxia{i} = data{1}(:,idx(i,:));
    cdata.experiment.hypoxia{i} = data{2}(:,idx(i,:));
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



%% **************************** FIGURES ***********************************

[data, txt] = xlsread(file.processed.comp,'#Cells-Hypoxia');
avg = data(1:250:2001,1:4:end);

marker = 'osxv+dp^';

colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;


mask = [1 3 4 5];

figure;
hold on;

for i = mask
    plot(avg(:,i),...
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


savefig([file.output.tms '-part1'],8.75,5);



mask = [2 6 7 8];

figure;

hold on;

for i = mask
    plot(avg(:,i),...
        'color',colors(i,:), ...
        'LineWidth',1.0,...
        'Marker',marker(i),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(i,:));
end

axis([1 9 0 400])

set(gca,...
    'FontSize',8,...
    'xTick',1:2:10,'xTickLabel',0:500:2000,...
    'yTick',0:100:400,'yTickLabel',0:100:400);

hold off;


savefig([file.output.tms '-part2'],8.75,5);


%% Competing - Isolated clones under Normoxia and Hypoxia (Bars)

final.hypoxia.comp = cell2mat(cellfun(@(x) x(end,:), cdata.norm.hypoxia, 'UniformOutput', false));
final.normoxia.comp = cell2mat(cellfun(@(x) x(end,:), cdata.norm.normoxia, 'UniformOutput', false));


load(file.data.iso, 'files','data', 'reporters')

rep1 = 'count objects with [kind = "Cell"]';
rep2 = 'count objects with [my-fate = "Necrosis"]';

total_cells = ~cellfun(@isempty,strfind(reporters,rep1));
necrotic = ~cellfun(@isempty,strfind(reporters,rep2));
nsteps = 2002; % use this number of steps (up to 2502)

data = cellfun(@(x) x(2:nsteps,total_cells) - x(2:nsteps,necrotic),data,'UniformOutput',false);





final.normoxia.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data(1:8), 'UniformOutput', false)'));
final.hypoxia.iso = percnorm(cell2mat(cellfun(@(x) x(end,:)', data(9:end), 'UniformOutput', false)'));


M = [(mean(final.normoxia.comp) - mean(final.normoxia.iso))' ...
     (mean(final.hypoxia.comp) - mean(final.hypoxia.iso))'];

S = sqrt([(std(final.normoxia.comp).^2 + std(final.normoxia.iso).^2)' ...
     (std(final.hypoxia.comp).^2 + std(final.hypoxia.iso).^2)'])./sqrt(nrepeats);


h = barwitherr(S,M);

h(1).FaceColor = [1 1 1]; h(2).FaceColor = [0.87,0.36,0.33];

set(gca,...
    'XtickLabel',{' '},...
    'YTick',-15:5:15,...
    'FontSize',8);

axis([0.5 8.5 -15 15])
box off;

savefig(file.output.bars,9,3.5);
close all;


[p,stars] = check_significance(final.hypoxia.comp - final.hypoxia.iso, final.normoxia.comp - final.normoxia.iso);
disp(['Significance Levels: ' num2str(diag(stars)')])









