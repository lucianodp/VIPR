%% Logical function data with medium number of features (~tens/hundreds)
function [X,Y,PIcls] = GenerateData2(n,p,m,q,d,imb)
% This function generates a dataset of m features and q+1 groups of points
% Points in group i have indexes q*(i-1)+1:q*i
% Points in group i (with i=1:q) can be explained by the projection PIcls(q)
% Points q*n+1:q*n+p are uniform noise
% d - the maximum number of features 
    if(nargin<6)
        imb = 0;
    end
    X = rand(q*n+p,m);
    Y = zeros(q*n+p,1);
    PIcls = cell(0,1);
    for i=1:q
        % generate points from group i
        % select at most d features
        feat = randperm(m);
        df = 1+ceil(rand(1)*(d-1));
        PIcls{i} = feat(1:df);
        idx_i = ((i-1)*n+1:i*n);
        x1 = X(idx_i,PIcls{i}(1));
        for j=2:df
            x2 = X(idx_i,PIcls{i}(j));
            x1 = xor((x1>0.5+imb),(x2>0.5+imb));
        end
        Y(idx_i,:) = (x1>0.5);
    end
    Y(q*n+1:q*n+p,:) = (rand(p,1)>0.5);
end
