function [acc] = MetricEvalAccuracy(Xtr, Ytr, Xts, Yts, Yhat, Model)
%ACCURACYMETRICEVAL compute accuracy for predicted
    acc = sum(Yhat==Yts)./size(Yhat,1);
end