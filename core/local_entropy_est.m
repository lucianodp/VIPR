function [ E ] = local_entropy_est(X,subset,k,labels)

E = zeros(size(X,1),1);
H = zeros(size(X,1),1);
Z = X(:,subset);
uniq_labels = unique(labels);
L= max(size(uniq_labels));

for l = 1:L
    
    idx_l = labels == uniq_labels(l);

    [idx d1] = knnsearch(Z(idx_l,:),Z(idx_l,:),'K',k+1);
    [idx d2] = knnsearch(Z(~idx_l,:),Z(idx_l,:),'K',k);

    if (size(d1,2) < k+1)
        d1 = inf*ones(sum(idx_l),1);
    else
        d1 = d1(:,k+1);
    end

    if (size(d2,2) < k)
        d2 = inf*ones(sum(idx_l),1);
    else
        d2 = d2(:,k);
    end

    E1 = (d1 ./ d2).^(max(size(subset))/2);
    %E1 = (d1 ./ d2).^max(size(subset));
    
    E2 = zeros(size(E1,1),size(E1,2));
    E2(d2~=0) = E1(d2~=0);
    E2(d2==0) = 2*(d1(d2==0)~=0) + (d1(d2==0)==0);

    E(idx_l) = E2;

    alpha = 0.5;
    n = sum(idx_l);
    m = sum(~idx_l);
    B_k_alpha = (gamma(k).^2)/(gamma(k-alpha+1)*gamma(k+alpha-1));
    %E(idx_l) = B_k_alpha*((n-1)/m*E(idx_l)).^(1-alpha);

end
        

end