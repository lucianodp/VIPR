function [X,Model] = GenerateClusteringData(n,r,m,q,d,k,M,S)
%GENERATECLUSTERINGDATA generates data that can be clustered on
% low-dimensional subspaces of the feature space
% The dataset has m features and q+1 groups of points
%   n - number of samples per group
%   r - number of ungrouped samples
%   q - number of low-dimensional informative projections
%   m - number of features
%   d - max dimensionality of embedding
%   k - number of clusters per low-dimensional 
% Points in group i where 1<=i<=q have indexes q*(i-1)+1:q*i
% Points in group q+1 are uniform noise; they have indexes q*n+1:q*n+p 
    Model = struct;
    Model.Projections = cell(q,1);
    Model.Clusters = cell(q,k);
    %X = (q+1)*rand(q*n+r,m);
    X = M*q*rand(q*n+r,m);
    for i=1:q
        % select at most d features
        feat = randperm(m);
        df = 1+ceil(rand(1)*(d-1));
        Model.Projections{i} = feat(1:df);
        % generate points from group i
        %idx_i = q + ((i-1)*n+1:i*n);
        idx_i = ((i-1)*n+1:i*n);
        for j=1:k
            idx_i_j = idx_i(j:k:length(idx_i));
            % generate gaussians with some non-diagonal covariance
            mu = q*(i/q)*(j/k)*ones(df,1);
            sigma = (S/k)*(0.75*eye(df)+0.25*ones(df));
            X(idx_i_j,Model.Projections{i}) = mvnrnd(mu,sigma,length(idx_i_j));
            Model.Clusters{i,j} = struct;
            Model.Clusters{i,j}.mu = mu;
            Model.Clusters{i,j}.sigma = sigma;
            Model.Clusters{i,j}.index = idx_i_j;
        end
    end
end