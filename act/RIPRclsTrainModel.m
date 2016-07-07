function [RIPRclsModel] = RIPRclsTrainModel(X,Y,d,lambda)
    %[L, Projections] = LocalEntropyEstimator(X,Y,d,1);
    [L, Projections] = LocalSscLossEstimator(X,Y,d,1);
    [T, T_idx] = min(L,[],2);
    [b] = RegressionIteratePointMatrix(L,T,lambda/10,lambda,2);
    b0 = full(b);
    b1 = double(b0==repmat(max(b0,[],2),1,size(L,2)));
    B1 = sum(b1)';
    thresh = 0.01*size(X,1);
    RIPRclsModel = struct;
    RIPRclsModel.Projections = Projections;
    RIPRclsModel.ProjIdx = (B1>thresh);
    RIPRclsModel.Xu = X(Y==-1,:);
    RIPRclsModel.X = X(Y~=-1,:);
    RIPRclsModel.Y = Y(Y~=-1);
    RIPRclsModel.Classes = unique(RIPRclsModel.Y);
    RIPRclsModel.d = d;
end