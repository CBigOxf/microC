%% SENSITIVITY ANALYSIS FOR DIFFUSABLES (O2, EGF)
% EGF sensitivity analysis with p53-PTEN- clone
% O2 sensitivity analysis with EGFR+p53- clone

clearvars -except 'root'
clc; close all;


% Choose between R (Reversible decisions) and T (Terminal decisions)
experiment_mode = 'R';

file.data = [root '\Processed-Data\Sensitivity-Analysis-O2-', experiment_mode, '-c100-r10-t2000.mat'];
file.processed.O2 = [root '\Sensitivity-Analysis\Processed-Data\Sensitivity-Analysis-O2-', experiment_mode, '-c100-r10-t2000-Statistics.xlsx'];
file.output.O2 = [root '\Sensitivity-Analysis\Output\Sensitivity-Analysis-', experiment_mode, '-c100-r10-t2000-O2-Tms'];


%% **************************** O2 ***************************************
%% LOAD AND CLEAN O2 DATA

load(file.data, 'files','data', 'reporters')

rep = '[table:get substances-of-patch "Oxygen"] of patch 0 0 0';
O2 = ~cellfun(@isempty,strfind(reporters,rep));

data = cellfun(@(x) x(2:end,O2),data,'UniformOutput',false);
nrepeats = 10;

data_avg = cell2mat(cellfun(@(x) mean(x,2),data,'UniformOutput',false)');

%%

range = {[6 9 3], [15 18 12], [24 27 21], [7 9 8], [16 18 17], [25 27 26]};

stats.avg = cell2mat(cellfun(@(x) mean(x,2),data([range{:}]),'UniformOutput',false)');
stats.std = cell2mat(cellfun(@(x) std(x,[],2),data([range{:}]),'UniformOutput',false)');
stats.min = cell2mat(cellfun(@(x) min(x,[],2),data([range{:}]),'UniformOutput',false)');
stats.max = cell2mat(cellfun(@(x) max(x,[],2),data([range{:}]),'UniformOutput',false)');
stats.clones = files([range{:}]);


warning('off','MATLAB:xlswrite:AddSheet'); % warns that worksheet does not exist
xlswrite(file.processed.O2, makesheet(stats), 'O2')



%% O2 CONCENTRATION TIMESERIES FIGURES

titles = {'C_{init} = 0.04mM', 'C_{init} = 0.08mM', 'C_{init} = 0.28mM',...
          'C_{init} = 0.04mM', 'C_{init} = 0.08mM', 'C_{init} = 0.28mM'};

          
color = [0.6431    0.6431    0.6431;
         0.7588    0.5000    0.4863;
         0.8745    0.3569    0.3294];
     
figure;

for i=1:length(titles)
    
    subplot(2,3,i)
    tms = data_avg(:,range{i});

    hold on; box off;
    
    for j=1:3 
        plot(log(1:2001), tms(:,j), 'Color', color(j,:));
    end
    
    hold off;
    
    axis([0 log(2000) 0 max(tms(:))+0.02])
    
%     xlabel('')
%     set(gca,'XTick',0:5:20,'YTick',0:0.1:0.3)
    set(gca,'XTick',log([1 10 100 1000]),'XTickLabel',[1 10 100 1000]);
%     title(title_list{i});
    set(gca,'FontSize',8)

    
%             ylabel('O_2 Concentration [mMol]')
%             xlabel('Simulation Steps')
    
%     if(i == 3)
%         legend({'0.001 mM.s^{-1}', '0.005 mM.s^{-1}', '0.01 mM.s^{-1}'},...
%             'location','Best','EdgeColor','none','FontSize',8);
%     end  
%     
%     if (i == 6)
%         legend({'1.0e-8 m^2.s^{-1}', '1.0e-9 m^2.s^{-1}', '1.0e-10 m^2.s^{-1}'},...
%             'location','Best','EdgeColor','none','FontSize',8);
%     end
end

savefig(file.output.O2,16,7.5);