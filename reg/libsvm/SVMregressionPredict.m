function [Y_hat] = SVMregressionPredict(Xtest, Ytest, svmmodel)
% wrapper for the svm library
    Y_hat = svmpredict(Ytest,Xtest,svmmodel);
end