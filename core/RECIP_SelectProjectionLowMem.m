function [P_SEL,Y_hat] = RECIP_SelectProjectionLowMem(P,X,Y,X_ts)
    k=1;
    for i=1:length(P)
        Z = X(:,P{i});
        Z_ts = X_ts(:,P{i});
        idx_0 = (Y==0);
        idx_1 = (Y==1);
        [idx d0] = knnsearch(Z(idx_0,:),Z_ts,'K',k);
        d0 = d0(:,k);
        [idx d1] = knnsearch(Z(idx_1,:),Z_ts,'K',k);
        d1 = d1(:,k);
        r0 = RobustDivision(d0,d1);
        r1 = RobustDivision(d1,d0);
        r(:,i) = min(r0,r1);
        y(:,i) = (d1<=d0);
    end
    [v, idxpsel] = min(r,[],2);
    P_SEL = P(idxpsel);
    Y_hat = zeros(size(idxpsel,1),1);
    for i=1:size(idxpsel,1)
        Y_hat(i,:) = y(i,idxpsel(i));
    end
end
