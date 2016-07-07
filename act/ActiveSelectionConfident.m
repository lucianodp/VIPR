function [idx_active, loss] = ActiveSelectionConfident(RIPRactModel,X,r)
% This function selects points that seem to be easily classifiable,
% using RIPR projections. the lower the loss, the higher the confidence
    r = min(r,size(X,1));
    idx_active = false(size(X,1),1);
    [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
    loss = RIPRclsTestResults.Score;
    [sorted_score, sorted_idx] = sort(RIPRclsTestResults.Score, 'ascend');
    idx_active(sorted_idx(1:r)) = true;
end

