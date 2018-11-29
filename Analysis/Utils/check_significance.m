function [p, nstars] = check_significance(x,y)

% testing significance of x(:,i) with y(:,i)

p = ones(size(x,2),size(y,2));

for i=1:size(x,2)
    for j=1:size(y,2)
        p(i,j) = kruskalwallis([x(:,i) y(:,j)],[],'off');
    end
end

nstars = zeros(size(x,2),size(y,2));
nstars(p > 0.01 & p <= 0.05) = 1;
nstars(p > 0.001 & p <= 0.01) = 2;
nstars(p > 0.0001 & p <= 0.001) = 3;
nstars(p <= 0.0001) = 4;

close all;