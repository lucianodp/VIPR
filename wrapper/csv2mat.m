function [X,Y,Features] = csv2mat(filename)
% Read csv file and write data to mat file
% Replace missing values with means
    D = importdata(filename);
    X = D.data(:,1:end-1);
    Y = D.data(:,end);
    Features = D.colheaders;
    idx_missing_output = isnan(Y);
    X = X(~idx_missing_output,:);
    Y = Y(~idx_missing_output,:);
    save(strrep(filename,'.csv','.mat'),'X','Y','Features');
    for i=1:size(X,2)
        is = isnan(X(:,i));
        X(is,i) = mean(X(~is,i));
    end
    save(strrep(filename,'.csv','_no-missing.mat'),'X','Y','Features');
end