function [B0, B1] = RegressDoubleExplanation(L0, L1, lambda, lambda1)
% Inputs:
    % L0 - the loss matrix for the null hypothesis (the most likely label)
    % L1 - the loss matrix for the next most likely label
    % lambda - the regularizer for the number of informative projections
% Outputs:
    % B0 - maps each point to its assigned projection
    % B1 - maps each point to its contradictory projection
    n = size(L0,1);
    d_star = size(L0,2);
    if (size(L1,1) ~= n || size(L1,2) ~= d_star)
        error('L0 and L1 must be of the same dimensionality');
    end
    L0_star = min(L0,[],2);
    L1_star = min(L1,[],2);
    alt = double(L1_star < L0_star);
    cvx_begin
        variable B0(n,d_star);
        variable B1(n,d_star);
        variable R0(n,1);
        variable R1(n,1);
        % note: norms(X,2,1) returns a vector with the l2 norms of the columns of X
        % note: norms(X,1,1) returns a vector with the l1 norms of the columns of X
        %minimize (sum(R0.*R0) + sum(R1.*R1) + lambda*sum(norms([B0;B1],2,1)) + lambda1*sum(norms(double(L1<=L0).*B1,1,1)));
        %minimize (sum(R0.*R0) + sum(R1.*R1) + lambda*sum(norms(B0,2,1)) + lambda*sum(norms(B1,2,1)) + lambda1*sum(norms(B1,1,1)));
        minimize (sum(R0.*R0) + sum(R1.*R1) + lambda*sum(norms(B0,2,1)) + lambda*sum(norms(B1,2,1)) + lambda1*sum(norms(double(L1<=L0).*B1,1,1)));
        subject to
            R0 == sum(L0.*B0,2)-L0_star;
            R1 == sum(L1.*B1,2)-L1_star;
            sum(B0,2) == ones(n,1);
            B0>=0;
            B1>=0;
    cvx_end
end