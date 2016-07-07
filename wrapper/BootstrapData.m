function [Xboot, Yboot, Idxs] = BootstrapData(X, Y, numrep, perc)
%BOOTSTRAPDATA Returns a bootstrap sample of the specified data 
% The outputs Xboot, Yboot are cell arrays containing numrep
% elements, with each element representing one bootstraped sample
    Xboot = cell(1, numrep);
    Yboot = cell(1, numrep);
    Idxs = cell(1, numrep);
    n = size(X,1);
    m = ceil(n*perc);
    for i=1:numrep
        idx = randperm(n);
        idx = idx(1:m);
        Xboot{i} = X(idx,:);
        Yboot{i} = Y(idx,:);
        Idxs{i} = idx;
    end
end

