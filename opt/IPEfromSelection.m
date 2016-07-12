function [IPEclsModel] = IPEfromSelection(X, Y, B, d, Projections)
%IPEFROMSELECTION Summary of this function goes here
%   Detailed explanation goes here
    IPEclsModel = struct;
    IPEclsModel.Projections = Projections;
    IPEclsModel.ProjIdx = (sum(B)>0);
    IPEclsModel.Xu = X(Y==-1,:);
    IPEclsModel.X = X(Y~=-1,:);
    IPEclsModel.Y = Y(Y~=-1);
    IPEclsModel.Classes = unique(Y);
    IPEclsModel.d = d;
end

