function [idx_active, score] = ActiveSelectionNoisy(RIPRactModel,X,r)
% This function selects noisy points. Lower score indicates noisier points.
% Characteristics of noisy points:
% - contradictory labels from different projections
% - high loss for all projections in the RIPR model

% score = difference between score of not(Y_hat) and Y_hat
% if there are no disagreeing projections, the score is 1 
    r = min(r,size(X,1));
    idx_active = false(size(X,1),1);
    [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    S = repmat(RIPRclsTestResults.Score,1,size(RIPRclsTestResults.AllScores,2));
    diffscore = disagreement.*(RIPRclsTestResults.AllScores - S) + (~disagreement);
    score = min(diffscore, [], 2);
    [sorted_score, sorted_idx] = sort(score, 'ascend');
    idx_active(sorted_idx(1:r)) = true;
end