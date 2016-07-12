clear;
[X,Y,PIcls] = GenerateData4(2500,0,10,4,2);
Xtrain = X(1:2:end,:);
Ytrain = Y(1:2:end,:);
Xtest = X(2:2:end,:);
Ytest = Y(2:2:end,:);
d = 2; % max. dimensionality of recovered projections
K = 3; % parameter for k-NN classifiers
[L, Proj] = ComputeKNNlossMatrix(Xtrain,Ytrain,K,d);
P = 3; % number of informative projections to be retrieved
[IPE] = IPEtrain(L,Proj,P,'greedy');
[IPEclsModel] = IPEfromSelection(Xtrain, Ytrain, IPE.B, d, Proj);
[IPEclsTestResults] = RIPRclsTestModel(IPEclsModel, Xtest, Ytest, 1);
IPidx = find(IPEclsModel.ProjIdx);
IP = Proj(IPidx);
close all;
for p=1:P;
    figure; hold on;
    f1 = IP{p}(1);
    f2 = IP{p}(2);
    idx = IPE.B(:,IPidx(p)) & Ytrain==0;
    scatter(Xtrain(idx,f1), Xtrain(idx,f2),'b');
    idx = IPE.B(:,IPidx(p)) & Ytrain==1;
    scatter(Xtrain(idx,f1), Xtrain(idx,f2),'r');
    title(['Projection ', num2str(p)]);
    xlabel(['Feature ', num2str(f1)]);
    ylabel(['Feature ', num2str(f2)]);
end