function [L, Proj] = ComputeLossMatrix(ComputeLoss, X, Y, d_range, LossParams, MaxF, MaxP)
    n = size(X,2);
    if (n>MaxF)
        feats = FilterFeatures(X, Y, MaxF);
    else
        feats = 1:n;
    end
    Proj = cell(0,1);
    for j=d_range
        Pi = combnk(feats,j);
        Proj = [Proj; mat2cell(Pi,ones(size(Pi,1),1),size(Pi,2))];
    end
    [Proj] = FilterProjections(X, Y, Proj, MaxP);
    L = ones(size(X,1),size(Proj,1));
    for i=1:size(Proj,1)
       pi = Proj{i,1};
       L(:,i) = ComputeLoss(X(:,pi),Y,LossParams);
    end
end