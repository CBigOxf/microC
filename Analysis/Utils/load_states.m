function states = load_states(file_name)


fileID = fopen(file_name);
t = textscan(fileID, '%s','Delimiter','\n');
fclose(fileID);
    
states = cell(size(t{1}));

for i=1:size(t{1},1)
   states{i} = list2logical(t{1}{i});
end
 