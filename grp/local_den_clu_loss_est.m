function [L] = local_den_clu_loss_est(X,pi,k)
    alpha = 0.99;
    X = Normalize(X);
    U = rand(size(X,1),length(pi));
    [idx_x, d_x] = knnsearch(X(:,pi),X(:,pi),'K',k+1);
    d_x = d_x(:,k+1);
    [idx_x, d_u] = knnsearch(U,X(:,pi),'K',k);
    d_u = d_u(:,k);
    L = RobustDivision(d_x,d_u);
    L = L.^(length(pi)*(1-alpha));
end

function Xn = Normalize(X)
    Xn = (X-repmat(min(X),size(X,1),1))./repmat(max(X)-min(X),size(X,1),1);
end