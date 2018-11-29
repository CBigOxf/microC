clearvars -except 'root'
clc; close all;

% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';


file.data.pos = [root '\Processed-Data\Shape-Pos-', experiment_mode, '-c100-r100-t5000.mat'];
file.data.tms = [root '\Processed-Data\Shape-Tms-', experiment_mode, '-c100-r100-t5000.mat'];

file.processed.sphericity = [root '\Shape\Processed-Data\Shape-c100-r100-t5000-Sphericity.xlsx'];
file.processed.tms = [root '\Shape\Processed-Data\Shape-c100-r100-t5000-Tms.xlsx'];
file.processed.rates = [root '\Shape\Processed-Data\Shape-c100-r100-t5000-Prolif.Rates.xlsx'];


file.output.tms = [root '\Shape\Output\Shape-c100-r100-t5000-Tms'];
file.output.boxplot = [root '\Shape\Output\Shape-c100-r100-t5000-Boxplot'];
file.output.significance = [root '\Shape\Output\Shape-c100-r100-t5000-Significance'];
file.output.radius = [root '\Shape\Output\Shape-c100-r100-t5000-Radius'];
file.output.rates = [root '\Shape\Output\Shape-c100-r100-t5000-ProlifRates'];




%% LOAD AND CLEAN DATA

load(file.data.pos);

clones = {'WT','EGFR+','p53-','PTEN-','p53-PTEN-',...
    'EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'};


%% FIT POLYEDRA TO POINTS AND CALCULATE SPHERICITY AND RADIUS
nrepeats = 100;

counts = cell(size(data));
sphericity = cell(size(data));
radius = cell(size(data));

for i=1:size(data,1)
    for j=1:size(data,2)
        if(length(data{i,j}) == nrepeats) % drop unfinished replicates
            disp(['Processing: ' files{i,j}])
            pos = data{i,j};
            
            counts{i,j} = cellfun(@length,pos);
            shape = cellfun(@(x) alphaShape(x(:,1),x(:,2),x(:,3),4),pos,'UniformOutput',false);
            sphericity{i,j} = cellfun(@(shape) (pi^(1/3) * (6*shape.volume)^(2/3))/shape.surfaceArea,shape);
            
            % This is the average distance between surface points and (0,0,0)
            radius{i,j} = cellfun(@(shape) mean(sqrt(sum(shape.Points(unique(shape.boundaryFacets),:).^2,2))), shape);
            
        end
    end
end


%% SAVE GEOMETRIC PROPERTIES

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist

for i=1:length(clones)
    
    A = cell2mat(sphericity(i,:))';
    A = [zeros(size(A,1),1) A];
    A = [zeros(1,size(A,2)); A];
    A(1,2:end) = 1:size(A,2)-1;
    A = num2cell(A);
    A{1,1} = 'Sample #';
    
    for j=2:size(A,1)
        A{j,1} = ['t=' num2str((j-2)*100)];
    end
    
    xlswrite(file.processed.sphericity, A, clones{i});
end


%% PROCESSING TIMESERIES DATA

load(file.data.tms)

rep = 'count objects with [kind = "Cell"]';
total_cells = ~cellfun(@isempty,strfind(reporters,rep));

data = cellfun(@(x) x(2:end,total_cells),data,'UniformOutput',false);
data = cellfun(@(x) x(~any(isnan(x),2),:),data,'UniformOutput',false); % experiments terminate when #Cells = 4000

data_nan = cell(size(data));

for i=1:size(data,1)
    data_nan{i} = nan(5001,100);
    data_nan{i}(1:size(data{i},1),1:size(data{i},2)) = data{i};
end


%% SAVING TMS DATA

stats.avg = cell2mat(cellfun(@(x) mean(x,2),data_nan,'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),data_nan,'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),data_nan,'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),data_nan,'UniformOutput',false)');
stats.clones = clones;

warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.tms, makesheet(stats), '#Cells')


%% ************************** FIGURES *************************************
%%

colors = colorGradient([164 164 164],[222 92 84],length(clones));

hold on;

for i=1:length(clones)
    plot(cellfun(@mean,sphericity(i,:)),'Color',colors(i,:))
end

hold off;


set(gca,'XTick',1:10:51,'XTickLabel',0:1000:5000,...
    'YTick',0.8:0.05:0.95,...
    'FontSize',8)

axis([1 51 0.78 0.95])
xlabel('Time [Steps]')
ylabel('Sphericity')
% legend(clones)

savefig(file.output.tms,16.4,4.5);


%% RELATIVE SIZE PLOTS

r = cellfun(@mean,radius);
r = r(:,1:10:end);

for i=1:size(r,2)
    figure;
    hold on
    box off;
    rt = r(:,i);
    [rt, idx] = sort(rt,'descend');
    
    for j=1:size(r,1)
        h(i) = circle(rt(j),0,rt(j));
        set(h(i),'FaceColor', colors(idx(j),:),...
            'EdgeColor',[1 1 1]);
    end
    
    axis equal; axis off;
    hold off;
    savefig([file.output.radius '-t' num2str(i-1) '000'], max(rt), max(rt));
end

close all;

%% BOXPLOT

N = 500;

Nlimit = cellfun(@(x) max(x)<=N, counts, 'UniformOutput', false);
% Nlimit = cell2mat(cellfun(@(x) sum(x<=N), stats.ncells, 'Uniformoutput',false));

for i=1:size(Nlimit,1)
    smallerN = find(cell2mat(Nlimit(i,:)));
    sphericityN(:,i) = sphericity{i,smallerN(end)};
end

[~,idx]=sort(mean(sphericityN)); % reorder boxes
colors = colors_and_markers();


boxplot(sphericityN(:,idx),'Color','k','Symbol','ok','outliersize',4,'jitter',0.2);
box off;
set(gca,'XTicklabel','',...
        'YTick',0.75:0.05:0.95,...
        'YTickLabel',0.75:0.05:0.95,...
        'FontSize',8);
axis([0.5 8.5 0.75 0.95])
% ylabel('Sphericity')
% title(['Spheroid Size: < ', num2str(N)])

h = findobj(gca,'Tag','Box');

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'y','FaceColor',colors{2},'FaceAlpha',.7);
end

% savefig(file.output.boxplot,10.5,5); % Supplementary
savefig(file.output.boxplot,9.5,4.5);

%% SIGNIFICANCE LEVELS

[p, stars] = check_significance(sphericityN(:,idx),sphericityN(:,idx));

colors = colorGradient([1 1 1],[0.87 0.36 0.33],5);
colormap(colors)
imagesc(4-stars)


ax = axis;

hold on;
% vertical lines
for i=ax(1):ax(2);plot([i,i],[ax(3),ax(4)],'Color',0.15*ones(1,4)); end;
% horizontal lines
for i=ax(3):ax(4);plot([ax(1),ax(2)],[i,i],'Color',0.15*ones(1,4)); end;

c = colorbar;
c.Label.String = 'Significance Level';
c.Ticks = 0.4:0.8:4;
c.TickLabels = {'****','***','**','*','ns'};
c.FontSize = 8;

mutation = {'WT','EGFR+','p53-','PTEN-','p53-PTEN-',...
    'EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'};

set(gca,'XTickLabel',{''});
set(gca,'YTickLabel',{''});

% set(gca,'XTickLabel',mutation,'XTickLabelRotation',90,'FontSize',8);
% set(gca,'YTickLabel',mutation,'FontSize',8);
axis square

savefig(file.output.significance,6.5,5.5);


%% PROLIFERATION RATES

clc; close all;
load(file.data.tms)

rep = 'the-proliferation-count';
proliferation_count = ~cellfun(@isempty,strfind(reporters,rep));

data = cellfun(@(x) x(2:end,proliferation_count),data,'UniformOutput',false);
data = cellfun(@(x) x(~any(isnan(x),2),:),data,'UniformOutput',false); % experiments terminate when #Cells = 4000

data_nan = cell(size(data));

for i=1:size(data,1)
    data_nan{i} = nan(5001,100);
    data_nan{i}(1:size(data{i},1),1:size(data{i},2)) = data{i};
end

prolif_rate = diff(cell2mat(cellfun(@(x) mean(x(1:100:end,:),2),data_nan,'UniformOutput',false)'))';
sphericity_avg = cellfun(@mean,sphericity);

colors = colors_and_markers([6 2 5 1]);

start = 5; % skip the initial spherical configuration


for i=[1 3 4 5 2 6 7 8]
    
    pr = prolif_rate(i,start:end);
    sa = sphericity_avg(i,start+1:end);
    
    figure;

    hold on; box on;
    plot(pr, sa, 'ok',...
        'MarkerSize', 4,...
        'MarkerFaceColor', colors{4});
    
    [r,p] = corrcoef(pr(~isnan(pr)),sa(~isnan(sa)));
    
    %     xlabel('Proliferation rate [cells/100 steps]')
    %     ylabel('Sphericity')
    title({clones{i}; ['r=',num2str(r(1,2),2), ', p=',num2str(p(1,2),2),]})
    axis equal; axis square;
    ax = axis;
    h = lsline; h(1).Color = colors{2};
%     text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.8*(ax(4)-ax(3)),{['r=',num2str(r(1,2),2)],[' (p=',num2str(p(1,2),2),')']},'FontSize',8)
    set(gca,'FontSize',8);
    YTick = get(gca,'YTick');
    XTick = get(gca,'XTick');
    
    if(length(YTick)>6); set(gca,'YTick',YTick(1:2:end)); end;
    if(length(XTick)>6); set(gca,'XTick',XTick(1:2:end)); end;
    
    savefig([file.output.rates '-',clones{i}],4,4);
    
end




