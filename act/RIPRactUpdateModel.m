function [RIPRactModel] = RIPRactUpdateModel(RIPRactModel, X, Y, lambda)
    [RIPRactModel] = RIPRclsTrainModel([RIPRactModel.X;X],[RIPRactModel.Y;Y],RIPRactModel.d,lambda);
end