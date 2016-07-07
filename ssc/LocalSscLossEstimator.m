function [L, proj] = LocalSscLossEstimator(X,Y,d,k)
    idx_u = (Y==-1);
    [H_labeled, proj] = LocalEntropyEstimator(X(~idx_u,:),Y(~idx_u),d,k);
    L = zeros(size(X,1), length(proj));
    if(sum(idx_u)>0)
        Y_fake = Y;
        Y_fake(idx_u,:) = ones(sum(idx_u),1); % assume unl. are +
        [H_u_plus, proj] = LocalEntropyEstimator(X,Y_fake,d,k);
        H_u_plus = H_u_plus(idx_u,:);
        Y_fake(idx_u,:) = zeros(sum(idx_u),1); % assume unl. are -
        [H_u_minus, proj] = LocalEntropyEstimator(X,Y_fake,d,k);
        H_u_minus = H_u_minus(idx_u,:);
        L(idx_u,:) = min(H_u_plus,H_u_minus);
    end
    L(~idx_u,:) = H_labeled;
end