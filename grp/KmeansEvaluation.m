function [KmeansTestResults] = KmeansEvaluation(KmeansModel, Xtest)
    KmeansTestResults = struct;
    KmeansTestResults.Dist = zeros(size(Xtest,1),1);
    KmeansTestResults.SelectedCenters = zeros(size(Xtest,1),1);
    for i=1:size(Xtest,1)
        [KmeansTestResults.Dist(i), best] = min(DistToCenters(Xtest(i,:),KmeansModel.Centers));
        KmeansTestResults.SelectedCenters(i) = best;
    end
    KmeansTestResults.SumDist = sum(KmeansTestResults.Dist);
    KmeansTestResults.LogVolume = zeros(size(KmeansModel.Centers,1),1);
    d = size(Xtest,2);
    for i=1:size(KmeansModel.Centers,1)
        idx = (KmeansTestResults.SelectedCenters==i);
        r = max(KmeansTestResults.Dist(idx));
        if(isscalar(r))
            KmeansTestResults.LogVolume(i) = ComputeLogBallSurfVolume(r,d);
        else
            KmeansTestResults.LogVolume(i) = 0;
        end
    end
end