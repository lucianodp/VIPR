function [PiFiltered] = FilterProjections(X, Y, Pi, NumP)
%FILTERPROJECTIONS = Returns the most informative NumP projections
% in the set, according to correlation of features to output
    if NumP > length(Pi)
        PiFiltered = Pi;
    else    
        [X] = ImputeMean(X);
        [Y] = ImputeMean(Y);
        C = corr(X,Y);
        C(isnan(C)) = 0;
        AvgC = zeros(length(Pi), 1);
        for i=1:length(Pi)
            AvgC(i) = mean(C(Pi{i,1}));
        end
        [~, idxs] = sort(AvgC,'descend');
        PiFiltered = Pi(idxs(1:NumP));
        fprintf(1, 'Number of candidate projections filtered from %d to %d\n',length(Pi), length(PiFiltered));
    end
end