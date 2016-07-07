function [VIPRregressionModel] = VIPRregressionTrainModel(X,Y,d,p,RegressionSolver)
% VIPR regression
    k = 3;
    [Loss, Projections] = LocalNNRSquareLossEstimator(X,Y,d,k);
    [Target, Point_Proj_idx] = min(Loss,[],2);
    if(p > length(Point_Proj_idx))
        p = length(Point_Proj_idx);
    end
    Proj_IdxCount = [unique(Point_Proj_idx), histc(Point_Proj_idx,unique(Point_Proj_idx))];
    [Proj_Count_Desc, Proj_Count_Desc_idx] = sort(Proj_IdxCount(:,2),'descend');
    Proj_IdxCount_Desc = Proj_IdxCount(Proj_Count_Desc_idx,:);
    Proj_Subset_IdxCount = Proj_IdxCount_Desc(1:p,:);
    Loss_Subset = Loss(:,Proj_Subset_IdxCount(:,1));
    [Traget_Subset, Point_Proj_Subset_idx] = min(Loss_Subset,[],2);
    Point_Proj_Subset_Original_idx = Proj_Subset_IdxCount(Point_Proj_Subset_idx,1);
    VIPRregressionModel = struct;
    VIPRregressionModel.Xtrain= X;
    VIPRregressionModel.Ytrain= Y;
    VIPRregressionModel.Projections = Projections;
    VIPRregressionModel.PointProjIdx = Point_Proj_Subset_Original_idx;
    VIPRregressionModel.Submodel = cell(p,1);
    for i=1:p
        VIPRregressionModel.Submodel{i} = struct;
        VIPRregressionModel.Submodel{i}.ProjIdx = Proj_Subset_IdxCount(i,1);
        VIPRregressionModel.Submodel{i}.ProjDim = Projections{VIPRregressionModel.Submodel{i}.ProjIdx};
        %VIPRregressionModel.Submodel{i}.PointsIdx = (VIPRregressionModel.PointProjIdx == VIPRregressionModel.Submodel{i}.ProjIdx);
        VIPRregressionModel.Submodel{i}.PointsIdx = true(size(X,1),1);
        VIPRregressionModel.Submodel{i}.Xsub = X(VIPRregressionModel.Submodel{i}.PointsIdx, VIPRregressionModel.Submodel{i}.ProjDim);
        VIPRregressionModel.Submodel{i}.Ysub =  Y(VIPRregressionModel.Submodel{i}.PointsIdx);
        VIPRregressionModel.Submodel{i}.RegModel = RegressionSolver(VIPRregressionModel.Submodel{i}.Xsub,VIPRregressionModel.Submodel{i}.Ysub);
    end
end