function [VIPRregressionTestResult] = VIPRregressionTestModel(VIPRregressionModel, Xtest, Ytest, RegressionEval)
    VIPRregressionTestResult = struct;
    %for i=1:size(Xtest,1)
    %    dist = zeros(length(VIPRregressionModel.Submodel),1);
    %    pred = zeros(length(VIPRregressionModel.Submodel),1);
    %    for j=1:length(VIPRregressionModel.Submodel)
    %        xtest = Xtest(i,VIPRregressionModel.Submodel{j}.ProjDim);
    %        ytest = Ytest(i);
    %        dist(j) = DistToSubm(xtest,VIPRregressionModel.Submodel{j});
    %        pred(j) = RegressionEval(xtest, ytest, VIPRregressionModel.Submodel{j}.RegModel);
    %    end
    %    [mx, sel_idx] = min(dist);
    %    VIPRregressionTest.Y_hat(i) = pred(sel_idx);
    %end
    Y_hat = zeros(size(Xtest,1),length(VIPRregressionModel.Submodel));
    idx_best = zeros(size(Xtest,1),1);
    for j=1:length(VIPRregressionModel.Submodel)
        Y_hat(:,j) = RegressionEval(Xtest(:,VIPRregressionModel.Submodel{j}.ProjDim),Ytest,VIPRregressionModel.Submodel{j}.RegModel);
    end
    VIPRregressionTestResult.Y_hat = Y_hat;
    VIPRregressionTestResult.MSE = (Y_hat-repmat(Ytest,1,length(VIPRregressionModel.Submodel))).^2;
    VIPRregressionTestResult.MSE = min(VIPRregressionTestResult.MSE,[],2);
    VIPRregressionTestResult.MSE = mean(VIPRregressionTestResult.MSE);
    %VIPRregressionTestResult.MSE = mean((Ytest-VIPRregressionTest.Y_hat).^2);
end

function d = DistToSubm(xtest, submodel)
    [idx,d] = knnsearch(submodel.Xsub,xtest,'k',1);
end