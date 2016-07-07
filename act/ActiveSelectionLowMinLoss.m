function [idx_active, score] = ActiveSelectionLowMinLoss(RIPRactModel,X,r)
% This function selects points that seem to be easily classifiable,
% using all projections (even the ones not in the model)
% the lower the score, the higher the minimum loss
    r = min(r,size(X,1));
    idx_active = false(size(X,1),1);
    [LossAll, Projections] = LocalSscLossEstimator([RIPRactModel.X;X],[RIPRactModel.Y;-ones(size(X,1),1)],RIPRactModel.d,1);
    MinLossAll = min(LossAll(size(RIPRactModel.X,1)+1:size(RIPRactModel.X,1)+size(X,1),:),[],2);
    score = MinLossAll;
    [sorted_scores, sorted_idx] = sort(MinLossAll,'ascend');
    idx_active(sorted_idx(1:r)) = true;
end