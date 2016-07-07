function [Ensemble] = TrainEnsemble(X,Y,k,q)
%TRAINENSEMBLE train an ensemble of k classifiers
    if (nargin<4)
        q = 1;
    end
    if (q>1 || q<0)
        q = 1;
    end
    if (k < 1)
        fprintf(1,'Setting number of classifiers in ensemble to 1.\n');
        k = 1;
    end
    Ensemble = struct;
    Ensemble.k = k;
    Ensemble.Xtrain = X;
    Ensemble.Ytrain = Y;
    Ensemble.Submodel = cell(k,1);
    for i=1:k
        fprintf(1,'Training submodel %d', i);
        Ensemble.Submodel{i} = struct;
        Ensemble.Submodel{i}.ProjDim = randperm(size(X,2));
        Ensemble.Submodel{i}.ProjDim = Ensemble.Submodel{i}.ProjDim(1:ceil(size(X,2)*q));
        Ensemble.Submodel{i}.PointsIdx = true(size(X,1),1);
        Ensemble.Submodel{i}.Xsub = X(Ensemble.Submodel{i}.PointsIdx, Ensemble.Submodel{i}.ProjDim);
        Ensemble.Submodel{i}.Ysub = Y(Ensemble.Submodel{i}.PointsIdx);
        fprintf(1,'.');
        Ensemble.Submodel{i}.ClsModel = TrainClassifier(Ensemble.Submodel{i}.Xsub,Ensemble.Submodel{i}.Ysub);
        fprintf(1,'.');
        Ensemble.Submodel{i}.Prediction = ClassifierPredict(Ensemble.Submodel{i}.ClsModel,Ensemble.Submodel{i}.Xsub);
        fprintf(1,'.');
        C = (Ensemble.Submodel{i}.Ysub == Ensemble.Submodel{i}.Prediction.Yhat);
        Ensemble.Submodel{i}.Prediction.correct = C;
        X0 = X;
        if(sum(C)==0 || sum(~C)==0) % if predictions are either all correct or all incorrect
            dummy = -100000*ones(1,size(X,2));
            X0 = vertcat(X0,dummy);
            C = vertcat(C,~C(1));
        end
        fprintf(1,'.');
        %Ensemble.Submodel{i}.UsageSvmCls = svmtrain(X0, C,'kernel_function','rbf');
        Ensemble.Submodel{i}.UsageKnn = struct;
        Ensemble.Submodel{i}.UsageKnn.X0 = X0;
        Ensemble.Submodel{i}.UsageKnn.C = C;
        fprintf(1,' done.\n');
    end
end