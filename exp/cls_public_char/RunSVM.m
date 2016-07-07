clear;
load('G50C.mat');
sel = false;
MetricEvalFunctions{1} = @MetricEvalAccuracy;
Solver = @SVMclassificationSolver;
Predict = @SVMclassificationPredict;
Params = [];
idx = randperm(size(X,1)); X = X(idx,:); Y = Y(idx,:);
if sel
    [W, pc] = princomp(X); 
    X = pc(:,1:25);
end
[Xcvtr, Xcvts] = SplitData(X,11); [Ycvtr, Ycvts] = SplitData(Y,11);  
[Metrics, Models] = CrossValidation(Xcvtr, Ycvtr, Xcvts, Ycvts, Solver, Predict, Params, MetricEvalFunctions);

m = cell2mat(Metrics);
mu = zeros(1,size(m,2)); 
sigma = zeros(1,size(m,2));
for i=1:size(m,2)
    mu = mean(m(:,i));
    sigma = std(m(:,i));
end
save('G50C_SVM_vipr.mat');