function [Y_hat] = SVMclassificationPredict(Xtest, Ytest, svmmodel)
    Y_hat = svmmodel.predict(Xtest);
end

