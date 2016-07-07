function [VIPRregressionTestResult] = VIPRsscTestModel(VIPRsscModel, P0, Xtest, Ytest, ClassificationEval)
    VIPRregressionTestResult = struct;
    %Y_hat = zeros(size(Xtest,1),length(VIPRregressionModel.Submodel));
    %for j=1:length(VIPRregressionModel.Submodel)
    %    Y_hat(:,j) = ClassificationEval(Xtest(:,VIPRregressionModel.Submodel{j}.ProjDim),Ytest,VIPRregressionModel.Submodel{j}.RegModel);
    %end
    [P_SEL,Y_hat] = RECIP_SelectProjection(P,VIPRsscModel.Xtrain,VIPRsscModel.Ytrain,Xtest);
    VIPRregressionTestResult.Y_hat = Y_hat;
    VIPRregressionTestResult.Acc = (Y_hat==Ytest);
    VIPRregressionTestResult.MeanAcc = mean(VIPRregressionTestResult.Acc);
    [precision, recall] = ProjectionSetLoss(P0, VIPRregressionTestResult.Projections);
    VIPRregressionTestResult.Precision = precision;
    VIPRregressionTestResult.Recall = recall;
end