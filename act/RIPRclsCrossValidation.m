function [RIPRclsModel] = RIPRclsCrossValidation(X,Y,d,lambda_list)
% Use cross-validation to pick lambda for the RIPR classification model
    [Xtrain, Xtest] = SplitData(X,kf);
    [Ytrain, Ytest] = SplitData(Y,kf);
    metric = zeros(length(lambda_list),1); 
    for j=1:length(lambda_list)
        lambda = lambda_list(j);
        RIPRclsModel = cell(kf,1);
        acc = zeros(kf,1);
        for i=1:kf
            RIPRclsModel{i} = RIPRclsTrainModel(Xtrain{i},Ytrain{i},d,lambda);
            RIPRclsTestResults = RIPRclsTestModel(RIPRclsModel, Xtest{i}, Ytest{i});
            acc(i) = RIPRclsTestResults.Accuracy;
        end
        metric(j) = mean(acc);
    end
    [best_acc,idx] = max(metric);
    best_lambda = lambda_list(idx);
    RIPRclsModel = RIPRclsTrainModel(X,Y,d,best_lambda);
end