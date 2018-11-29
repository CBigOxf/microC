%% VISUALISE STABLE STATES FROM EXISTING STABLE STATE ANALYSIS

% Loads the xlsx file with the stable states and creates heatmaps. There
% are two heatmaps (TNBC and Grieco).

clearvars -except 'root'
clc; close all;

file.data.states = [root '\Processed-Data\MAPK-Stables-States.xlsx'];
file.output.states.TNBC = [root '\Dynamics\Output\Dynamics-Stable-States-TNBC'];
file.output.states.Grieco = [root '\Dynamics\Output\Dynamics-Stable-States-Grieco'];


%% TNBC CLONES

figure;
wggyr = [255 255 255; 89 89 89; 122 192 99; 240 240 90; 223 91 84]/255;

[num, text] = xlsread(file.data.states,'TNBC');

num(num(:,end-2) == 1, end-2) = 2;   % proliferation
num(num(:,end-1) == 1, end-1) = 4;   % growth arrest
num(num(:,end) == 1, end) = 3;       % apoptosis


text(2:end,1) = {'WT (S1)';'WT (S2)';'EGFR+ (S1)';'EGFR+ (S2)';'p53- (S1)';'p53- (S2)';...
                 'PTEN- (S1)';'PTEN- (S2)';'p53-PTEN- (S1)';'p53-PTEN- (S2)';...
                 'EGFR+PTEN- (S1)';'EGFR+PTEN- (S2)';'EGFR+p53-';'EGFR+p53-PTEN-'};

text{1,end-2} = 'Prolif.';
text{1,end-1} = 'Gr. Arrest';

s.data = num;
s.xlabel = text(1,2:end);
s.ylabel = text(2:end,1);
myheatmap(s);

colormap(wggyr)
set(gca,'FontSize',6.5)
% axis off;

savefig(file.output.states.TNBC,19,5);


%% GRIECO CLONES

figure;
wggyr = [255 255 255; 89 89 89; 122 192 99; 240 240 90; 223 91 84]/255;

[num, text] = xlsread(file.data.states,'Grieco');

num(num(:,end-2) == 1, end-2) = 2;   % proliferation
num(num(:,end-1) == 1, end-1) = 4;   % growth arrest
num(num(:,end) == 1, end) = 3;       % apoptosis

text(2:end,1) = {'EGFR+ (S1)';'EGFR+ (S2)';...
                 'FGFR3+ (S1)';'FGFR3+ (S2)';...
                 'EGFR+p53-';...
                 'FGFR3+p53- (S1)';'FGFR3+p53- (S2)';...
                 'EGFR+DNA-damage';...
                 'EGFR+TGFBR-stimulus';...
                 'FGFR3+TGFBR-stimulus';...
                 'EGFR+PI3K+AKT+ (S1)';'EGFR+PI3K+AKT+ (S2)';...
                 'FGFR3+PI3K+AKT+';...
                 'EGFR+p14-';...
                 'FGFR3+p14- (S1)';'FGFR3+p14- (S2)';...
                 'EGFR+PTEN- (S1)';'EGFR+PTEN- (S2)';...
                 'FGFR3+PTEN- (S1)';'FGFR3+PTEN- (S2)'};
             
text{1,end-2} = 'Prolif.';
text{1,end-1} = 'Gr. Arrest';

s.data = num;
s.xlabel = text(1,2:end);
s.ylabel = text(2:end,1);
myheatmap(s);

colormap(wggyr)
set(gca,'FontSize',6.5)
% axis off;

savefig(file.output.states.Grieco,19,6.0);




















