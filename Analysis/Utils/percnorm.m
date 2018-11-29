function y = percnorm(x)

% Turn data into percentages of data

if iscell(x)
    
    y = cell(size(x));
    
    for i=1:length(x)
        y{i} = 100 * x{i}./repmat(sum(x{i},2),[1,size(x{i},2)]);
    end
    
else
    y = 100 * x./repmat(sum(x,2),[1,size(x,2)]);
end