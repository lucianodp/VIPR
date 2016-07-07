function [RIPRclsTestResults] = RIPRclsTestModel(RIPRclsModel, Xtest, Ytest, k)
    if (nargin<4)
        k = 1;
    end
    % only consider classes for which we have at least k points in the train set
    j = 0;
    CompleteClasses = zeros(0,0);
    for i=1:length(RIPRclsModel.Classes)
        if (sum(RIPRclsModel.Y==RIPRclsModel.Classes(i))>=k)
            j = j+1;
            CompleteClasses(j,1) = RIPRclsModel.Classes(i);
        end
    end
    %RIPRclsModel.Classes = CompleteClasses;
    PI_hat =  RIPRclsModel.Projections(RIPRclsModel.ProjIdx);
    BestScore = zeros(size(Xtest,1),length(PI_hat));
    Yhat = zeros(size(Xtest,1),length(PI_hat));
    for i=1:length(PI_hat)
        features = PI_hat{i};
        Score = zeros(size(Xtest,1),length(RIPRclsModel.Classes));
        for j=1:length(RIPRclsModel.Classes)
            [IDX1,D1] = knnsearch(RIPRclsModel.X(RIPRclsModel.Y==RIPRclsModel.Classes(j),features),Xtest(:,features),'K',k);
            D1 = D1(:,k);
            [IDX0,D0] = knnsearch(RIPRclsModel.X(RIPRclsModel.Y~=RIPRclsModel.Classes(j),features),Xtest(:,features),'K',k);
            D0 = D0(:,k);
            Score(:,j) = RobustDivision(D1,D0);
        end
        [BestScore(:,i), min_idx] = min(Score,[],2);
        Yhat(:,i) = RIPRclsModel.Classes(min_idx);
    end
    [RIPRclsTestResults.Score, RIPRclsTestResults.ScoreIdx] = min(BestScore,[],2);
    if size(Yhat,2)>1
        RIPRclsTestResults.Yhat = Yhat(sub2ind(size(Yhat), 1:size(Yhat,1) , RIPRclsTestResults.ScoreIdx'))';
    else
        RIPRclsTestResults.Yhat = Yhat;
    end
    RIPRclsTestResults.Accuracy = mean(RIPRclsTestResults.Yhat==Ytest);
    RIPRclsTestResults.AllYhat = Yhat;
    RIPRclsTestResults.AllScores = BestScore;
end