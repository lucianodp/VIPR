clear;
load('grp_uci_miniboone.mat');
Solver = @kMeansSolver; % Solver takes X, Y as parameters
Predict = @kMeansPredict;
d_range = 3:3;
P = 2; % number of projections to be selected
ComputeLoss = @ComputekMeansLoss; % compute local MSE for an estimator based on 3-nearest neighbors
LossParams = 2; % the parameter k for the loss computation
SelectionMethod = 'greedy';
SelectionParams = 0;
Y = zeros(size(X,1),1);
[VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodel] = VIPRMarkClusters(VIPRmodel, @kMeansPredict);
[VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, Features);
[FigHandles] = VIPRPlotModel(VIPRmodel);
%[VIPRtest] = VIPRTestModel(VIPRmodel, Predict, X(1:2:end,:), Y(1:2:end));
%[FigHandles] = VIPRPlotModel(VIPRtest);