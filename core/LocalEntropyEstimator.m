function [H, proj] = LocalEntropyEstimator(X,Y,d,k)
    n = size(X,2);
    m = 1;
    for j=d:d
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            H(:,m) = local_entropy_est(X,pi,k,Y);
            proj{m,1} = pi;
            m = m+1;
        end
    end
end