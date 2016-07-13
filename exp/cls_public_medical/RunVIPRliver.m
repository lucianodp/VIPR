clear;
load('liver_disorders_uci.mat');
d_range = 2:3;
P = 3;
Solver = @SVMclassificationSolver;
Predict = @SVMclassificationPredict;
ComputeLoss = @ComputeKNNloss;
LossParams = 3;
SelectionMethod = 'greedy';
SelectionParams = 0;
[VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, Features);
[FigHandles] = VIPRPlotModel(VIPRmodel);

featurename = 'alkaline phosphotase';
featureid = GetFeatureId(Features, featurename);
if (featureid>0)
    [VIPRmodel2] = VIPRaddFeature(VIPRmodel, 1, featureid, featurename, ComputeLoss, LossParams, Solver);
    [FigHandles2] = VIPRPlotModel(VIPRmodel2);
end