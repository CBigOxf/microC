function lstate = list2logical(state)


gene_order = MAPK_gene_order();


x = state(2:end-1);
x(x == '"') = [];
x(findstr(x,'] [') + 1) = []; % removing the space between ]_[

start = find(x == '[');
finish = find(x == ']');

if(length(start) > length(finish)) % in case the string doesn't finish in ]
    start(end) = [];
end

final_states = cell(length(start),1);

for i=1:length(start)
    final_states{i} = x(start(i):finish(i));
end

final_states = sort(final_states);

% breaking the states into pieces

state_mat = cell(length(final_states), 1);

for i=1:length(final_states)
    
    x = final_states{i}(2:end-1);
    
    counter = 1;
    while(~isempty(x))
        [state_mat{i,counter} x] = strtok(x,' ');
        counter = counter + 1;
    end
    
end

% turning into a logical vector
lstate = zeros(size(state_mat,1), length(gene_order));

for i=1:size(state_mat,1)
    for j=1:size(state_mat,2)
        lstate(i,strcmp(state_mat{i,j},gene_order)) = 1;
    end
end

size(lstate);


