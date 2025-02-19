clear;
load('letter_26class.mat');
load('letter_26classTest.mat');

sel = true;
MetricEvalFunctions{1} = @MetricEvalAccuracy;
Solver = @kNNclassificationSolver;
Predict = @kNNclassificationPredict;
Params = 3;
if sel
    n = size(X,1);
    f = 14;
    [W, pc] = princomp([X;XTest]);
    X = pc(1:n,1:f);
    XTest = pc(n+1:end,1:f);
end
[Xboot, Yboot, Idxs] = BootstrapData(X, Y, 10, 0.9);
Xts = cell(size(Xboot)); Xts(:) = {XTest};
Yts = cell(size(Yboot)); Yts(:) = {YTest};
[Metrics, Models] = CrossValidation(Xboot, Yboot, Xts, Yts, Solver, Predict, Params, MetricEvalFunctions);

m = cell2mat(Metrics);
mu = zeros(1,size(m,2)); 
sigma = zeros(1,size(m,2));
for i=1:size(m,2)
    mu = mean(m(:,i));
    sigma = std(m(:,i));
end

save('letter_26class_knn_vipr.mat');