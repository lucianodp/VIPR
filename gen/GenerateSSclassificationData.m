function [X,Y,Yt,P] = GenerateSSclassificationData(n,r,q,m,d)
%GENERATESSCDATA generates data for semi-supervised learning on
% low-dimensional subspaces of the feature space
% The dataset has m features and q+1 groups of points
%   n - number of samples per group
%   r - number of ungrouped samples
%   q - number of low-dimensional informative projections
%   m - number of features
%   d - max dimensionality of embedding
% output: X (the features), Yt (labels) Y(-1 for unlabeled), P (projections)
    P = cell(q,1);
    X = rand(q*n+r,m);
    Yt = zeros(q*n+r,1);
    q = min(q,floor(m/d));
    feat = randperm(m);
    for i=1:q
        sigma = 0.01*(0.75*eye(d)+0.25*ones(d));
        P{i} = feat(1:d);
        feat = setdiff(feat,P{i});
        idx_i = ((i-1)*n+1:i*n);
        mu_0 = zeros(d,1);
        idx_i_0 = idx_i(1:2:length(idx_i));
        X(idx_i_0,P{i}) = mvnrnd(mu_0,sigma,length(idx_i_0));
        Yt(idx_i_0,:) = zeros(length(idx_i_0),1);
        mu_1 = ones(d,1);
        idx_i_1 = idx_i(2:2:length(idx_i));
        X(idx_i_1,P{i}) = mvnrnd(mu_1,sigma,length(idx_i_1));
        Yt(idx_i_1,:) = ones(length(idx_i_0),1);
    end
    Yt(q*n+1:q*n+r,:) = (rand(r,1)>0.5);
    X(q*n+1:q*n+r,:) = 2*rand(r,m)-0.5;
    Y = Yt;
    %Y(1:3:q*n+r,:) = -1; % every 3rd point is unlabeled
end