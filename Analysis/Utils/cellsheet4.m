function A = cellsheet4(mdata,sdata,mindata,maxdata)


n = size(mdata,1);
m = 4 * size(mdata,2);


A = zeros(n,m);

A(:,1:4:m) = mdata; 
A(:,2:4:m) = sdata; 
A(:,3:4:m) = mindata; 
A(:,4:4:m) = maxdata;

A = [zeros(2,m); A];
A = num2cell(A);

A(1,:) = {'WT',' ',' ',' ',...
    'p53-',' ',' ',' ',...
    'PTEN-',' ',' ',' ',...
    'p53-PTEN-',' ',' ',' '};

A(2,:) = {'Mean','Std','Min','Max',...
    'Mean','Std','Min','Max',...
    'Mean','Std','Min','Max',...
    'Mean','Std','Min','Max'};
