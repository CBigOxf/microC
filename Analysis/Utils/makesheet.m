function A = makesheet(stats)


n = size(stats.avg,1);
m = 4 * size(stats.avg,2);

A = zeros(n,m);

A(:,1:4:m) = stats.avg; 
A(:,2:4:m) = stats.std; 
A(:,3:4:m) = stats.min; 
A(:,4:4:m) = stats.max;

A = [zeros(2,m); A];

A = num2cell(A);

A(1,:) = repmat({' '},1,size(A,2)); A(1,1:4:end) = stats.clones;
A(2,:) = repmat({'Mean','Std','Min','Max'},1,length(stats.clones));
