function [H_Loss] = ModifyLoss_Entropy(X, Loss, Proj, k)
% Function modifies the loss by adding a penalty on the entropy of the
% selection function in the neighborhood of each point
% L = Loss + \lambda * H(g(x)) = Loss + \lambda d(x,X_{g(x)})/d(x,X_\not{g(x)})
    [Target, Point_Proj_idx] = min(Loss,[],2);
    H_Loss = zeros(size(Loss,1),size(Loss,2));
    for j=1:size(Loss,2)
        for i=1:size(Loss,1)
            k1 = k + double(Point_Proj_idx(i) == j);
            k0 = k + double(Point_Proj_idx(i) ~= j);
            [idx, D1] = knnsearch(X(Point_Proj_idx==j,Proj{j}),X(i,Proj{j}), 'K', k1);
            [idx, D0] = knnsearch(X(Point_Proj_idx~=j,Proj{j}),X(i,Proj{j}), 'K', k0);
            if (length(D1)<k1)
                if (length(D0)<k0)
                    H_Loss(i,j) = 1;
                else
                    H_Loss(i,j) = inf;
                end
            else
                if (length(D0)<k0)
                    H_Loss(i,j) = 0;
                else
                    H_Loss(i,j) = D1(k1)/D0(k0);
                end
            end
        end
    end
end