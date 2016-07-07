function [L] = ComputeRegSqLossEst(X,Y,K)
%COMPUTEREGSQLOSSEST - compute mean square error estimtor
    L = local_sq_loss_est(X,1:size(X,2),K,Y);
end