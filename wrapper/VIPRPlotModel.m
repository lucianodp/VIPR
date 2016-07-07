function [FigHandles] = VIPRPlotModel(VIPRmodel, use_varycolor)
    if (nargin < 2)
        use_varycolor = false;
    end
    FigHandles = cell(1,length(VIPRmodel.Submodel));
    for i=1:length(VIPRmodel.Submodel)
        if sum(VIPRmodel.Submodel{i}.PointsIdx)==0
            continue
        end
        features = VIPRmodel.Submodel{i}.ProjDim;
        Xsub = VIPRmodel.Submodel{i}.Xsub;
        Ysub = VIPRmodel.Submodel{i}.Ysub;
        if(length(features)<2)
            features = [features, features];
            Xsub = [Xsub, Xsub];
        end
        FigHandles{i} = figure; hold on;
        if (use_varycolor)
            ylist = sort(unique(Ysub));
            ColorSet = varycolor(length(ylist)+1);
            ScatterPlotColor = zeros(size(Xsub,1),3);
            for j = 1:length(ylist)
                ScatterPlotColor(Ysub==ylist(j),:) = repmat(ColorSet(j,:),sum(Ysub==ylist(j)),1);
            end
            if (length(features)<3)
                %scatter(Xsub(:,1),Xsub(:,2),'CData',ScatterPlotColor);
                plot3k([Xsub(:,[1,2]),Ysub],'ColorData',ScatterPlotColor,'ColorRange',[min(VIPRmodel.Y) max(VIPRmodel.Y)],'Marker',{'.' 30});
            else
                plot3k(Xsub(:,[1,2,3]),'ColorData',ScatterPlotColor,'ColorRange',[min(VIPRmodel.Y) max(VIPRmodel.Y)],'Marker',{'.' 30});
            end
        else
            if (length(features)<3)
                plot3k([Xsub(:,[1,2]),Ysub],'ColorData',Ysub,'ColorRange',[min(VIPRmodel.Y) max(VIPRmodel.Y)],'Marker',{'.' 30});
            else
                plot3k(Xsub(:,[1,2,3]),'ColorData',Ysub,'ColorRange',[min(VIPRmodel.Y) max(VIPRmodel.Y)],'Marker',{'.' 30});
            end
        end
        set(gca,'FontSize',16);
        if (isfield(VIPRmodel.Submodel{i},'FeatureNames'))
            xlabel(strrep(VIPRmodel.Submodel{i}.FeatureNames{1},'_',' '));
            ylabel(strrep(VIPRmodel.Submodel{i}.FeatureNames{2},'_',' '));
            if (length(VIPRmodel.Submodel{i}.FeatureNames)>2)
                zlabel(strrep(VIPRmodel.Submodel{i}.FeatureNames{3},'_',' '));
            else
                zlabel('Output');
                zlim([min(VIPRmodel.Y) max(VIPRmodel.Y)]);
            end
        end
    end
end

