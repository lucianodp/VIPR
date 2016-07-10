function [X] = ImputeMean(X)
%IMPUTEMEAN - Replaces missing values with column means
    for i=1:size(X,2)
        b = isnan(X(:,i));
        if (sum(~b)>0)
            X(b,i) = mean(X(~b,i));
        else
            X(b,i) = 0;
        end
        
    end
end