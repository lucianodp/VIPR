function [Y_hat] = RECIP_CombineProjectionsVoting(P,X,Y,X_ts)
    % P - the projections learned by RECIP
    % (X,Y) - the training data used to obtain P
    % this function combines the labels 
    idx0 = (Y==0);
    idx1 = (Y==1);
    D0 = ComputeDistanceMatrix(X_ts,X(idx0,:));
    D1 = ComputeDistanceMatrix(X_ts,X(idx1,:));
    for i=1:length(P)
        d0 = sqrt(sum(D0(:,P{i},:),2));
        nn0 = min(d0,[],1);
        d1 = sqrt(sum(D1(:,P{i},:),2));
        nn1 = min(d1,[],1);
        r0(:,i,:) = nn0./nn1;
        r1(:,i,:) = nn1./nn0;
        label1(:,i) = (r1(:,i,:)<r0(:,i,:));
    end
    Y_hat = (mean(label1,2)>=0.5);
end