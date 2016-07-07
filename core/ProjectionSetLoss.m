%% Function that compares sets of projections
function [precision, recall] = ProjectionSetLoss(P0, P)
% P0 - the true set of projections
% P  - the recovered set of projections
    relevance = zeros(length(P),1);
    retrieved = zeros(length(P0),1);
    for i=1:length(P0)
        p0 = P0{i};
        c0 = length(unique(p0));
        for j=1:length(P)
            p = P{j};
            c = length(unique(p));
            ci = length(intersect(p0,p));
            if(ci==c0 && ci==c)
                retrieved(i)=1;
                relevance(j)=1;
            end
        end
    end
    recall = mean(retrieved);
    precision = mean(relevance);
end