function [Prediction] = ClassifierPredict(ClsModel,X)
%PREDICTCLASSIFIER use ClsModel to make a prediction
    Prediction = struct;
    %[Prediction.Yhat,Prediction.scores,Prediction.stdevs] = predict(ClsModel.B,X);
    [Y, node, labels] = eval(ClsModel.T, X);
    Prediction.Yhat = cellfun(@str2num,Y);
    Prediction.scores = full(sparse(1:size(X,1),labels,ones(size(X,1),1)));
    delta = numel(ClsModel.ClassNames)-size(Prediction.scores,2);
    if (delta>0)
        Prediction.scores = [Prediction.scores,zeros(size(Prediction.scores,1),delta)];
    end
end