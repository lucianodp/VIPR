function [Yhat, Error, MetaError] = PredictSeparately(Ensemble,X,Y)
%PREDICTSEPARATELY Summary of this function goes here
%   Detailed explanation goes here
    Error = zeros(1,Ensemble.k);
    Yhat = zeros(size(X,1),Ensemble.k);
    MetaError = zeros(1,Ensemble.k);
    for i=1:Ensemble.k
        [Prediction] = ClassifierPredict(Ensemble.Submodel{i}.ClsModel,X(:,Ensemble.Submodel{i}.ProjDim));
        Yhat(:,i) = Prediction.Yhat;
        Error(i) = mean(Prediction.Yhat~=Y);
        UsageKnn = Ensemble.Submodel{i}.UsageKnn;
        ok_hat = logical(knnclassify(X, UsageKnn.X0, UsageKnn.C, 3));
        ok = (Prediction.Yhat==Y);
        MetaError(i) = mean(ok_hat ~= ok);
    end
end

