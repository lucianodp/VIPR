%% Logical function data with medium number of features (~tens/hundreds)
% The outputs are not logically correlated
% The ao flag specifies whether outputs may share relevant variables
function [X,Y,PIcls] = GenerateMultiOutputNonCorrelatedData(n,p,m,q,d,T,ao,imb)
% This function generates a dataset of m features and q+1 groups of points
% Points in group i have indexes n*(i-1)+1:n*i
% Points in group i (with i=1:q) can be explained by the projection PIcls(q)
% Points q*n+1:q*n+p are uniform noise
% n - number of points per group
% p - number of noisy points
% m - number of features
% q - number of groups
% d - maximum number of features 
% T - number of outputs
% ao - allow overlap
    if(nargin<6)
        T = 1;
    end
    if(nargin<7)
        ao = 1;
    end
    if(nargin<8)
        imb = 0;
    end
    X = rand(q*n+p,m);
    Y = zeros(q*n+p,T);
    PIcls = cell(0,0);
    features_used = zeros(0,1);
    insufficient_features = 0;
    for t=1:T
        for i=1:q
            % generate points from group i
            % select at most d features
            if(~ao)
                % remove features that were used for previous tasks
                feat = setdiff(1:m,features_used);
            else
                feat = 1:m;
            end
            % if no features left, just use everything
            if(size(feat,2)<d)
                insufficient_features = 1;
                feat = 1:m;
            end
            feat = feat(randperm(size(feat,2)));
            df = 1+ceil(rand(1)*(d-1));
            PIcls{i,t} = feat(1:df);
            idx_i = ((i-1)*n+1:i*n);
            x1 = X(idx_i,PIcls{i,t}(1));
            X(idx_i,PIcls{i,t}(1)) = X(idx_i,PIcls{i,t}(1))+1;
            for j=2:df
                x2 = X(idx_i,PIcls{i,t}(j));
                x1 = xor((x1>0.5+imb),(x2>0.5+imb));
                X(idx_i,PIcls{i,t}(j)) = X(idx_i,PIcls{i,t}(j))+1;
            end
            Y(idx_i,t) = (x1>0.5);
        end
        for i=1:q
            features_used = union(features_used,PIcls{i,t});
        end
    end
    if(insufficient_features)
        fprintf(1,'Insufficient features to generate disjoint outputs\n');
    end
    Y(q*n+1:q*n+p,:) = (rand(p,T)>0.5);
    X(q*n+1:q*n+p,:) = 2*rand(p,m);
end