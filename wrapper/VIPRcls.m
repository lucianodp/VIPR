function [IPEclsModel] = VIPRcls(filename, P)
% Train and plot RIPR classification model
% Filename - mat file containing X, Y, Features
% P - number of informative projections to be retrieved
    load(filename);
    d = 2; % max. dimensionality of recovered projections
    K = 3; % parameter for k-NN classifiers
    [L, Proj] = ComputeKNNlossMatrix(X, Y, K, d); 
    [IPE] = IPEtrain(L,Proj,P,'greedy');
    [IPEclsModel] = IPEfromSelection(X, Y, IPE.B, d, Proj);
    IPidx = find(IPEclsModel.ProjIdx);
    IP = Proj(IPidx);
    close all;
    project_backgroup_pts = false;
    for p=1:P;
        figure('Position', [100, 500, 400, 300]); hold on;
        f1 = IP{p}(1);
        f2 = IP{p}(2);
        idx = IPE.B(:,IPidx(p)) & Y==0;
        if(project_backgroup_pts)
            scatter(X(Y==0,f1), X(Y==0,f2),'b');
        end
        scatter(X(idx,f1), X(idx,f2),'b','.');
        idx = IPE.B(:,IPidx(p)) & Y==1;
        if(project_backgroup_pts)
            scatter(X(Y==1,f1), X(Y==1,f2),'r');
        end
        scatter(X(idx,f1), X(idx,f2),'r','.');
        title(['Projection ', num2str(p)]);
        xlabel(strrep(Features(f1),'_', ' '));
        ylabel(strrep(Features(f2),'_', ' '));
    end
end