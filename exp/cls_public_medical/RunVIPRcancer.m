clear;
load('colon_cancer_alon.mat');
d_range = 2:2;
P = 2;
Solver = @SVMclassificationSolver;
Predict = @SVMclassificationPredict;
ComputeLoss = @ComputeKNNloss;
LossParams = 3;
SelectionMethod = 'greedy';
SelectionParams = 0;
[VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, Features);
[FigHandles] = VIPRPlotModel(VIPRmodel);

featurename = 'Gene expression 1';
featureid = GetFeatureId(Features, featurename);
if (featureid>0)
    [VIPRmodel2] = VIPRaddFeature(VIPRmodel, 1, featureid, featurename, ComputeLoss, LossParams, Solver);
    [FigHandles2] = VIPRPlotModel(VIPRmodel2);
    [VIPRmodel3] = VIPRremoveFeature(VIPRmodel2, 1, featureid, ComputeLoss, LossParams, Solver);
    [FigHandles3] = VIPRPlotModel(VIPRmodel3);
end