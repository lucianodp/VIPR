function [Yhat, EnsemblePrediction] = EnsemblePredict(Ensemble,X)
%PREDICTENSEMBLE
% Predict class using the submodels in the ensemble. Apply svm 
% classifier to determine which submodels to be used for each point.
% use majority vote for ensembles
    if (Ensemble.k<1)
        error('Invalid ensemble. At least 1 classifier required');
    end
    numy = numel(unique(Ensemble.Ytrain));
    score_ok = zeros(size(X,1),numy); % class log prob, for each point, based on ensemble members which should be used
    num_ok = zeros(size(X,1),1); % for each point, the number of ensemble members which should be used
    score_nok = zeros(size(X,1),numy); % class log prob, for each point, based on ensemble members which should not be used
    num_nok = zeros(size(X,1),1); % for each point, the number of ensemble members which should not be used
    score = zeros(size(X,1),numy);
    Trace = cell(size(Ensemble.Submodel));
    for i=1:Ensemble.k
        % Determine which points the submodel should be used for
        %ok = svmclassify(Ensemble.Submodel{i}.UsageSvmCls, X);
        UsageKnn = Ensemble.Submodel{i}.UsageKnn;
        ok = logical(knnclassify(X, UsageKnn.X0, UsageKnn.C, 1));
        [Prediction] = ClassifierPredict(Ensemble.Submodel{i}.ClsModel,X(:,Ensemble.Submodel{i}.ProjDim));
        num_ok = num_ok + double(ok);
        score_ok = score_ok + CopySelRows(Prediction.scores,ok);
        num_nok = num_nok + (1-double(ok));
        score_nok = score_nok + CopySelRows(Prediction.scores,~ok);
        score = score + Prediction.scores;
        ClassNames = Ensemble.Submodel{i}.ClsModel.ClassNames;
        Trace{i} = struct;
        Trace{i}.Prediction = DeterminePrediction(num_ok+num_nok, score, ClassNames);
        Trace{i}.OkPrediction = DeterminePrediction(num_ok, score_ok, ClassNames);
        Trace{i}.NokPrediction = DeterminePrediction(num_nok, score_nok, ClassNames);
    end
    EnsemblePrediction = Trace{Ensemble.k}.Prediction;
    EnsemblePrediction.Trace = Trace;
    Yhat = EnsemblePrediction.Yhat;
end

% This function copies into R the rows of M for which sel is 0
% The rest of the values are set to 0
% M is an [n x m] matrix of real values
% sel is a [n x 1] boolean vector
function [R] = CopySelRows(M,sel)
    R = zeros(size(M));
    R(sel,:) = M(sel,:);
end

function Prediction = DeterminePrediction(num, scores, ClassNames)
    [M, I] = max(scores,[],2);
    Prediction.Yhat = cellfun(@str2double,ClassNames(I)); 
    Prediction.scores = M;
    Prediction.trust = (num>0);
end
