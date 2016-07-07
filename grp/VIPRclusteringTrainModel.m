function [VIPRclusteringmodel] = VIPRclusteringTrainModel(X,d,k,p)
    % Returns a clustering model consisting of
    % - the projections considered (up to size d)
    % - the subset of projections selected
    % - the index of the projection used for each point
    % - the clustering model for each projection
    [Loss, Projections] = LocalDenClusteringLoss(X,d,k);
    [Target, Point_Proj_idx] = min(Loss,[],2);
    if(p > length(Point_Proj_idx))
        p = length(Point_Proj_idx);
    end
    Proj_IdxCount = [unique(Point_Proj_idx), histc(Point_Proj_idx,unique(Point_Proj_idx))];
    [Proj_Count_Desc, Proj_Count_Desc_idx] = sort(Proj_IdxCount(:,2),'descend');
    Proj_IdxCount_Desc = Proj_IdxCount(Proj_Count_Desc_idx,:);
    if p>size(Proj_IdxCount_Desc,1)
        p = size(Proj_IdxCount_Desc,1);
    end
    Proj_Subset_IdxCount = Proj_IdxCount_Desc(1:p,:);
    Loss_Subset = Loss(:,Proj_Subset_IdxCount(:,1));
    [Traget_Subset, Point_Proj_Subset_idx] = min(Loss_Subset,[],2);
    Point_Proj_Subset_Original_idx = Proj_Subset_IdxCount(Point_Proj_Subset_idx,1);
    VIPRclusteringmodel = struct;
    VIPRclusteringmodel.TrainData = X;
    VIPRclusteringmodel.Projections = Projections;
    VIPRclusteringmodel.PointProjIdx = Point_Proj_Subset_Original_idx;
    VIPRclusteringmodel.Submodel = cell(p,1);
    i=1;
    for dummy=1:p
        VIPRclusteringmodel.Submodel{i} = struct;
        VIPRclusteringmodel.Submodel{i}.ProjIdx = Proj_Subset_IdxCount(i,1);
        VIPRclusteringmodel.Submodel{i}.ProjDim = Projections{VIPRclusteringmodel.Submodel{i}.ProjIdx};
        VIPRclusteringmodel.Submodel{i}.PointsIdx = (VIPRclusteringmodel.PointProjIdx == VIPRclusteringmodel.Submodel{i}.ProjIdx);
        X_subset = X(VIPRclusteringmodel.Submodel{i}.PointsIdx, VIPRclusteringmodel.Submodel{i}.ProjDim);
        X_subset_0 = X(VIPRclusteringmodel.Submodel{i}.PointsIdx,:);
        % information specific to the clustering algorithm
        if size(X_subset,1) >= k
            [IDX,C,sumd,D] = kmeans(X_subset,k,'emptyaction','singleton');
            VIPRclusteringmodel.Submodel{i}.ClusteringResult.ClusterIdx = IDX;
            VIPRclusteringmodel.Submodel{i}.ClusteringResult.ClusterCenters = C;
            VIPRclusteringmodel.Submodel{i}.ClusteringResult.Sumdist = sumd;
            VIPRclusteringmodel.Submodel{i}.ClusteringResult.ClusterDist = D;
            for j=1:size(C,1)
                VIPRclusteringmodel.Submodel{i}.ClusteringResult.ClusterCenters0(j,:) = mean(X_subset_0(IDX==j,:),1);
            end
            i = i+1;
        end
    end
    VIPRclusteringmodel.Submodel = VIPRclusteringmodel.Submodel(1:i-1);
end