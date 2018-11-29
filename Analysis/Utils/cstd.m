function y = cstd(x)

n = length(x);

sx = x{1};
sx2 = x{1}.^2;

for i = 2:n
   sx = sx + x{i};
   sx2 = sx2 + x{i}.^2;   
end


y = sqrt((sx2 - (sx).^2/n)/(n-1));