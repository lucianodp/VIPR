%% Point-specific RECIP
function [P,b,L,proj,idxP] = RECIP_SSC(X,Y,d,k)
    % (X,Y) - features and label
    % d - maximum dimensionality of considered projections
    [L, proj] = LocalSscLossEstimator(X,Y,d,k);
    [O, O_idx] = min(L,[],2);
    % recip parameters (we should learn these somehow but fixed for now)
    lambda1 = 0.01;
    lambda2 = 0.1;
    iter = 2;
    min_support = 0.01;
    % run iterative regression
    [b] = RegressionIteratePointMatrix(L,O,lambda1,lambda2,iter);
    b0 = full(b);
    b1 = double(b0==repmat(max(b0,[],2),1,size(L,2)));
    B1 = sum(b1)';
    thresh = min_support*size(X,1);
    idxP = (B1>thresh);
    P = proj(idxP);
end