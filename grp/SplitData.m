function [TrainData, TestData] = SplitData(Data,numfolds)
    n = size(Data,1);
    foldsize = floor(n/numfolds);
    rowspfold = ones(numfolds,1)*foldsize;
    rowspfold(numfolds) = rowspfold(numfolds) + (n-foldsize*numfolds);
    SplitData = mat2cell(Data,rowspfold,size(Data,2));
    TrainData = cell(1,numfolds);
    TestData = cell(1,numfolds);
    for i=1:numfolds
        TrainData{i} = cell2mat(SplitData(setdiff(1:numfolds,i)));
        TestData{i} = SplitData{i};
    end
end

