function [svmmodel] = SVMclassificationSolver(X, Y)
    C = 1e5;
    svmmodel = fitcsvm(X, Y, 'Cost', [0 C; C 0], 'KernelFunction', 'RBF', 'KernelScale', 'auto');
end

