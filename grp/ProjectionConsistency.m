function [Consistency0, Consistency1, Comparison] = ProjectionConsistency(VIPRclusteringmodel, d, k)
    X = VIPRclusteringmodel.TrainData;
    Consistency0 = cell(size(VIPRclusteringmodel.Submodel,1),1);
    Consistency1 = cell(size(VIPRclusteringmodel.Submodel,1),1);
    for i=1:size(VIPRclusteringmodel.Submodel,1)
        Y = VIPRclusteringmodel.Submodel{i,1}.PointsIdx;
        [Consistency0{i,1}, proj] = LocalEntropyEstimator(X,double(Y),d,k);
        K = VIPRclusteringmodel.Submodel{i,1}.ClusteringResult.ClusterIdx;
        [C1, proj] = LocalEntropyEstimator(X(Y,:),K,d,k);
        %Consistency1{i,1} = zeros(size(Consistency0{i,1},1),size(Consistency0{i,1},2));
        %Consistency1{i,1}(Y,:) = C1;
        Consistency1{i,1} = C1;
    end
    Comparison.Projections = proj;
    Comparison.C0 = cell(size(VIPRclusteringmodel.Submodel,1),1);
    Comparison.C1 = cell(size(VIPRclusteringmodel.Submodel,1),1);
    for i=1:size(VIPRclusteringmodel.Submodel,1)
        Comparison.C0{i} = ProjectionComparison(Consistency0{i});
        Comparison.C1{i} = ProjectionComparison(Consistency1{i});
    end
end

function [Comp] = ProjectionComparison(Consistency)
    Comp = struct;
    Comp.Mean = mean(Consistency);
    Comp.Median = median(Consistency);
    Comp.Var = var(Consistency);
    vmax = Comp.Mean + 3*sqrt(Comp.Var);
    DisagreementOutlier = (Consistency > repmat(vmax,size(Consistency,1),1));
    DisagreementOutlier = logical(max(double(DisagreementOutlier),[],2));
    vmin = Comp.Mean - 3*sqrt(Comp.Var);
    AgreementOutlier = (Consistency < repmat(vmin,size(Consistency,1),1));
    AgreementOutlier = logical(max(double(AgreementOutlier),[],2));
    Comp.RobustMean = mean(Consistency((~DisagreementOutlier) & (~AgreementOutlier),:));
    Comp.RobustMedian = median(Consistency((~DisagreementOutlier) & (~AgreementOutlier),:));
    Comp.RobustVar = var(Consistency((~DisagreementOutlier) & (~AgreementOutlier),:));
    Comp.OuliersA = AgreementOutlier;
    Comp.OuliersD = DisagreementOutlier;
end