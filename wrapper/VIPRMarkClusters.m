function [VIPRmodel] = VIPRMarkClusters(VIPRmodel, ClusteringPredict)
    for p=1:length(VIPRmodel.Submodel)
        VIPRmodel.Submodel{p}.Ysub = ClusteringPredict(VIPRmodel.Submodel{p}.Xsub, 0, VIPRmodel.Submodel{p}.Model);
        VIPRmodel.Y(VIPRmodel.Submodel{p}.PointsIdx) = VIPRmodel.Submodel{p}.Ysub;
    end
end

