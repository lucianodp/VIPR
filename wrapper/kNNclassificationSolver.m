function [knnmodel] = kNNclassificationSolver(X, Y, k)
    knnmodel = struct;
    knnmodel.X = X;
    knnmodel.Y = Y;
    knnmodel.k = k;
end