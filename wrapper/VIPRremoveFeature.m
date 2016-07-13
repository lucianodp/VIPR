function [VIPRmodel] = VIPRremoveFeature(VIPRmodel, s, featureid, ComputeLoss, LossParams, Solver)
%VIPRADDMODELFEATURES
% This function adds the specified feature to the specified submodel s.
    if(s <= length(VIPRmodel.Submodel))
        idx_old = VIPRmodel.Submodel{s}.ProjIdx;
        proj_new = setdiff(VIPRmodel.Submodel{s}.ProjDim, featureid);
        idx_new = FindProjectionId(VIPRmodel.Projections, proj_new);
        if (idx_new == 0) % if projection does not exist in the set, add it
            VIPRmodel.Projections = [VIPRmodel.Projections; proj_new];
            idx_new = length(VIPRmodel.Projections);
            loss = ComputeLoss(VIPRmodel.X(:,proj_new), VIPRmodel.Y, LossParams);
            VIPRmodel.L = [VIPRmodel.L, loss];
            VIPRmodel.B = [VIPRmodel.B, zeros(size(VIPRmodel.B,1),1)];
            VIPRmodel.d_range = min(VIPRmodel.d_range):max(max(VIPRmodel.d_range),length(proj_new));
            VIPRmodel.ProjectionIsSelected = [VIPRmodel.ProjectionIsSelected, false];
        end

        % create new submodel structure
        Submodel = struct;
        Submodel.ProjIdx = idx_new;
        Submodel.ProjDim = proj_new;
        Submodel.PointsIdx = VIPRmodel.Submodel{s}.PointsIdx;
        Submodel.Xsub = VIPRmodel.X(Submodel.PointsIdx,Submodel.ProjDim);
        Submodel.Ysub = VIPRmodel.Y(Submodel.PointsIdx,:);
        Submodel.Model = Solver(VIPRmodel.X(:,Submodel.ProjDim), VIPRmodel.Y);
        if (isfield(VIPRmodel.Submodel{s},'FeatureNames'))
            rem_feats = (VIPRmodel.Submodel{s}.ProjDim ~= featureid);
            Submodel.FeatureNames = VIPRmodel.Submodel{s}.FeatureNames(rem_feats);
        end

        % change selection matrix to reassign all points from the old
        % projection to the new projection
        VIPRmodel.B(Submodel.PointsIdx,idx_old) = false;
        VIPRmodel.B(Submodel.PointsIdx,idx_new) = true;
        VIPRmodel.ProjectionIsSelected(idx_old) = false;
        VIPRmodel.ProjectionIsSelected(idx_new) = true;
        
        VIPRmodel.Submodel{s} = Submodel;
    end
end