function [B] = OptimizeSelectionRIPR(L, lambda)
%SELECTIONMATRIXRIPR Compute selection function from loss using RIPR
    [T] = min(L,[],2);
    [b] = RegressionIteratePointMatrix(L,T,lambda/10,lambda,2);
    b0 = full(b);
    B = double(b0==repmat(max(b0,[],2),1,size(L,2)));
end