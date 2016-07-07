function [] = PlotClusters(X,P_sel,proj,projnames)
    if(size(X,2)<1)
        error('Nothing to plot\n');
    end
    if(size(X,2)<2)
        X = [X,X];
    end
    p = unique(P_sel);
    ColorSet=varycolor(size(p,1));
    for k=1:size(p,1)
        figure('position',[0,0,1000,600]); hold on;
        pi = proj{p(k)};
        X0 = X(P_sel==p(k),pi);
        X1 = X(P_sel~=p(k),pi);
        scatter(X1(:,1),X1(:,2),3*ones(size(X1,1),1),[0,0,0],'filled');
        scatter(X0(:,1),X0(:,2),3*ones(size(X0,1),1),ColorSet(k,:),'filled');
        xlabel(projnames{pi(1)});
        ylabel(projnames{pi(2)});
        save('temp.mat','X0','X1');
        pause;
    end
end 