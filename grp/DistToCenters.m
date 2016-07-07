function D = DistToCenters(x,centers)
    d = centers-repmat(x,[size(centers,1),1]);
    D = sqrt(sum(d.*d,2));
end