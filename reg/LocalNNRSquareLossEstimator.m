function [L, proj] = LocalNNRSquareLossEstimator(X,Y,d,k)
    n = size(X,2);
    m = 1;
    for j=1:d
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            L(:,m) = local_sq_loss_est(X,pi,k,Y);
            proj{m,1} = pi;
            m = m+1;
        end
    end
end