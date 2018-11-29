%% PRE-PROCESSING CSV FILES INTO XLSX FILES

clearvars -except 'root'
clc; close all;


%% DYNAMICS EXPERIMENTS
%% States of cells in Dynamics Experiment

disp('DYNAMICS EXPERIMENTS')
disp('States of cells in Dynamics Experiment')

read_states([root '\Processed-Data\Dynamics-States-R-c100-r100-t5000.mat'],...
    [root '\Raw-Data\states\dynamics-R-c100-r100-t5000'],...
    {'EGFR+','EGFR+DNA-damage','EGFR+PI3K+AKT+','EGFR+PTEN-','EGFR+TGFBR-stimulus',...
     'EGFR+p14-','EGFR+p53-','EGFR+p53-PTEN-','FGFR3+','FGFR3+DNA-damage','FGFR3+PI3K+AKT+',...
     'FGFR3+PTEN-','FGFR3+TGFBR-stimulus','FGFR3+p14-','FGFR3+p53-','PTEN-','WT','p53-','p53-PTEN-'}')


%% Timeseries data in Dynamics Experiment

disp('DYNAMICS EXPERIMENTS')
disp('Timeseries data in Dynamics Experiment')

read_tms([root '\Processed-Data\Dynamics-Tms-R-c100-r100-t5000.mat'],...
    [root '\Raw-Data\dynamics\R-r100-c100-t5000'],...
    {'EGFR+','EGFR+DNA-damage','EGFR+PI3K+AKT+','EGFR+PTEN-','EGFR+TGFBR-stimulus',...
     'EGFR+p14-','EGFR+p53-','EGFR+p53-PTEN-','FGFR3+','FGFR3+DNA-damage','FGFR3+PI3K+AKT+',...
     'FGFR3+PTEN-','FGFR3+TGFBR-stimulus','FGFR3+p14-','FGFR3+p53-','PTEN-','WT','p53-','p53-PTEN-'}');

 
%% Dynamics: Short (t100)
%% States of cells for short Dynamics Experiment

disp('DYNAMICS EXPERIMENTS')
disp('States of cells for short Dynamics Experiment')

read_states([root '\Processed-Data\Dynamics-States-R-c100-r100-t100.mat'],...
    [root '\Raw-Data\states\dynamics-R-c100-r100-t100'],...
    {'WT','EGFR+','p53-','PTEN-','p53-PTEN-','EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'}')


%% Timeseries data in short Dynamics Experiment

disp('DYNAMICS EXPERIMENTS')
disp('Timeseries data in short Dynamics Experiment')

read_tms([root '\Processed-Data\Dynamics-Tms-R-c100-r100-t100.mat'],...
    [root '\Raw-Data\dynamics\R-r100-c100-t100'],...
    {'WT','EGFR+','p53-','PTEN-','p53-PTEN-','EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'}');
 


%% GROWTH EXPERIMENTS
%% Isolation (no-diffusables)

disp('GROWTH EXPERIMENTS')
disp('Isolation (no-diffusables)')


read_tms([root '\Processed-Data\Growth-Iso-R-c100-r100-t2000.mat'],...
    [root '\Raw-Data\growth\growth-isolation'],...
    {'WT','EGFR+','p53-','PTEN-','p53-PTEN-','EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'}');


%% Isolation (no-diffusables, PI3KAKT)

disp('GROWTH EXPERIMENTS')
disp('Isolation (no-diffusables)')

read_tms([root '\Processed-Data\Growth-Iso-R-PI3KAKT-c100-r100-t2000.mat'],...
    [root '\Raw-Data\growth\PI3KAKT'],...
    {'PI3K+AKT+','EGFR+PI3K+AKT+','p53-PI3K+AKT+','PTEN-PI3K+AKT+','p53-PTEN-PI3K+AKT+',...
     'EGFR+PTEN-PI3K+AKT+','EGFR+p53-PI3K+AKT+','EGFR+p53-PTEN-PI3K+AKT+'}');


%% Hypoxia (O2 diffusion)

disp('GROWTH EXPERIMENTS')
disp('Hypoxia (O2 diffusion)')

read_tms([root '\Processed-Data\Growth-Hypoxia-Iso-R-c100-r100-t2000.mat'],...
    [root '\Raw-Data\growth\hypoxia'],...
    {'Normoxia-WT','Normoxia-EGFR+','Normoxia-p53-','Normoxia-PTEN-','Normoxia-p53-PTEN-',...
    'Normoxia-EGFR+PTEN-','Normoxia-EGFR+p53-','Normoxia-EGFR+p53-PTEN-',...
    'Hypoxia-WT','Hypoxia-EGFR+','Hypoxia-p53-','Hypoxia-PTEN-','Hypoxia-p53-PTEN-',...
    'Hypoxia-EGFR+PTEN-','Hypoxia-EGFR+p53-','Hypoxia-EGFR+p53-PTEN-'});


%% Hypoxia Signalling (O2 + EGF diffusion)

disp('GROWTH EXPERIMENTS')
disp('Hypoxia Signalling (O2 + EGF diffusion)')

read_tms([root '\Processed-Data\Growth-HypoxiaSign-Iso-R-c500-r100-t2000.mat'],...
    [root '\Raw-Data\growth\hypoxia-signalling'],...
    {'Normoxia-WT','Normoxia-p53-','Normoxia-PTEN-','Normoxia-p53-PTEN-',...
    'Hypoxia-WT','Hypoxia-p53-','Hypoxia-PTEN-','Hypoxia-p53-PTEN-',...
    'Hypoxia-Signalling-WT','Hypoxia-Signalling-p53-','Hypoxia-Signalling-PTEN-','Hypoxia-Signalling-p53-PTEN-'});


%% Competition (no diffusables)

disp('GROWTH EXPERIMENTS')
disp('Competition (no diffusables)')

read_tms([root '\Processed-Data\Growth-Comp-R-c100-r100-t2000.mat'],...
    [root '\Raw-Data\growth\competition'],...
    {'competition'});


%% Competition (O2 diffusion)

disp('GROWTH EXPERIMENTS')
disp('Competition (O2 diffusion)')

read_tms([root '\Processed-Data\Growth-Hypoxia-Comp-R-c100-r100-t2000.mat'],...
    [root '\Raw-Data\growth\competition'],...
    {'h-normoxia','h-hypoxia'});


%% Competition (O2 + EGF diffusion)

disp('GROWTH EXPERIMENTS')
disp('Competition (O2 + EGF diffusion)')

read_tms([root '\Processed-Data\Growth-HypoxiaSign-Comp-R-c500-r100-t3000.mat'],...
    [root '\Raw-Data\growth\competition'],...
    {'hs-normoxia','hs-hypoxia','hs-hypoxia-signalling'});


%% SHAPE EXPERIMENT
%% Timeseries for Shape Experiment

disp('SHAPE EXPERIMENTS')
disp('Timeseries for Shape Experiment')

read_tms([root '\Processed-Data\Shape-Tms-R-c100-r100-t5000.mat'],...
    [root '\Raw-Data\shape'],...
    {'WT','EGFR+','p53-','PTEN-','p53-PTEN-','EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'}');

%% Shape files with cells' positions

disp('SHAPE EXPERIMENTS')
disp('Shape files with cells positions')

read_shape([root '\Processed-Data\Shape-Pos-R-c100-r100-t5000.mat'],...
    [root '\Raw-Data\shape'],...
    {'WT','EGFR+','p53-','PTEN-','p53-PTEN-','EGFR+PTEN-','EGFR+p53-','EGFR+p53-PTEN-'}');

%% CLONAL EVOLUTION

disp('CLONAL EXPERIMENTS')

read_tms([root '\Processed-Data\Clonal-Evolution-Tms-R-init50-c1-r100-t4000.mat'],...
    [root '\Raw-Data\clonal-evolution'],...
    {'p53-PTEN-EGFR+','p53-EGFR+PTEN-','PTEN-p53-EGFR+','PTEN-EGFR+p53-','EGFR+p53-PTEN-','EGFR+PTEN-p53-'}');


%% CELL CYCLE EXPERIMENT
%% States for Cell Cycle Experiment

disp('CELL CYCLE EXPERIMENTS')
disp('States for Cell Cycle Experiment')

pc = {'pc0020','pc0050','pc0100','pc0200','pc0500','pc1000'};
clones = {'WT', 'EGFR+', 'p53-', 'PTEN-', 'p53-PTEN-',...
    'EGFR+PTEN-', 'EGFR+p53-', 'EGFR+p53-PTEN-'};

counter = 1;

for i=1:length(pc)
    for j=1:length(clones)
        file_names{counter,1} = [pc{i},'-',clones{j}];
        counter = counter + 1;
    end
end

read_states([root '\Processed-Data\Cell-Cycle-States-R-c100-r10-t10000.mat'],...
    [root '\Raw-Data\states\cell-cycle'],file_names)



%% Timeseries for Cell Cycle Experiment

disp('CELL CYCLE EXPERIMENTS')
disp('Timeseries for Cell Cycle Experiment')


pc = {'pc0020','pc0050','pc0100','pc0200','pc0500','pc1000'};
clones = {'WT', 'EGFR+', 'p53-', 'PTEN-', 'p53-PTEN-',...
    'EGFR+PTEN-', 'EGFR+p53-', 'EGFR+p53-PTEN-'};

counter = 1;

for i=1:length(pc)
    for j=1:length(clones)
        file_names{counter,1} = [pc{i},'-',clones{j}];
        counter = counter + 1;
    end
end


read_tms([root '\Processed-Data\Cell-Cycle-Tms-R-c100-r10-t10000.mat'],...
    [root '\Raw-Data\cell-cycle'], file_names)


%% SENSITIVITY ANALYSIS - O2

disp('SENSITIVITY ANALYSIS - O2')


read_tms([root '\Processed-Data\Sensitivity-Analysis-O2-R-c100-r10-t2000.mat'],...
    [root '\Raw-Data\sensitivity-analysis'],...
    {'O2-Cinit0.04-R1.0e-2-D1.0e-10',...
'O2-Cinit0.04-R1.0e-2-D1.0e-8',...
'O2-Cinit0.04-R1.0e-2-D1.0e-9',...
'O2-Cinit0.04-R1.0e-3-D1.0e-10',...
'O2-Cinit0.04-R1.0e-3-D1.0e-8',...
'O2-Cinit0.04-R1.0e-3-D1.0e-9',...
'O2-Cinit0.04-R5.0e-3-D1.0e-10',...
'O2-Cinit0.04-R5.0e-3-D1.0e-8',...
'O2-Cinit0.04-R5.0e-3-D1.0e-9',...
'O2-Cinit0.08-R1.0e-2-D1.0e-10',...
'O2-Cinit0.08-R1.0e-2-D1.0e-8',...
'O2-Cinit0.08-R1.0e-2-D1.0e-9',...
'O2-Cinit0.08-R1.0e-3-D1.0e-10',...
'O2-Cinit0.08-R1.0e-3-D1.0e-8',...
'O2-Cinit0.08-R1.0e-3-D1.0e-9',...
'O2-Cinit0.08-R5.0e-3-D1.0e-10',...
'O2-Cinit0.08-R5.0e-3-D1.0e-8',...
'O2-Cinit0.08-R5.0e-3-D1.0e-9',...
'O2-Cinit0.28-R1.0e-2-D1.0e-10',...
'O2-Cinit0.28-R1.0e-2-D1.0e-8',...
'O2-Cinit0.28-R1.0e-2-D1.0e-9',...
'O2-Cinit0.28-R1.0e-3-D1.0e-10',...
'O2-Cinit0.28-R1.0e-3-D1.0e-8',...
'O2-Cinit0.28-R1.0e-3-D1.0e-9',...
'O2-Cinit0.28-R5.0e-3-D1.0e-10',...
'O2-Cinit0.28-R5.0e-3-D1.0e-8',...
'O2-Cinit0.28-R5.0e-3-D1.0e-9'}');


%% Sensitivity Analysis - EGF

disp('SENSITIVITY ANALYSIS - EGF')

read_tms([root '\Processed-Data\Sensitivity-Analysis-EGF-R-c500-r10-t3000.mat'],...
    [root '\Raw-Data\sensitivity-analysis'],...
    {'EGF-R1.0e-3-ACT1.0e-3',...
'EGF-R1.0e-3-ACT1.0e-4',...  
'EGF-R1.0e-3-ACT1.0e-5',...  
'EGF-R1.0e-3-ACT2.5e-3',...  
'EGF-R1.0e-3-ACT2.5e-4',...  
'EGF-R1.0e-3-ACT5.0e-3',...  
'EGF-R1.0e-3-ACT5.0e-4',...  
'EGF-R1.0e-4-ACT1.0e-3',...  
'EGF-R1.0e-4-ACT1.0e-4',...  
'EGF-R1.0e-4-ACT1.0e-5',...  
'EGF-R1.0e-4-ACT2.5e-3',...  
'EGF-R1.0e-4-ACT2.5e-4',...  
'EGF-R1.0e-4-ACT5.0e-3',...  
'EGF-R1.0e-4-ACT5.0e-4',...  
'EGF-R1.0e-5-ACT1.0e-3',...  
'EGF-R1.0e-5-ACT1.0e-4',...  
'EGF-R1.0e-5-ACT1.0e-5',...  
'EGF-R1.0e-5-ACT2.5e-3',...  
'EGF-R1.0e-5-ACT2.5e-4',...  
'EGF-R1.0e-5-ACT5.0e-3',...  
'EGF-R1.0e-5-ACT5.0e-4',...  
'EGF-R2.5e-3-ACT1.0e-3',...  
'EGF-R2.5e-3-ACT1.0e-4',...  
'EGF-R2.5e-3-ACT1.0e-5',...  
'EGF-R2.5e-3-ACT2.5e-3',...  
'EGF-R2.5e-3-ACT2.5e-4',...  
'EGF-R2.5e-3-ACT5.0e-3',...  
'EGF-R2.5e-3-ACT5.0e-4',...  
'EGF-R2.5e-4-ACT1.0e-3',...  
'EGF-R2.5e-4-ACT1.0e-4',...  
'EGF-R2.5e-4-ACT1.0e-5',...  
'EGF-R2.5e-4-ACT2.5e-3',...  
'EGF-R2.5e-4-ACT2.5e-4',...  
'EGF-R2.5e-4-ACT5.0e-3',...  
'EGF-R2.5e-4-ACT5.0e-4',...  
'EGF-R5.0e-3-ACT1.0e-3',...  
'EGF-R5.0e-3-ACT1.0e-4',...  
'EGF-R5.0e-3-ACT1.0e-5',...  
'EGF-R5.0e-3-ACT2.5e-3',...  
'EGF-R5.0e-3-ACT2.5e-4',...  
'EGF-R5.0e-3-ACT5.0e-3',...  
'EGF-R5.0e-3-ACT5.0e-4',...  
'EGF-R5.0e-4-ACT1.0e-3',...  
'EGF-R5.0e-4-ACT1.0e-4',...  
'EGF-R5.0e-4-ACT1.0e-5',...  
'EGF-R5.0e-4-ACT2.5e-3',...  
'EGF-R5.0e-4-ACT2.5e-4',...  
'EGF-R5.0e-4-ACT5.0e-3',...  
'EGF-R5.0e-4-ACT5.0e-4'}');

