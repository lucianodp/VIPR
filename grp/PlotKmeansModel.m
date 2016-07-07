function [figHandles] = PlotKmeansModel(KmeansModel, Projections)
    color = ['y','b','r','g','m','c'];
    X = KmeansModel.TrainData;
    figHandles = cell(size(Projections,1),1);
    for i=1:size(Projections,1)
        features = Projections{i};
        if(length(features)<2)
            features = [features, features];
        end
        figHandles{i} = figure; hold on;
        
        if(length(features)==2)
            scatter(X(:,features(1)),X(:,features(2)),'.black');
            for j=1:size(KmeansModel.Centers,1)
                idx = (KmeansModel.Idx == j);
                xsub = X(idx,features);
                if(size(xsub,1)>0)
                    scatter(xsub(:,1),xsub(:,2),['.',color(mod(j,length(color))+1)]);
                end
            end
            %scatter(KmeansModel.Centers(features(1)),KmeansModel.Centers(features(2)),'*red');
        else
            features = features(1:3);
            colrange = [0,size(KmeansModel.Centers,1)+1];
            index = 1:size(X,1);
            for j=1:size(KmeansModel.Centers,1)
                idx = (KmeansModel.Idx == j);
                index(idx) = 0;
            end
            if(sum(index)>0)
                plot3k(X(index,features),'ColorData',zeros(length(index),1),'ColorRange',colrange);
            end
            for j=1:size(KmeansModel.Centers,1)
                idx = (KmeansModel.Idx == j);
                xsub = X(idx,features);
                if(size(xsub,1)>0)
                    plot3k(xsub,'ColorData',j*ones(size(xsub,1),1),'ColorRange',colrange);
                end
            end
            zlabel(['Feature ',num2str(features(3))]);
        end
        xlabel(['Feature ',num2str(features(1))]);
        ylabel(['Feature ',num2str(features(2))]);
    end
end