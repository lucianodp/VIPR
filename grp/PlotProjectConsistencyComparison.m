function [figHandles] = PlotProjectConsistencyComparison(VIPRclusteringmodel, Comparison, FeatureNames)
    if (nargin < 3)
        FeatureNames = ConstructDefaultFeatureNames(size(VIPRclusteringmodel.TrainData,2));
    end
    figHandles = cell(size(VIPRclusteringmodel.Submodel,1),1);
    for i=1:size(VIPRclusteringmodel.Submodel,1)
        x0 = Comparison.C0{i}.Mean;
        x1 = Comparison.C1{i}.Mean;
        v0 = Comparison.C0{i}.Var;
        v1 = Comparison.C1{i}.Var;
        idx_cf = HasCommonFeatures(Comparison.Projections, VIPRclusteringmodel.Submodel{i}.ProjDim);
        idx_s = IsFeatureSuperset(Comparison.Projections, VIPRclusteringmodel.Submodel{i}.ProjDim);
        figHandles{i} = figure; hold on;
        %DrawVariance(figHandles{i},x0,x1,v0,v1,'b');
        scatter(x0(~idx_cf),x1(~idx_cf),'.b');
        scatter(x0(idx_cf),x1(idx_cf),'.m');
        scatter(x0(idx_s),x1(idx_s),'.r');
        legend('disjoint','non-disjoint','superset');
        title(ConstructProjectionName(FeatureNames(VIPRclusteringmodel.Submodel{i}.ProjDim)));
        xlabel('Selection Divergence');
        ylabel('Cluster Divergence');
    end
end

function h = DrawVariance(figHandle,x0,x1,v0,v1,C)
    set(0, 'CurrentFigure', figHandle);
    ellipse(v0,v1,zeros(size(v0,1),size(v0,2)),x0,x1,C);
end

% generate default features names
function FeatureNames = ConstructDefaultFeatureNames(p)
    FeatureNames = cellfun(@num2str,mat2cell(1:p,1,ones(1,p)),'UniformOutput',false);
end

% generate projection name
function sname = ConstructProjectionName(FeatureNames)
    sname = 'Projection:';
    for i=1:length(FeatureNames)
        sname = [sname, ' ', FeatureNames{i}];
    end
end

% tests which projections have features in common with the reference
function cf = HasCommonFeatures(Projections, reference)
    cf = false(1,length(Projections));
    for i=1:length(Projections)
        cf(i) = (size(intersect(Projections{i},reference),2)>0);
    end
end

% tests which projections are supersets of the reference
function superset = IsFeatureSuperset(Projections, reference)
    superset = false(1,length(Projections));
    for i=1:length(Projections)
        superset(i) = (size(setdiff(reference,Projections{i}),2)==0);
    end
end