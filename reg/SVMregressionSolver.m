function [svmmodel] = SVMregressionSolver(X, Y)
    svmmodel = fitrsvm(X, Y, 'Epsilon', 0.001, 'KernelFunction', 'RBF', 'KernelScale', 'auto');
end