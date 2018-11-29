function y = cmin(x)

A = zeros(size(x{1},1),size(x{1},2),length(x));

for i=1:length(x)
    A(:,:,i) = x{i};
end

y = min(A,[],3);
    