function [L, Proj] = ComputeKNNlossMatrix(X,Y,K,d)
%COMPUTEKNNLOSSMATRIX Summary of this function goes here
%   Detailed explanation goes here
    n = size(X,2);
    m = 1;
    for j=d:d
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            L(:,m) = ComputeKNNloss(X(:,pi),Y,K);
            Proj{m,1} = pi;
            m = m+1;
        end
    end
end