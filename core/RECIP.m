%% Point-specific RECIP
function [P,b,H,proj,idxP] = RECIP(X,Y,d)
    % (X,Y) - features and label
    % d - maximum dimensionality of considered projections
    [H, proj] = LocalEntropyEstimator(X,Y,d,1);
    [O, O_idx] = min(H,[],2);
    % recip parameters (we should learn these somehow but fixed for now)
    lambda1 = 0.1;
    lambda2 = 1;
    iter = 2;
    min_support = 0.01;
    % run iterative regression
    [b] = RegressionIteratePointMatrix(H,O,lambda1,lambda2,iter);
    b0 = full(b);
    b1 = double(b0==repmat(max(b0,[],2),1,size(H,2)));
    B1 = sum(b1)';
    thresh = min_support*size(X,1);
    idxP = (B1>thresh);
    P = proj(idxP);
end