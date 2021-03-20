function [svmmodel] = SVMclassificationSolver(X, Y)
    %svmmodel = svmtrain(Y, X,' -t 2 -c 100 -p 0.001 -h 0');
    C = 1e5;
    svmmodel = fitcsvm(X, Y, 'Cost', [0 C; C 0], 'KernelFunction', 'RBF', 'KernelScale', 'auto');
end

