function [id] = GetFeatureId(Features, featurename)
%GETFEATUREID Returns the id of the specified feature
    for i=1:length(Features)
        if(strcmp(Features{i},featurename))
            id = i; return;
        end
    end
    id = 0;
end

