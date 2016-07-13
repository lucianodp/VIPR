clear;
load('bodyfat.mat');
Solver = @SVMregressionSolver; % Solver takes X, Y as parameters
Predict = @SVMregressionPredict;
d_range = 3:3;
P = 3; % number of projections to be selected
ComputeLoss = @ComputeRegSqLossEst;  % compute local MSE for an estimator based on 3-nearest neighbors
LossParams = 3; % the parameter k for the loss computation
SelectionMethod = 'greedy';
SelectionParams = 0;
[VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, Features);
[FigHandles] = VIPRPlotModel(VIPRmodel);
[VIPRtest] = VIPRTestModel(VIPRmodel, Predict, X, Y);
[VIPRtest] = VIPRaddFeatureNames(VIPRtest, Features);
[FigHandles] = VIPRPlotModel(VIPRtest);