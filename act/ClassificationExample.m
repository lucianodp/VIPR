[X,Y,PIcls] = GenerateData3(500,200,10,2,2);
train_range = 1:2:size(X,1);
test_range = 2:2:size(X,1);
lambda = 0.1; d = 2;
RIPRclsModel = RIPRclsTrainModel(X(train_range,:),Y(train_range,:),d,lambda);
RIPRclsTestResult = RIPRclsTestModel(RIPRclsModel, X(test_range,:), Y(test_range,:));