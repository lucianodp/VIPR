function [Y_hat] = kNNclassificationPredict(Xtest, Ytest, knnmodel)
    Y_hat = knnclassify(Xtest,knnmodel.X,knnmodel.Y,knnmodel.k);
end

