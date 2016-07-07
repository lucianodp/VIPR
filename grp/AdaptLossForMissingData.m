function [LossMissing] = AdaptLossForMissingData(Loss,Projections,X_Missing)
    inf_value = 10e8;
    Proj_Missing = zeros(size(Loss,1),size(Loss,2));
    for i=1:length(Projections)
        feature_idx = Projections{i,1};
        Proj_Missing(:,i) = max(X_Missing(:,feature_idx),[],2);
    end
    LossMissing = (~Proj_Missing).*Loss + Proj_Missing*inf_value;
end