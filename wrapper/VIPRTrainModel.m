function [VIPRmodel] = VIPRTrainModel(Solver, X, Y, d_range, P, ComputeLoss, LossParams, SelectionMethod, SelectionParams)
% This function trains a generic VIPR model. With appropriate
% parametrization, it can be used for any number of tasks such as 
% classification, regression and clustering.
% Inputs:
% - Solver: function pointer specific to the task which will train a
% classifier or regressor or will perform clustering
%   [model] = Solver(Y,X);
% - X, Y: the training data, for clustering Y is a vector with 0 cols
% - d_range: the range for the dimensionality of the projections
% - ComputeLoss: function which computes a loss vector for a projection
% - SelectionMethod: method used to learn the selection matrix
% - SelectionParams: parameters for learning the selection matrix
% - LossParams: 
% Output: the VIPRmodel structure, with the following fields
% - L: loss matrix
% - B: selection matrix
% - Projections: the set of candidate 
% - ProjectionIsSelected: binary vector specifying whether a projection is selected
% - Information about each submodel in the ensemble in the structure Submodel{p}
%   - ProjIdx: the index of features 
%   - ProjDim: the features of the projection
%   - PointsIdx: a binary vector, true for the points assigned to the projection
%   - Xsub: the features of the points assigned to the projection
%   - Ysub: the labels of the points assigned to the projection
%   - Model: the solver trained on the projection
    MaximumFeatures = 50;
    MaximumProjections = 1000;
    [L, Proj] = ComputeLossMatrix(ComputeLoss, X, Y, d_range, LossParams, MaximumFeatures, MaximumProjections);
    [IPE] = IPEtrain(L,Proj,P,SelectionMethod,SelectionParams);
    VIPRmodel.X = X;
    VIPRmodel.Y = Y;
    VIPRmodel.Classes = unique(Y);
    VIPRmodel.Projections = IPE.AllProj;
    VIPRmodel.L = IPE.L;
    VIPRmodel.B = IPE.B;
    VIPRmodel.ProjectionIsSelected = (sum(IPE.B)>0);
    VIPRmodel.Classes = unique(VIPRmodel.Y);
    VIPRmodel.d_range = d_range;
    SelectedProjectionIdx = find(VIPRmodel.ProjectionIsSelected);
    for p=1:sum(VIPRmodel.ProjectionIsSelected)
        VIPRmodel.Submodel{p} = struct;
        VIPRmodel.Submodel{p}.ProjIdx = SelectedProjectionIdx(p);
        VIPRmodel.Submodel{p}.ProjDim = VIPRmodel.Projections{SelectedProjectionIdx(p)};
        VIPRmodel.Submodel{p}.PointsIdx = VIPRmodel.B(:,SelectedProjectionIdx(p));
        VIPRmodel.Submodel{p}.Xsub = VIPRmodel.X(VIPRmodel.Submodel{p}.PointsIdx, VIPRmodel.Submodel{p}.ProjDim);
        VIPRmodel.Submodel{p}.Ysub = VIPRmodel.Y(VIPRmodel.Submodel{p}.PointsIdx,:);
        VIPRmodel.Submodel{p}.Model = Solver(VIPRmodel.X(:,VIPRmodel.Submodel{p}.ProjDim), VIPRmodel.Y);
        %VIPRregressionModel.Submodel{p}.Model = Solver(VIPRregressionModel.Submodel{p}.Xsub, VIPRregressionModel.Submodel{p}.Ysub);
    end
end