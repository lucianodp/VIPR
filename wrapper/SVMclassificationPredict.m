function [Y_hat] = SVMclassificationPredict(Xtest, Ytest, svmmodel)
    Y_hat = svmpredict(Ytest,Xtest,svmmodel);
end

