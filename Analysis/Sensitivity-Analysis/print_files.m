%% PRINT PARAMETER FILES FOR EXPERIMENTS

%% OXYGEN

% diffusion-parameters

Cinit = {'0.04','0.08','0.28'};
R = {'1.0e-3','5.0e-3','1.0e-2'};
D = {'1.0e-10','1.0e-9','1.0e-8'};

root = 'D:\Work\Google Drive - February 2018\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';

for i=1:length(Cinit)
    for j=1:length(R)
        for k=1:length(D)
            name = [root 'Sensitivity Analysis\parameters-O2\diffusion-parameters-O2-Cinit', Cinit{i}, '-R', R{j}, '-D', D{k}, '.txt'];
            fid = fopen(name,'w');
            
            fprintf(fid, 'Name\tInit.\tBC\tDif.Coef.\tConsumption\tProduction\n');
            fprintf(fid, 'Oxygen\t%4.2f\t%4.2f\t%3.1e\t%3.1e\t0.0',...
                str2double(Cinit{i}),str2double(Cinit{i}),str2double(D{k}),str2double(R{j}));
            
            fclose(fid);
        end
    end
end

% input parameters


for i=1:length(Cinit)
    name = [root 'Sensitivity Analysis\parameters-O2\input-parameters-O2-Cinit', Cinit{i}, '.txt'];
    fid = fopen(name,'w');
    
    fprintf(fid, 'Input\tInitial\tThreshold\n');
    fprintf(fid, 'DNA_damage\t0.0\t0.5\n');
    fprintf(fid, 'EGFR_stimulus\t0.0\t0.5\n');
    fprintf(fid, 'TGFBR_stimulus\t0.0\t0.5\n');
    fprintf(fid, 'FGFR3_stimulus\t0.0\t0.5\n');
    fprintf(fid, 'Oxygen_supply\t%4.2f\t0.02',str2double(Cinit{i}));
    
    fclose(fid);
    
end

%% EGF

% diffusion-parameters

R = {'1.0e-5','1.0e-4','2.5e-4','5.0e-4','1.0e-3','2.5e-3','5.0e-3',};
% R = {'1.0e-5','7.5e-4','5.0e-4','2.5e-4','1.0e-4','5.0e-3'};

root = 'D:\Work\Google Drive - February 2018\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';

for i=1:length(R)
    name = [root 'Sensitivity Analysis\parameters-EGF\diffusion-parameters-EGF-R', R{i}, '.txt'];
    fid = fopen(name,'w');
    
    fprintf(fid, 'Name\tInit.\tBC\tDif.Coef.\tConsumption\tProduction\n');
    fprintf(fid, 'Oxygen\t0.04\t0.04\t1.0e-9\t5.0e-3\t0.00\n');
    fprintf(fid, 'EGF\t0.0\t0.0\t2.7e-14\t%3.1e\t0.01',str2double(R{i}));
    
    fclose(fid);
    
end

% input parameters

ACT = {'1.0e-5','1.0e-4','2.5e-4','5.0e-4','1.0e-3','2.5e-3','5.0e-3',};

for i=1:length(ACT)
    name = [root 'Sensitivity Analysis\parameters-EGF\input-parameters-EGF-ACT', ACT{i}, '.txt'];
    fid = fopen(name,'w');
    
    fprintf(fid, 'Input\tInitial\tThreshold\n');
    fprintf(fid, 'DNA_damage\t0.0\t0.5\n');
    fprintf(fid, 'EGFR_stimulus\t0.0\t%3.1e\n',str2double(ACT{i}));
    fprintf(fid, 'TGFBR_stimulus\t0.0\t0.5\n');
    fprintf(fid, 'FGFR3_stimulus\t0.0\t0.5\n');
    fprintf(fid, 'Oxygen_supply\t0.04\t0.02'); % Hypoxia
    
    fclose(fid);
    
end


%% PRINT EXPERIMENTS

% Oxygen

Cinit = {'0.04','0.08','0.28'};
R = {'1.0e-3','5.0e-3','1.0e-2'};
D = {'1.0e-10','1.0e-9','1.0e-8'};

root = 'D:\Work\Google Drive - February 2018\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';
unix_path = 'parameters/sensitivity-analysis/';

fid = fopen([root 'Sensitivity Analysis\experiments\experiments-O2.txt'],'w');

experiment.initial_cell_count = 100;                    
experiment.simulation_length = 2000;
experiment.reporters = {'count objects with [kind = "Cell"]',...
                        'count objects with [my-fate = "Necrosis"]',...    
                        '[table:get substances-of-patch "Oxygen"] of patch 0 0 0'};

experiment.the_associations_file = [unix_path 'associations-O2.txt'];
experiment.the_file_of_mutations = [unix_path 'mutations-EGFRp53.txt'];

for i=1:length(Cinit)    
    for j=1:length(R)
        for k=1:length(D)
            experiment.name = ['O2-Cinit', Cinit{i}, '-R', R{j}, '-D', D{k}];
            disp(['java -Dorg.nlogo.is3d=true  -Xmx16384m -Dfile.encoding=UTF-8 -cp /home/dvoukantsis/netlogo-5.3.1-64/app/NetLogo.jar org.nlogo.headless.Main --model /home/dvoukantsis/netlogo-5.3.1-64/Experiments/microC-sensitivity.nlogo3d --experiment ', experiment.name, '   --spreadsheet /home/dvoukantsis/netlogo-5.3.1-64/Experiments/output/sensitivity-analysis/', experiment.name '.csv --threads 10'])            
            experiment.the_input_parameters_file = [unix_path 'input-parameters-O2-Cinit', Cinit{i}, '.txt'];
            experiment.the_diffusion_parameters_file = [unix_path 'diffusion-parameters-O2-Cinit', Cinit{i}, '-R', R{j}, '-D', D{k}, '.txt'];
            print_experiment(fid, experiment);
        end
    end
end

fclose(fid);



%% EGF
% 
R = {'1.0e-5','1.0e-4','2.5e-4','5.0e-4','1.0e-3','2.5e-3','5.0e-3',};
ACT = {'1.0e-5','1.0e-4','2.5e-4','5.0e-4','1.0e-3','2.5e-3','5.0e-3',};

% R = {'1.0e-5','7.5e-4','5.0e-4','2.5e-4','1.0e-4','5.0e-3'};
% ACT = {'1.0e-5','1.0e-4','5.0e-3','1.0e-3','5.0e-2','1.0e-2',};


root = 'D:\Work\Google Drive - February 2018\Work\Projects\Agent-based Cancer Molel\microc paper\Experiments\Results\Analysis\';
unix_path = 'parameters/sensitivity-analysis/';

fid = fopen([root 'Sensitivity Analysis\experiments\experiments-EGF.txt'],'w');

experiment.initial_cell_count = 500;                    
experiment.simulation_length = 3000;
experiment.reporters = {'count objects with [kind = "Cell"]',...
                        'count objects with [my-fate = "Necrosis"]',...    
                        '[table:get substances-of-patch "EGF"] of patch 0 0 0'};

experiment.the_associations_file = [unix_path 'associations-O2+EGF.txt'];
experiment.the_file_of_mutations = [unix_path 'mutations-p53PTEN.txt'];


for i=1:length(R)
    for j=1:length(ACT)
        experiment.name = ['EGF-R', R{i}, '-ACT', ACT{j}];
        disp(['java -Dorg.nlogo.is3d=true  -Xmx16384m -Dfile.encoding=UTF-8 -cp /home/dvoukantsis/netlogo-5.3.1-64/app/NetLogo.jar org.nlogo.headless.Main --model /home/dvoukantsis/netlogo-5.3.1-64/Experiments/microC.nlogo3d --experiment ', experiment.name, '   --spreadsheet /home/dvoukantsis/netlogo-5.3.1-64/Experiments/output/sensitivity-analysis/', experiment.name '.csv --threads 10'])
        experiment.the_diffusion_parameters_file = [unix_path 'diffusion-parameters-EGF-R', R{i}, '.txt'];
        experiment.the_input_parameters_file = [unix_path 'input-parameters-EGF-ACT', ACT{j}, '.txt'];
        print_experiment(fid, experiment);
    end
end


fclose(fid);













