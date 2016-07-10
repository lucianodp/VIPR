function [feats] = FilterFeatures(X, Y, NumF)
%FILTERFEATURES Select only the features that correlate with the output
    C = corr(X,Y);
    [~, idxs] = sort(C,'descend');
    feats = 1:size(X,2);
    feats = feats(idxs(1:NumF));
    fprintf(1, 'Number of candidate features filtered from %d to %d\n', size(X,2), length(feats));
end

