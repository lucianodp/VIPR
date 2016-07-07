function [L, proj] = LocalDenClusteringLoss(X,d,k)
    n = size(X,2);
    m = 1;
    for j=2:d
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            L(:,m) = local_den_clu_loss_est(X,pi,k);
            proj{m,1} = pi;
            m = m+1;
        end
    end
end