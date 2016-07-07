function [VIPRtest] = VIPRTestModel(VIPRmodel, Predict, XTest, YTest, MetricEvalFunctions)
% This function tests a generic VIPR model.
% The loss at a test point is the loss at the nearest training point
%
% Output: the VIPR test structure, which has the same fields as the
% VIPRmodel structure. Some of the fields have a different interpretation
% - VIPRmodel.Y: the PREDICTED output for a point
% 
    VIPRtest = VIPRmodel;
    VIPRtest.X = XTest;
    VIPRtest.TrueY = YTest;
    VIPRtest.Classes = VIPRmodel.Classes;
    VIPRtest.Projections = VIPRmodel.Projections;
    VIPRtest.ProjectionIsSelected = VIPRmodel.ProjectionIsSelected;
    VIPRtest.L = ones(size(XTest,1),size(VIPRmodel.L,2));
    Loss = VIPRmodel.L(VIPRmodel.B);
    for p = 1:length(VIPRmodel.Submodel)
        VIPRtest.Submodel{p} = struct;
        VIPRtest.Submodel{p}.ProjIdx = VIPRmodel.Submodel{p}.ProjIdx;
        VIPRtest.Submodel{p}.ProjDim = VIPRmodel.Submodel{p}.ProjDim;
        VIPRtest.Submodel{p}.Model = VIPRmodel.Submodel{p}.Model;
        % Find the nearest neighbors of the test points
        % Q: Should I use all the training points?
        [idx,d] = knnsearch(VIPRmodel.Submodel{p}.Xsub,XTest(:,VIPRmodel.Submodel{p}.ProjDim),'K',1);
        % The loss of the points on this submodel will be the loss of the nearest-neighbor
        VIPRtest.L(:,VIPRtest.Submodel{p}.ProjIdx) = Loss(idx);
        % Q: Should I find points assigned to the submodel based on their nearest neighbor on all projections
        % VIPRtest.Submodel{p}.PointsIdx = ismember(idx,VIPRmodel.Submodel{p}.PointsIdx);
    end
    % Assign test points to the submodels with the lowest loss
    [VIPRtest.Lsel,idx] = min(VIPRtest.L(:,VIPRmodel.ProjectionIsSelected),[],2);
    VIPRtest.Y = NaN(size(YTest,1),size(YTest,2));
    VIPRtest.B = false(size(XTest,1),size(VIPRmodel.L,2));
    for p = 1:length(VIPRtest.Submodel)
        VIPRtest.Submodel{p}.PointsIdx = (idx==p);
        VIPRtest.Submodel{p}.Xsub = VIPRtest.X(VIPRtest.Submodel{p}.PointsIdx,VIPRtest.Submodel{p}.ProjDim);
        VIPRtest.Submodel{p}.Ysub = Predict(VIPRtest.Submodel{p}.Xsub, VIPRtest.TrueY(VIPRtest.Submodel{p}.PointsIdx), VIPRmodel.Submodel{p}.Model);
        VIPRtest.Y(VIPRtest.Submodel{p}.PointsIdx) = VIPRtest.Submodel{p}.Ysub;
        VIPRtest.B(VIPRtest.Submodel{p}.PointsIdx,VIPRtest.Submodel{p}.ProjIdx) = true;
    end  
end