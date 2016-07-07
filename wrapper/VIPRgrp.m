function [VIPRclusteringModel] = VIPRgrp(filename, d, P, K)
% Train and plot RIPR clustering model
% Filename - mat file containing X, Features
% d - max. dimensionality of recovered projections
% P - number of informative projections to be retrieved
% K - max number of clusters per informative projection
    load(filename);
    numcvfolds = 5;
    VIPRclusteringModel = VIPRclusteringCrossValidation(X,d,numcvfolds,K,P);
    %VIPRclusteringTestResults = VIPRclusteringTestModel(VIPRclusteringModel,X_test);
    [figHandles] = PlotVIPRModel(VIPRclusteringModel,Features);
end

