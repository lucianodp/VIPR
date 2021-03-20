function [Y_hat] = SVMregressionPredict(Xtest, Ytest, svmmodel)
    Y_hat = svmmodel.predict(Xtest);
end