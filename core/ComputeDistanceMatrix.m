% Distances from each x \in X to each x0 \in X0 on all coordinates
function D = ComputeDistanceMatrix(X,X0)
    XR(1,:,:) = X';
    XR = repmat(XR,[size(X0,1),1,1]);
    X0R = repmat(X0,[1,1,size(X,1)]);
    D = XR-X0R;
    D = D.*D;
end