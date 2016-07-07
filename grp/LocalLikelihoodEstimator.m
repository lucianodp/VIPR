function [L,proj] = LocalLikelihoodEstimator(X,d)
% This function returns the -log(likelihood) of each point in the dataset
% by considering its k neighbors on a series of projections of size <= k
    n = size(X,2);
    m = 1;
    L = zeros(size(X,1),0);
    proj = cell(0,0);
    for j=1:d
        Pi = combnk(1:n,j);
        for i = 1:size(Pi,1)
            proj{m,1} = Pi(i,:);
            X_pi = X(:,proj{m,1});
            %for l=1:size(X_pi,1)
            %    L(l,m) = -log(KDE_based_Likelihood(X_pi,X_pi(l,:),k));
            %end
            L(:,m) = -log(KDE_based_Likelihood(X_pi,X_pi));
            m = m+1;
        end
    end
end

function [L] = KDE_based_Likelihood(X,x)
    % get nearest k neighbors in X of x
    %[idx,dist] = knnsearch(X,x,'K',k);
    %X = X(idx,:);
    % estimate density on a grid
    if(size(X,2)==1)
        [bandwidth,density,xmesh,cdf]=kde(X);
        Xmesh = xmesh';
        Dmesh = density;
    end
    if(size(X,2)==2)
        [bandwidth,density,X0,Y0]=kde2d(X);
        Xmesh = [reshape(X0,numel(X0),1),reshape(Y0,numel(Y0),1)];
        Dmesh = reshape(density,numel(density),1);
    end
    % find point nearest on the mesh to x
    [idx,dist] = knnsearch(Xmesh,x,'K',1);
    %save('temp.mat','Xmesh','x','density','Dmesh');
    L = Dmesh(idx);
    if(size(X,2)>2)
        error('Clustering RECIP only works for up to 2 dimensional projections\n');
    end
end