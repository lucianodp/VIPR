clear;
expname = 'chars74k';
switch expname
    case 'letter'
        load('data/letter_26class.mat');
        Xtrain = double(X);
        Ytrain = double(Y);
        load('data/letter_26classTest.mat');
        Xtest = double(XTest);
        Ytest = double(YTest);
        [Xtrain,muX,TX] = DecorrelateData2(Xtrain);
        Xtest=TX*(Xtest-repmat(muX,1,size(Xtest,2)));
        Xtrain = Xtrain'; Ytrain = Ytrain';
        Xtest = Xtest'; Ytest = Ytest';
    case 'mnist'
        load('data/MNIST.mat');
        [Xtrain,muX,TX] = DecorrelateData2(X);
        Xtest=TX*(XTest-repmat(muX,1,size(XTest,2)));
        Xtrain = Xtrain'; Ytrain = Y';
        Xtest = Xtest'; Ytest = YTest';
    case 'G50c'
        load('data/G50c.mat');
        idx_all = 1:size(X,1);
        idx_test = 1:11:size(X,1);
        idx_train = setdiff(idx_all,idx_test);
        Xtrain = X(idx_train,:);
        Ytrain = Y(idx_train,:);
        Xtest = X(idx_test,:);
        Ytest = Y(idx_test,:);
        [Xtrain,muX,TX] = DecorrelateData2(Xtrain');
        Xtrain = Xtrain';
        Xtest=(TX*(Xtest'-repmat(muX,1,size(Xtest',2))))';
    case 'usps'
        load('data/usps_all.mat');
        X = zeros(0,size(data,1));
        Y = zeros(0,1);
        for i=1:size(data,3)
            X = [X; double(data(:,:,i))'];
            Y = [Y; (i-1)*ones(size(data,2),1)];
        end
        idx_all = 1:size(X,1);
        idx_test = 1:11:size(X,1);
        idx_train = setdiff(idx_all,idx_test);
        Xtrain = X(idx_train,:);
        Ytrain = Y(idx_train,:);
        Xtest = X(idx_test,:);
        Ytest = Y(idx_test,:);
    case 'chars74k'
        load('data/Chars74k/Chars74kHnd');
        idx_all = 1:size(X,1);
        idx_test = 1:10:size(X,1);
        idx_train = setdiff(idx_all,idx_test);
        Xtrain = X(idx_train,:);
        Ytrain = Y(idx_train,:);
        Xtest = X(idx_test,:);
        Ytest = Y(idx_test,:);        
    otherwise
        [X,Y,PIcls] = GenerateData4(2500,0,10,4,2);
        Xtrain = X(1:2:end,:);
        Ytrain = Y(1:2:end,:);
        Xtest = X(2:2:end,:);
        Ytest = Y(2:2:end,:);
        %[Xtrain,muX,TX] = DecorrelateData2(Xtrain');
        %Xtrain = Xtrain';
        %Xtest=(TX*(Xtest'-repmat(muX,1,size(Xtest',2))))';
end
[Ensemble] = TrainEnsemble(Xtrain,Ytrain,1500,0.06);
[Yhat, EnsemblePrediction] = EnsemblePredict(Ensemble,Xtest);
[Error, ErrorOk, ErrorNok] = PlotAccuracyCurves(EnsemblePrediction,Ytest);
%[YhatSep, ErrorSep, MetaErrorSep] = PredictSeparately(Ensemble,Xtest,Ytest);