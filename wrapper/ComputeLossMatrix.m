function [L, Proj] = ComputeLossMatrix(ComputeLoss, X, Y, d_range, LossParams)
    n = size(X,2);
    m = 1;
    for j=d_range
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            L(:,m) = ComputeLoss(X(:,pi),Y,LossParams);
            Proj{m,1} = pi;
            m = m+1;
        end
    end
end