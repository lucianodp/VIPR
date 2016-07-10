function [L, Proj] = ComputeLossMatrix(ComputeLoss, X, Y, d_range, LossParams, MaxP)
    n = size(X,2);
    m = 1;
    Proj = cell(0,1);
    for j=d_range
        Pi = combnk(1:n,j);
        Proj = [Proj; mat2cell(Pi,ones(size(Pi,1),1),size(Pi,2))];
    end
    %pi = Pi(i,:);
    %L(:,m) = ComputeLoss(X(:,pi),Y,LossParams);
    [Proj] = FilterProjections(Proj, MaxP, X, Y);
    L = ones(size(X,1),size(Proj,1));
    for i=1:size(Proj,1)
       pi = Proj{i,1};
       L(:,i) = ComputeLoss(X(:,pi),Y,LossParams);
    end
end