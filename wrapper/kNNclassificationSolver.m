function [knnmodel] = kNNclassificationSolver(X, Y)
    knnmodel = fitcknn(X, Y, 'NumNeighbors', 3, 'Distance','euclidean');
end
