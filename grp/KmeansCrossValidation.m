function [KmeansModel] = KmeansCrossValidation(X,kf,kmax)
    [Xtrain, Xtest] = SplitData(X,kf);
    kvector = 1:kmax;
    kmeans_eval = zeros(kf,length(kvector));
    for j=1:length(kvector)
        k = kvector(j);
        for i=1:kf
            KmeansModel = TrainKmeans(Xtrain{i},k);
            KmeansTestResults = KmeansEvaluation(KmeansModel, Xtest{i});
            kmeans_eval(i,j) = KmeansTestResults.SumDist;
        end
    end
    kmeans_eval_mean = mean(kmeans_eval,1);
    [dist_best,idx_best] = min(kmeans_eval_mean);
    KmeansModel = TrainKmeans(X,kvector(idx_best));
end

function KmeansModel = TrainKmeans(X,k)
    [IDX,C,sumd,D] = kmeans(X,k,'emptyaction','singleton');
    KmeansModel = struct;
    KmeansModel.TrainData = X;
    KmeansModel.Idx = IDX;
    KmeansModel.Centers = C;
    KmeansModel.SumDist = sumd;
    KmeansModel.Dist = D;
end