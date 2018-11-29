function y = cmean(x)

n = length(x);

sx = x{1};

for i = 2:n
   sx = sx + x{i};
end


y = sx/n;