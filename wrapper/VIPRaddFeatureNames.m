function [VIPRmodel] = VIPRaddFeatureNames(VIPRmodel, FeatureNames)
    for i = 1:length(VIPRmodel.Submodel)
        VIPRmodel.Submodel{i}.FeatureNames = FeatureNames(VIPRmodel.Submodel{i}.ProjDim);
    end
end

