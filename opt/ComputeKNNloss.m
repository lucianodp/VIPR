function [L,Y_hat] = ComputeKNNloss(X, Y, K)
%COMPUTEKNNLOSS The function computes the loss matrix for knn classifiers
%   X - feature vector for training data
%   Y - binary (0,1) labels for training data
%   K - number of neighbors to be considered
    [idx, D] = knnsearch(X,X,'K',K+1); % find K+1 nearest neighbors
    D = D(:,2:end); % exclude the nearest neighbor (the point itself)
    idx = idx(:,2:end);
    idx_rs = reshape(idx,[numel(idx),1]);
    Yn_rs = Y(idx_rs,:);
    Yn = reshape(Yn_rs,size(idx,1),size(idx,2));
    Yn = 2*Yn-1;
    W = ones(size(D,1),size(D,2))./(D+1);
    Z = sum(Yn.*W,2)./sum(W,2);
    Y_hat = double(Z>0);
    L = abs((2*Y-1)-Z)/2;
end