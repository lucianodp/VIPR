clear;
load('MNIST.mat');

sel = false;
MetricEvalFunctions{1} = @MetricEvalAccuracy;
Solver = @SVMclassificationSolver;
Predict = @SVMclassificationPredict;
Params = [];
if sel
    n = size(X,1);
    f = 10;
    [W, pc] = princomp([X;XTest]);
    X = pc(1:n,1:f);
    XTest = pc(n+1:end,1:f);
end
[Xboot, Yboot, Idxs] = BootstrapData(X, Y, 10, 0.9);
Xts = cell(size(Xboot)); Xts(:) = {XTest};
Yts = cell(size(Xboot)); Yts(:) = {YTest};
[Metrics, Models] = CrossValidation(Xboot, Yboot, Xts, Yts, Solver, Predict, Params, MetricEvalFunctions);

m = cell2mat(Metrics);
mu = zeros(1,size(m,2)); 
sigma = zeros(1,size(m,2));
for i=1:size(m,2)
    mu = mean(m(:,i));
    sigma = std(m(:,i));
end
save('MNIST_svm_vipr.mat');