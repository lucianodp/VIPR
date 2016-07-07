function [B] = CorrectDuplicateSelection(B)
%CORRECTDUPLICATESELECTION Summary of this function goes here
%   Detailed explanation goes here
    idxc = find(sum(B,2)>1);
    for i = 1:length(idxc)
        bnz = find(B(idxc(i),:));
        B(idxc(i),bnz(2:end)) = false;
    end
end

