function [VIPRclusteringmodel] = VIPRclusteringCrossValidation(X,d,kf,kmax,p)
    [Xtrain, Xtest] = SplitData(X,kf);
    kvector = 1:kmax;
    if(nargin<5)
        pvector = 1:2:5;
    else
        pvector = [p];
    end
    [kvector,pvector] = meshgrid(kvector,pvector);
    kvector = reshape(kvector,size(kvector,1)*size(kvector,2),1);
    pvector = reshape(pvector,size(pvector,1)*size(pvector,2),1);
    metric = zeros(length(kvector),1); 
    for j=1:length(kvector)
        k = kvector(j); p = pvector(j);
        sumdist = zeros(kf,1); 
        VIPRclusteringmodel = cell(kf,1);
        for i=1:kf
            VIPRclusteringmodel{i} = VIPRclusteringTrainModel(Xtrain{i},d,k,p);
            VIPRclusteringTestResults = VIPRclusteringTestModel(VIPRclusteringmodel{i},Xtest{i});
            sumdist(i) = VIPRclusteringTestResults.sumDistProjDim;
        end
        metric(j) = mean(sumdist);
    end
    [best,idx] = min(metric);
    best_k = kvector(idx);
    best_p = pvector(idx);
    VIPRclusteringmodel = VIPRclusteringTrainModel(X,d,best_k,best_p);
end