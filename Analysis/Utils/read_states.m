function read_states(mat_file, read_dir, files)

warning('off'); %#ok<WNOFF>

current_dir = pwd;
cd(read_dir)


data = cell(length(files),1);
genes = MAPK_gene_order()';

for i=1:length(files)
    disp(['Processing file: ' files{i}])
    data{i} = load_states([files{i} '.txt']);
end


cd(current_dir);
save(mat_file, 'data','genes','files');