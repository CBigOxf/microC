function shape = load_shape(file_name)


fileID = fopen(file_name);
t = textscan(fileID, '%s','Delimiter','\n');
fclose(fileID);
    
shape = cell(size(t{1}));

for i=1:size(t{1},1)
   shape{i} = str2num(t{1}{i});
end

