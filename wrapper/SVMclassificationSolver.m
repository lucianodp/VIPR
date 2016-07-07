function [svmmodel] = SVMclassificationSolver(X, Y)
    svmmodel = svmtrain(Y, X,' -t 2 -c 100 -p 0.001 -h 0');
end

