function [L0, L1, Projections] = DoubleExplanationLoss(X,Y,d,k)
    n = size(X,2);
    m = 1;
    for j=1:d
        Pi = combnk(1:n,j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            [L0(:,m), L1(:,m)] = local_entropy_double_est(X,pi,k,Y);
            proj{m,1} = pi;
            m = m+1;
        end
    end
    Projections = proj;
end

function [H0,H1] = local_entropy_double_est(X,subset,k,labels)

    H0 = zeros(size(X,1),1);
    H1 = zeros(size(X,1),1);
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
        E2 = zeros(size(E1,1),size(E1,2));
        E2(d2~=0) = E1(d2~=0);
        E2(d2==0) = 2*(d1(d2==0)~=0) + (d1(d2==0)==0);
        H0(idx_l) = E2;

        E1 = (d2 ./ d1).^(max(size(subset))/2);
        E2 = zeros(size(E1,1),size(E1,2));
        E2(d1~=0) = E1(d1~=0);
        E2(d1==0) = 2*(d2(d1==0)~=0) + (d2(d1==0)==0);
        H1(idx_l) = E2;
    end
end