function [VIPRclusteringTestResults] = VIPRclusteringTestModel(VIPRclusteringmodel,Xtest)
    % evaluate the clustering model using the test points Xtest
    VIPRclusteringTestResults = struct;
    VIPRclusteringTestResults.distProjDim = zeros(size(Xtest,1),1);
    VIPRclusteringTestResults.distAllDim = zeros(size(Xtest,1),1);
    SubmodelDistances = zeros(size(Xtest,1),length(VIPRclusteringmodel.Submodel));
    SubmodelSelection = zeros(size(Xtest,1),length(VIPRclusteringmodel.Submodel));
    SelectedClusterIdx = zeros(size(Xtest,1),1);
    for i=1:size(Xtest,1)
        d = zeros(length(VIPRclusteringmodel.Submodel),1);
        d0 = zeros(length(VIPRclusteringmodel.Submodel),1);
        for j=1:length(VIPRclusteringmodel.Submodel)
            xp = Xtest(i,VIPRclusteringmodel.Submodel{j}.ProjDim);
            c = VIPRclusteringmodel.Submodel{j}.ClusteringResult.ClusterCenters;
            [d(j), bc_idx(j)] = min(DistToCenters(xp,c));
            c0 = VIPRclusteringmodel.Submodel{j}.ClusteringResult.ClusterCenters0;
            dist = DistToCenters(Xtest(i,:),c0);
            %d0(j) = dist(bc_idx(j));
            d0(j) = min(dist);
            SubmodelDistances(i,j) = d0(j);
        end
        % record best projection/cluster for datapoint i
        [VIPRclusteringTestResults.distProjDim(i), best_idx] = min(d);
        % index of selected cluster in best projection
        SelectedClusterIdx(i) = bc_idx(best_idx);
        SubmodelSelection(i,best_idx) = 1;
        VIPRclusteringTestResults.idxBestProj(i) = VIPRclusteringmodel.Submodel{best_idx}.ProjIdx;
        VIPRclusteringTestResults.idxClusterInBestProj(i) = bc_idx(best_idx);
        % note: we could improve by picking the cluster based on all dimensions
        %VIPRclusteringTestResults.distAllDim(i) = d0(best_idx);
        VIPRclusteringTestResults.distAllDim(i) = min(d0);
    end
    VIPRclusteringTestResults.sumDistProjDim = sum(VIPRclusteringTestResults.distProjDim);
    VIPRclusteringTestResults.sumDistAllDim = sum(VIPRclusteringTestResults.distAllDim);
    
    % get cluster volume
    for j=1:length(VIPRclusteringmodel.Submodel)
        idxpoints = logical(SubmodelSelection(:,j)); % points in this submodel
        features = setdiff(1:size(Xtest,2),VIPRclusteringmodel.Submodel{best_idx}.ProjDim);
        cube = max(Xtest(idxpoints,features))-min(Xtest(idxpoints,features));
        cubevol = sum(log(cube));
        d = length(VIPRclusteringmodel.Submodel{j}.ProjDim);
        submoddist = SubmodelDistances(idxpoints,j);
        for ii=1:size(VIPRclusteringmodel.Submodel{j}.ClusteringResult.ClusterCenters,1);
            radius = max(submoddist(SelectedClusterIdx(idxpoints)==ii,:));
            [ballvol, ballsurf] = ComputeLogBallSurfVolume(radius,d);
            if(isscalar(ballvol))
                VIPRclusteringTestResults.LogBallVol(j,ii) = ballvol;
            else
                VIPRclusteringTestResults.LogBallVol(j,ii) = 0;
            end
            VIPRclusteringTestResults.LogCubeVol(j,ii) = cubevol;
            VIPRclusteringTestResults.LogVolume(j,ii) = VIPRclusteringTestResults.LogBallVol(j,ii)+cubevol;
        end
    end
end