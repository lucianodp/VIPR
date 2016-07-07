clear;
load('usps.mat');
sel = true;
MetricEvalFunctions{1} = @MetricEvalAccuracy;
Solver = @kNNclassificationSolver;
Predict = @kNNclassificationPredict;
Params = 3;
idx = randperm(size(X,1)); X = X(idx,:); Y = Y(idx,:);
if sel
    [W, pc] = princomp(X); 
    X = pc(:,1:30);
end
numf = 11;
[Xcvtr, Xcvts] = SplitData(X,numf); [Ycvtr, Ycvts] = SplitData(Y,numf);  
[Metrics, Models] = CrossValidation(Xcvtr, Ycvtr, Xcvts, Ycvts, Solver, Predict, Params, MetricEvalFunctions);

m = cell2mat(Metrics);
mu = zeros(1,size(m,2)); 
sigma = zeros(1,size(m,2));
for i=1:size(m,2)
    mu = mean(m(:,i));
    sigma = std(m(:,i));
end
save('usps_knn_vipr.mat');