function [B] = OptimizeSelectionGreedy(L, k)
%OPTIMIZESELECTIONGREEDY Compute selection function from loss using the
% greedy procedure
    B = zeros(size(L,1),size(L,2));
    Loss = ones(size(L,1),1);
    Idx = false(1,size(L,2));
    for i=1:k
        LossDecrease = max(zeros(size(L,1),size(L,2)), ...
                       repmat(Loss,1,size(L,2)) - L);
        [decrease, di] = max(sum(LossDecrease));
        Idx(di) = true;
        Loss = min(L(:,Idx),[],2);
    end
    B = (L==repmat(Loss,1,size(L,2)));
    B(:,~Idx) = zeros(size(B,1),sum(~Idx));
end