function merge2xls(output_file, read_dir, sheet)

warning('off'); %#ok<WNOFF>

current_dir = pwd;
cd(read_dir)

for i=1:length(sheet)
    disp(sheet{i});
    [~,~,cdata] = xlsread([sheet{i} '.csv']);
    xlswrite(output_file, cdata, sheet{i})
end

cd(current_dir)