function [sumd0,sumd,Metric0,Metric2] = EvaluateModel(filename)
    res = open(filename);
    k0max = 10;
    sumd0 = zeros(1,k0max);
    Metric0 = zeros(res.p_num,k0max);
    for k0 = 1:k0max
        [kmeans_idx, kmeans_centroids, kmeans_sumd] = kmeans(res.X,k0);
        IDX0{k0} = kmeans_idx;
        C0{k0}= kmeans_centroids;
        sumd0(k0) = sum(kmeans_sumd);
        for i=1:res.p_num            
            Metric0(i,k0) = sum(ComputeDistances(res.X(:,res.proj{res.idxc_r(i,1)}),IDX0{k0}));
        end
    end
    kmax = 5;
    sumd = zeros(res.p_num,kmax);
    Metric2 = zeros(res.p_num,kmax);
    for i=1:res.p_num
        Xsubset = res.X(res.idx_r==i,res.proj{res.idxc_r(i,1)});
        Xsubsetall = res.X(res.idx_r==i,:);
        for k=1:kmax
            [kmeans_idx, kmeans_centroids, kmeans_sumd] = kmeans(Xsubset,k);
            IDX{i,k} = kmeans_idx;
            C{i,k}= kmeans_centroids;
            sumd(i,k) = sum(kmeans_sumd);
            Metric2(i,k) = sum(ComputeDistances(Xsubsetall,IDX{i,k}));
        end
    end
end

function kmeans_sumd = ComputeDistances(X,idx)
    numk = length(unique(idx));
    kmeans_sumd = zeros(1,numk);
    for i = 1:numk
        X_i = X(idx==i,:); 
        mu_i = mean(X_i);
        d = repmat(mu_i,[size(X_i,1),1])-X_i;
        kmeans_sumd(i) = sum(sqrt(sum(d.*d,2)));
    end
end