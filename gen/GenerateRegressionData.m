function [X,Y,Model] = GenerateRegressionData(n,r,m,q,d)
%GENERATECLUSTERINGDATA generates data that can be clustered on
% low-dimensional subspaces of the feature space
% The dataset has m features and q+1 groups of points
%   n - number of samples per group
%   r - number of ungrouped samples
%   q - number of low-dimensional informative projections
%   m - number of features
%   d - max dimensionality of embedding
% Points in group i where 1<=i<=q have indexes q*(i-1)+1:q*i
% Points in group q+1 are uniform noise; they have indexes q*n+1:q*n+p 
    Model = struct;
    Model.Projections = cell(q,1);
    Model.W = cell(q,1);
    X = rand(q*n+r,m);
    Y = rand(q*n+r,1);
    for i=1:q
        % select at most d features
        feat = randperm(m);
        df = 1+ceil(rand(1)*(d-1));
        Model.Projections{i} = feat(1:df);
        % generate points from group i
        idx_i = ((i-1)*n+1:i*n);
        w = rand(df,1);
        X(idx_i,Model.Projections{i}) = ones(n,df) + X(idx_i,Model.Projections{i});
        Y(idx_i) = X(idx_i,Model.Projections{i})*w;
        Model.W{i} = w;
    end
    X(q*n+1:q*n+r,:) = max(max(X))*rand(r,m);
    Y(q*n+1:q*n+r) = max(Y)*rand(r,1);
    Y = Y + normrnd(0,0.01,size(Y,1),1);
end