function [id] = FindProjectionId(Projections, p)
%FINDPROJECTIONID Returns the index of the projection p
    for i=1:length(Projections)
        if (isempty(setdiff(Projections{i,1}, p)) && isempty(setdiff(p, Projections{i,1})))
            id = i; return;
        end
    end
    id = 0;
end