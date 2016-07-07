clear;
load('osteoarthritis_pain.mat');
Solver = @SVMclassificationSolver; % Solver takes X, Y as parameters
Predict = @SVMclassificationPredict;
d_range = 2:2;
P = 2; % number of projections to be selected
ComputeLoss = @ComputeKNNloss; % compute local MSE for an estimator based on 3-nearest neighbors
LossParams = 3; % the parameter k for the loss computation
SelectionMethod = 'greedy';
SelectionParams = 0;
[VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, Features);
[FigHandles] = VIPRPlotModel(VIPRmodel);
[VIPRtest] = VIPRTestModel(VIPRmodel, Predict, X, Y);
[FigHandles] = VIPRPlotModel(VIPRtest);