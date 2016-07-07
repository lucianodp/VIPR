function [V_Loss] = ModifyLoss_Variance(X, Loss, Proj, k)
% Function modifies the loss by adding a penalty on the entropy of the
% selection function in the neighborhood of each point
% L = Loss + \lambda * H(g(x)) = Loss + \lambda d(x,X_{g(x)})/d(x,X_\not{g(x)})
    [Target, Point_Proj_idx] = min(Loss,[],2);
    V_Loss = zeros(size(Loss,1),size(Loss,2));
    for i=1:size(Loss,1)
        for j=1:size(Loss,2)
            [idx, D] = knnsearch(X(:,Proj{j}),X(i,Proj{j}),'K',k);
            V_Loss(i,j) = var(Loss(idx,j));
        end
    end
end