% New VIPR workflow for SVM regression
Solver = @SVMregressionSolver; % Solver takes X, Y as parameters
Predictor = @SVMregressionPredict;
d_range = 3:3;
P = 3; % number of projections to be selected
ComputeLoss = @ComputeRegSqLossEst;  % compute local MSE for an estimator based on 3-nearest neighbors
LossParams = 4; % the parameter k for the loss computation
SelectionMethod = 'greedy';
SelectionParams = 0;

load('cerebral-palsy_control.mat');
user_selected_features = 1:size(X,2); % indexes of user-selected features
X = X(:,user_selected_features);
Features = Features(user_selected_features);

[VIPRmodelControl] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelControl] = VIPRaddFeatureNames(VIPRmodelControl, Features);

load('cerebral-palsy_treated.mat');
[VIPRmodelTreated] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelTreated] = VIPRaddFeatureNames(VIPRmodelTreated, Features);

load('cerebral-palsy_prop-1_control.mat');
[VIPRmodelProp1Control] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp1Control] = VIPRaddFeatureNames(VIPRmodelProp1Control, Features);

load('cerebral-palsy_prop-2_control.mat');
[VIPRmodelProp2Control] = VIPRTrainModel(Solver, X, Y, d_range, 2, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp2Control] = VIPRaddFeatureNames(VIPRmodelProp2Control, Features);

load('cerebral-palsy_prop-3_control.mat');
[VIPRmodelProp3Control] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp3Control] = VIPRaddFeatureNames(VIPRmodelProp3Control, Features);

load('cerebral-palsy_prop-4_control.mat');
[VIPRmodelProp4Control] = VIPRTrainModel(Solver, X, Y, d_range, 1, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp4Control] = VIPRaddFeatureNames(VIPRmodelProp4Control, Features);

load('cerebral-palsy_prop-1_treated.mat');
[VIPRmodelProp1Treated] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp1Treated] = VIPRaddFeatureNames(VIPRmodelProp1Treated, Features);

load('cerebral-palsy_prop-2_treated.mat');
[VIPRmodelProp2Treated] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp2Treated] = VIPRaddFeatureNames(VIPRmodelProp2Treated, Features);

load('cerebral-palsy_prop-3_treated.mat');
[VIPRmodelProp3Treated] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp3Treated] = VIPRaddFeatureNames(VIPRmodelProp3Treated, Features);

load('cerebral-palsy_prop-4_treated.mat');
[VIPRmodelProp4Treated] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp4Treated] = VIPRaddFeatureNames(VIPRmodelProp4Treated, Features);

load('cerebral-palsy_prop-5_treated.mat');
[VIPRmodelProp5Treated] = VIPRTrainModel(Solver, X, Y, d_range, 1, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
[VIPRmodelProp5Treated] = VIPRaddFeatureNames(VIPRmodelProp5Treated, Features);

[FigHandles] = VIPRPlotModel(VIPRmodelProp5Treated);

save('cerebral-palsy_VIPR.mat');