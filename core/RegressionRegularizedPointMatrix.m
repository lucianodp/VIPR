function [b] = RegressionRegularizedPointMatrix(X,Y,lambda1,lambda2,diffpen)
    % argmin_beta sum(|Y-sum(X.*beta),2)|^2) + lambda*sum_ij(|b(:,i)-b(:,j)|)
    % constraint: each line must have only one non-zero element
    m = size(X,1);
    n = size(X,2);
    cvx_begin
        variable b(m,n);
        variable R(m,1);
        minimize (sum(R.*R) + lambda1*sum(norms(b,1,1))+ lambda2*(norms(b*diffpen,1,1)));        
        subject to
            R == sum(X.*b,2)-Y;
            sum(b,2) == ones(m,1);
    cvx_end
end