function [b] = RegressionIteratePointMatrix(X,Y,lambda1,lambda2,iter)
    m = size(X,1);
    n = size(X,2);
    diffpen = ones(n,1);
    if(nargin<5)
        iter = 2;
    end
    for i=1:iter
        b = RegressionRegularizedPointMatrix(X,Y,lambda1,lambda2,diffpen);
        if(sum(sum(b~=0))<1)
            % if b is too sparse, assign 1 to the column which has the
            % minimum element
            b = zeros(size(X,1),size(X,2));
            for j=1:size(X,2)
                b(:,j) = X(:,j)==Y;
            end
        end
        diffpen = norms(b,1,1)';
        diffpen = (max(diffpen)*1.1 - diffpen)/max(diffpen);
    end
end