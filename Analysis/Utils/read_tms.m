function read_tms(mat_file, read_dir, files)

warning('off'); %#ok<WNOFF>

current_dir = pwd;
cd(read_dir)

data = cell(length(files),1);
raw = cell(length(files),1);

for i=1:length(files)
    disp(files{i});
    [num,~,raw{i}] = xlsread([files{i} '.csv']);
    
    num(:,1) = [];
    num([1 3:23],:) = [];
    data{i} = num;
end

reporters = raw{1}(21,2:end)'; % same across all files
cd(current_dir)

save(mat_file, 'data','reporters','raw','files');