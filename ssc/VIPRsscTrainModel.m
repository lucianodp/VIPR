function [VIPRsscModel] = VIPRsscTrainModel(X,Y,d,p,ClassificationSolver)
% VIPR semi-supervised classification
    k = 1;
    [Loss, Projections] = LocalSscLossEstimator(X,Y,d,k);
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
    VIPRsscModel = struct;
    VIPRsscModel.Xtrain= X;
    VIPRsscModel.Ytrain= Y;
    VIPRsscModel.Projections = Projections;
    VIPRsscModel.PointProjIdx = Point_Proj_Subset_Original_idx;
    VIPRsscModel.SelP = Projections(unique(Point_Proj_Subset_Original_idx));
    VIPRsscModel.Submodel = cell(p,1);
    for i=1:p
        VIPRsscModel.Submodel{i} = struct;
        VIPRsscModel.Submodel{i}.ProjIdx = Proj_Subset_IdxCount(i,1);
        VIPRsscModel.Submodel{i}.ProjDim = Projections{VIPRsscModel.Submodel{i}.ProjIdx};
        VIPRsscModel.Submodel{i}.PointsIdx = (VIPRsscModel.PointProjIdx == VIPRsscModel.Submodel{i}.ProjIdx);
        VIPRsscModel.Submodel{i}.Xsub = X(VIPRsscModel.Submodel{i}.PointsIdx, VIPRsscModel.Submodel{i}.ProjDim);
        VIPRsscModel.Submodel{i}.Ysub =  Y(VIPRsscModel.Submodel{i}.PointsIdx);
        %VIPRregressionModel.Submodel{i}.ClsModel = ClassificationSolver(VIPRregressionModel.Submodel{i}.Xsub,VIPRregressionModel.Submodel{i}.Ysub);
    end
end