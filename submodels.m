function [ json ] = submodels( file, task, user_selected_features, d_range, P, LossParams, SelectionMethod, SelectionParams, withhold )
%SUBMODELS Computes the informative projections by IPE
%   P [number] of projections to be selected
%   task [string] 'cls'-classification, 'reg'-regression, 'grp'-clustring
%   user_selected_features [vector] indexes of user-selected features
%   LossParams [number] the parameter k for the loss computation
%   withhold [number] percentage to be held for test, [0, 100)

%% Parameters
% use regression as the default solver and predictor

if strcmp('cls', task)
    Solver = @SVMclassificationSolver;
    Predictor = @SVMclassificationPredict;
    ComputeLoss = @ComputeKNNloss; % compute local MSE for an estimator based on 3-nearest neighbors
    %LossParams = 3; % the parameter k for the loss computation
elseif strcmp('grp', task)
    Solver = @kMeansSolver; % Solver takes X, Y as parameters
    Predictor = @kMeansPredict;
    ComputeLoss = @ComputekMeansLoss;
    %LossParams = 2; % the parameter k for the loss computation
elseif strcmp('reg', task)
    Solver = @SVMregressionSolver; % Solver takes X, Y as parameters
    Predictor = @SVMregressionPredict;
    ComputeLoss = @ComputeRegSqLossEst;  % compute local MSE for an estimator based on 3-nearest neighbors
else % unknown learning method
    e = MException('IPE:MATLAB:submodels:unknownLearningMethod','Unknown learning method. Supports cls (classification), reg (regression), grp (clustring).');
    throw(e);
end


%% Load data
[pathstr,name,ext] = fileparts(file);
if strcmp('.mat',ext)
    load(file);
elseif strcmp('.csv',ext)
    [X,Y,Features]=csv2mat(file);
else % unknown file type
    e = MException('IPE:MATLAB:submodels:unknownFile','Unknown file type. Supports mat and csv.');
    throw(e);
end
if isempty(user_selected_features) == 0
    X = X(:,user_selected_features);
    if exist('Features', 'var')
        Features = Features(user_selected_features);
    end
end

%% Divid the data to training and test set
doTest = 0;
if withhold >= 10 && withhold <= 50
    doTest = 1;
    num_samples = size(X,1)*withhold/100;
    permuted_idx = randperm(size(X,1));
    idx_test = permuted_idx(1:num_samples);
    idx_train = setdiff(1:size(X,1),idx_test);
    Xtrain = X(idx_train,:);
    Ytrain = Y(idx_train,:);
    Xtest = X(idx_test,:);
    Ytest = Y(idx_test,:);
else
    doTest = 0;
    Xtrain = X;
    Ytrain = Y;
end

%% VIPR training
[VIPRmodelControl] = VIPRTrainModel(Solver, Xtrain, Ytrain, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams);
if strcmp('grp', task)
    [VIPRmodelControl] = VIPRMarkClusters(VIPRmodelControl, @kMeansPredict);
end
if exist('Features', 'var')
    [VIPRmodelControl] = VIPRaddFeatureNames(VIPRmodelControl, Features);
end

%% VIPR testing
if doTest == 1
    VIPRtest = VIPRTestModel(VIPRmodelControl, Predictor, Xtest, Ytest);
end

%% Construct the results
model = VIPRmodelControl.Submodel;

% Remove some unused values
for i = 1: size(model,2)
    model{1,i} = rmfield(model{1,i}, 'Model');
    model{1,i} = rmfield(model{1,i}, 'PointsIdx');
end

%% Compute the best viewpoint coordinate by SVD
for i = 1 : size(model, 2)
    [~,~,V] = svd(model{1,i}.Xsub);
    model{1,i}.viewpoint = V(1,:);
end

%% Form results
result = struct;
result.submodels = model;
if doTest == 1
    result.test = testResults(VIPRmodelControl, VIPRtest);
end

%% Convert the model to json string
json = savejson('', result, 'Compact', 1);
end


function [VIPRTestResults] = testResults(VIPRmodel,VIPRtest)
    VIPRTestResults = struct;

    for j=1:length(VIPRmodel.Submodel)
        VIPRTestResults.submodels{j} = struct;
        VIPRTestResults.submodels{j}.Xsub = VIPRtest.Submodel{j}.Xsub;
        VIPRTestResults.submodels{j}.Yhat = VIPRtest.Submodel{j}.Ysub;
        VIPRTestResults.submodels{j}.Ysub = VIPRtest.TrueY; % true Y
        VIPRTestResults.submodels{j}.FeatureNames = VIPRmodel.Submodel{j}.FeatureNames;
    end

end
