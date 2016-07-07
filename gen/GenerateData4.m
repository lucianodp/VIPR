%% Logical function data with medium number of features (~tens/hundreds)
function [X,Y,PIcls] = GenerateData4(n,p,m,q,d)
% This function generates a dataset of m features and q+1 groups of points
% Points in group i have indexes q*(i-1)+1:q*i
% Points in group i (with i=1:q) can be explained by the projection PIcls(q)
% Points q*n+1:q*n+p are uniform noise
% d - the maximum number of features 
    X = rand(q*n+p,m);
    Y = zeros(q*n+p,1);
    PIcls = cell(0,1);
    feat = randperm(m);
    if (d*q > m)
        fprintf(1, 'Increased the number of features from %d to %d to allow the creation of the requested number of groups', m, d*q);
        m = d*q;
    end
    for i=1:q
        PIcls{i} = feat(d*(i-1)+1:d*i);
        idx_i = ((i-1)*n+1:i*n);
        x0 = X(idx_i,PIcls{i}(1));
        X(idx_i,PIcls{i}(1)) = X(idx_i,PIcls{i}(1))+1;
        for j=2:d
            x_crt = X(idx_i,PIcls{i}(j));
            x0 = xor((x0>0.5),(x_crt>0.5));
            X(idx_i,PIcls{i}(j)) = X(idx_i,PIcls{i}(j))+1;
        end
        Y(idx_i,:) = (x0>0.5);
    end
    Y(q*n+1:q*n+p,:) = (rand(p,1)>0.5);
    X(q*n+1:q*n+p,:) = rand(p,m);
end