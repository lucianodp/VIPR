function [Score] = ScoreIncongruentPoints(RIPRclsTestResults)
% The higher the score, the more incongruent the points
    %Score = zeros(size(RIPRclsTestResults.Score,1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    Score = max(disagreement,[],2);
    %Score = max(ones(size(RIPRclsTestResults.AllScores,1),size(RIPRclsTestResults.AllScores,2))./RIPRclsTestResults.AllScores.*disagreement,[],2);
end

