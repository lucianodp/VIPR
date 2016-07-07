function [figHandles] = PlotVIPRModel(VIPRModel,FeatureNames)
    color = ['y','b','r','g','m','c'];
    X = VIPRModel.TrainData;
    figHandles = cell(size(VIPRModel.Submodel,1),1);
    for i=1:size(VIPRModel.Submodel,1)
        features = VIPRModel.Submodel{i}.ProjDim;
        if(length(features)<2)
            features = [features, features];
        end
        Xsub = X(VIPRModel.Submodel{i}.PointsIdx, features);
        Clust = VIPRModel.Submodel{i}.ClusteringResult;
        figHandles{i} = figure; hold on;
        if(length(features)==2)
            scatter(X(:,features(1)),X(:,features(2)),'.black');
            for j=1:size(Clust.ClusterCenters,1)
                xsub = Xsub(Clust.ClusterIdx == j, :);
                if(size(xsub,1)>0)
                    scatter(xsub(:,1),xsub(:,2),['.',color(mod(j,length(color))+1)]);
                end
            end
            %scatter(KmeansModel.Centers(features(1)),KmeansModel.Centers(features(2)),'*red');
        else
            features = features(1:3);
            colrange = [0,size(Clust.ClusterCenters,1)+1];
            Xsub_not = X(~VIPRModel.Submodel{i}.PointsIdx, features);
            Xsub = X(VIPRModel.Submodel{i}.PointsIdx, features);
            if(size(Xsub_not,1)>0)
                plot3k(Xsub_not,'ColorData',zeros(size(Xsub_not,1),1),'ColorRange',colrange);
            end
            for j=1:size(Clust.ClusterCenters,1)
                xsub = Xsub(Clust.ClusterIdx == j, :);
                if(size(xsub,1)>0)
                    plot3k(xsub,'ColorData',j*ones(size(xsub,1),1),'ColorRange',colrange);
                end
            end
            if (nargin < 2)
                zlabel(['Feature ',num2str(features(3))]);
            else
                zlabel(FeatureNames{features(3)});
            end
        end
        if (nargin < 2)
            xlabel(['Feature ',num2str(features(1))]);
            ylabel(['Feature ',num2str(features(2))]);
        else
            xlabel(FeatureNames{features(1)});
            ylabel(FeatureNames{features(2)});
        end
    end
end