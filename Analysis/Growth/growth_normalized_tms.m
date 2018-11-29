clear; clc; close all;

root = 'C:\Users\dvoukantsis\Google Drive\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';

file.processed.iso.normoxia = [root 'Growth\Processed Data\Growth-Iso-Tms-Statistics.xlsx'];
file.processed.iso.hypoxia = [root 'Growth\Processed Data\Growth-Hypoxia-Iso-Tms-Statistics.xlsx'];
file.processed.iso.hypoxia_signalling = [root 'Growth\Processed Data\Growth-Hypoxia-Sign-Iso-Tms-Statistics.xlsx'];

file.processed.comp.normoxia = [root 'Growth\Processed Data\Growth-Comp-Tms-Statistics.xlsx'];
file.processed.comp.hypoxia = [root 'Growth\Processed Data\Growth-Hypoxia-Comp-Tms-Statistics.xlsx'];
file.processed.comp.hypoxia_signalling = [root 'Growth\Processed Data\Growth-Hypoxia-Sign-Comp-Tms-Statistics.xlsx'];


%%

% file.output.tms = [root 'Growth\Output\Growth-Iso-Tms'];


data.iso.normoxia = xlsread(file.processed.iso.normoxia,'Population Fractions');
data.comp.normoxia = xlsread(file.processed.comp.normoxia,'Population Fractions');

data.iso.hypoxia = xlsread(file.processed.iso.hypoxia,'Population Fractions - Hypoxia');
data.comp.hypoxia = xlsread(file.processed.comp.hypoxia,'Pop. Fractions-Hypoxia');

% keep avg
data.iso.normoxia = data.iso.normoxia(1:250:end,1:4:end);
data.comp.normoxia = data.comp.normoxia(1:250:end,1:4:end);
data.iso.hypoxia = data.iso.hypoxia(1:250:end,1:4:end);
data.comp.hypoxia = data.comp.hypoxia(1:250:end,1:4:end);

%%
close all; 

colors = [164 164 164;...
    223 91 84;...
    243 136 68;...
    176 139 108;...
    240 240 90;...
    122 192 99;...
    87 164 203;...
    150 115 182]/255;

marker = 'osxv';

clones = {'WT','EGFR+','p53-','PTEN-','p53-PTEN-',...
    'EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'};



for i=1:size(data.iso.normoxia,2)
    
    figure;
    hold on;
    
    plot(data.iso.normoxia(:,i),...
        'color',colors(1,:), ...
        'LineWidth',1.0,...
        'Marker',marker(1),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(1,:));
    
    plot(data.comp.normoxia(:,i),...
        'color',colors(2,:), ...
        'LineWidth',1.0,...
        'Marker',marker(2),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(2,:));
    
    plot(data.iso.hypoxia(:,i),...
        'color',colors(3,:), ...
        'LineWidth',1.0,...
        'Marker',marker(3),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(3,:));
    
    plot(data.comp.hypoxia(:,i),...
        'color',colors(7,:), ...
        'LineWidth',1.0,...
        'Marker',marker(4),...
        'MarkerSize',4,...
        'MarkerFaceColor',[1 1 1],...
        'MarkerEdgeColor',colors(7,:));
    
    axis([1 9 0 40])
    
    set(gca,...
        'FontSize',8,...
        'xTick',1:2:10,'xTickLabel',0:500:2000,...
        'yTick',0:5:40,'yTickLabel',0:5:40);
    
    hold off;
    
    title(clones{i})
    
end

legend('Isolated - Normoxia','Competing - Normoxia',...
    'Isolated - Hypoxia','Competing - Hypoxia');





% savefig(file.output.tms,8.75,5);





















