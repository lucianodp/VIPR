function [InfoGain, InfoGainCache, InfoGain0, InfoGain1] = ComputeInfoGain(X, Y, Xu, d, InfoGainCache)
    if (nargin<5)
        InfoGainCache = MakeInfoGainCache(X, Y, Xu, d);
    end
    InfoGain = zeros(size(Xu,1),1);
    InfoGain0 = zeros(size(Xu,1),1);
    InfoGain1 = zeros(size(Xu,1),1);
    for i=1:size(Xu,1)
        H0 = InfoGainCache.H;
        H1 = InfoGainCache.H;
        idx_i_is_nn = InfoGainCache.Idx_nn_u==i;
        % assume point has label 0
        for j=1:size(Xu,1)
            idx_proj = find(idx_i_is_nn(j,:) & InfoGainCache.Dnn_u(j,:)<InfoGainCache.Dnn_0(j,:));
            r0 = RobustDivision(InfoGainCache.Dnn_u(j,idx_proj),InfoGainCache.Dnn_1(j,idx_proj));
            r1 = RobustDivision(InfoGainCache.Dnn_1(j,idx_proj),InfoGainCache.Dnn_0(j,idx_proj));
            H0(j, idx_proj) = EntropyFromRatio(min(r0, r1), InfoGainCache.ProjDim(idx_proj));
        end
        % assume point has label 1
        for j=1:size(Xu,1)
            idx_proj = find(idx_i_is_nn(j,:) & InfoGainCache.Dnn_u(j,:)<InfoGainCache.Dnn_1(j,:));
            r0 = RobustDivision(InfoGainCache.Dnn_u(j,idx_proj),InfoGainCache.Dnn_0(j,idx_proj));
            r1 = RobustDivision(InfoGainCache.Dnn_0(j,idx_proj),InfoGainCache.Dnn_u(j,idx_proj));
            H1(j, idx_proj) = EntropyFromRatio(min(r0, r1), InfoGainCache.ProjDim(idx_proj));
        end
        H = (H0+H1)/2;
        InfoGain(i) = sum(sum(InfoGainCache.H-H));
        InfoGain0(i) = sum(sum(InfoGainCache.H-H0));
        InfoGain1(i) = sum(sum(InfoGainCache.H-H1));
    end
end

function h = EntropyFromRatio(r,dim)
    h = r.^(repmat(dim,size(r,1),1)/2);
    % alpha = 0.5;
    % B_k_alpha = (gamma(k).^2)/(gamma(k-alpha+1)*gamma(k+alpha-1));
    % h = B_k_alpha*((n-1)/m*h).^(1-alpha);
end

% Build distance matrix
function InfoGainCache = MakeInfoGainCache(X, Y, Xu, d)
    k = 1;
    m = 1;
    for j=1:d
        Pi = combnk(1:size(X,2),j);
        for i=1:size(Pi,1)
            pi = Pi(i,:);
            proj{m,1} = pi;
            projdim(1,m) = length(pi);
            [idx, dist] = knnsearch(X(Y==0,pi), Xu(:,pi),'K',k);
            InfoGainCache.Dnn_0(:,m) = dist(:,k);
            [idx, dist] = knnsearch(X(Y==1,pi), Xu(:,pi),'K',k);
            InfoGainCache.Dnn_1(:,m) = dist(:,k);
            if (size(X,1)>=k+1)
                [idx, dist] = knnsearch(Xu(:,pi),Xu(:,pi),'K',k+1);
                InfoGainCache.Dnn_u(:,m) = dist(:,k+1);
                InfoGainCache.Idx_nn_u(:,m) = idx(:,k+1);
            else
                InfoGainCache.Dnn_u(:,m) = 0;
                InfoGainCache.Idx_nn_u(:,m) = 1;
            end
            m = m+1;
        end
    end
    H0 = RobustDivision(InfoGainCache.Dnn_0, InfoGainCache.Dnn_1);
    H1 = RobustDivision(InfoGainCache.Dnn_1, InfoGainCache.Dnn_0);
    InfoGainCache.H = EntropyFromRatio(min(H0,H1), projdim);
    InfoGainCache.Projections = proj;
    InfoGainCache.ProjDim = projdim;
    InfoGainCache.K = k;
end