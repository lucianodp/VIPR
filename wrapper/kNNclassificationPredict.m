function [Y_hat] = kNNclassificationPredict(Xtest, Ytest, knnmodel)
    Y_hat = knnmodel.predict(Xtest);
end

