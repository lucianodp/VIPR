function [svmmodel] = SVMregressionSolver(X,Y)
% wrapper for the svm library
    svmmodel = svmtrain(Y, X,' -s 3 -t 2 -c 100 -p 0.001 -h 0');
end