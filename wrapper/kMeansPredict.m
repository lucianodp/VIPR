function [Y_hat] = kMeansPredict(Xtest, Ytest, KmeansModel)
%KMEANSPREDICT Summary of this function goes here
%   Detailed explanation goes here
    [KmeansTestResults] = KmeansEvaluation(KmeansModel, Xtest);
    Y_hat = KmeansTestResults.SelectedCenters;
end
