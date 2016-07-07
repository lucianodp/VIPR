function [P_SEL,Y_hat, idxpsel] = RECIP_SelectProjection(P,X,Y,X_ts)
    % P - the projections learned by RECIP
    % (X,Y) - the training data used to obtain P
    idx0 = (Y==0);
    idx1 = (Y==1);
    D0 = ComputeDistanceMatrix(X_ts,X(idx0,:));
    D1 = ComputeDistanceMatrix(X_ts,X(idx1,:));
    for i=1:length(P)
        d0 = sqrt(sum(D0(:,P{i},:),2));
        nn0 = min(d0,[],1);
        d1 = sqrt(sum(D1(:,P{i},:),2));
        nn1 = min(d1,[],1);
        r0(:,i,:) = RobustDivision(nn0,nn1);
        r1(:,i,:) = RobustDivision(nn1,nn0);
    end
    [r0sel, pidx0sel] = min(r0,[],2);
    [r1sel, pidx1sel] = min(r1,[],2);
    predq = min(r0sel,r1sel);
    Y_hat = (r1sel==predq);
    idxpsel((r0sel==predq)) = pidx0sel(r0sel==predq);
    idxpsel((r1sel==predq)) = pidx1sel(r1sel==predq);
    P_SEL = P(idxpsel);
end