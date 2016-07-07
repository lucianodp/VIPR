function [KmeansModel] = kMeansSolver(X, Y)
    KmeansModel = struct;
    [idx, KmeansModel.Centers] = kmeans(X,3);
end
