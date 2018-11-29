function read_shape(mat_file, read_dir, folders)

warning('off'); %#ok<WNOFF>

current_dir = pwd;
cd(read_dir)


for i=1:length(folders)
    disp(['Processing folder: ' folders{i}])
    
    file = dir(folders{i});
    file(1:2) = []; % pattern directories
    
    for j=1:length(file)
        name = [folders{i} '\' file(j).name];
        disp(['Processing file: ' name])
        
        temp = load_shape(name);
        data{i,j} = cellfun(@(x) reshape(x,[3 length(x)/3])', temp, 'UniformOutput',false);
        files{i,j} = name;
    end
end

cd(current_dir);
save(mat_file, 'data','files');