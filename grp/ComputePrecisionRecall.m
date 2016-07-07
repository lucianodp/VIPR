function [Precision, Recall] = ComputePrecisionRecall(P0,P1)
% Returns the precision and recall of the projection set P0 w.r.t P1
    Identity = zeros(length(P0),length(P1));
    for i=1:length(P0)
        for j=1:length(P1)
            Identity(i,j) = double(EqualSets(P0{i},P1{j}));
        end
    end
    Precision = sum(sum(Identity)>0)/length(P1);
    Recall = sum(sum(Identity,2)>0)/length(P0);
end

function b = EqualSets(P0,P1)
    D01 = setdiff(P0,P1);
    D10 = setdiff(P1,P0);
    b = ((size(D01,2)==0) & size(D10,2)==0);
end