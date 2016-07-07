function [RIPRactModel, RIPRactModelTrace] = ActiveRIPR(X,Y,d,r0,r, sampling_type)
% r0 - number of initial samples
% r - increment number of samples in an active batch
% v - variant of picking the active samples
    lambda = 0.1;
    idx_start = PickInitialSamples(X,r0); % get initial manually labeled samples
    [RIPRactModel] = RIPRclsTrainModel(X(idx_start,:),Y(idx_start,:),d,lambda);
    X = X(~idx_start,:); Y=Y(~idx_start);
    RIPRactModelTrace = cell(0,0); k = 1;
    RIPRactModelTrace{k} = RIPRactModel;
    while size(X,1)>0
        if (strcmpi(sampling_type,'RIPR'))
            % get samples for automatic labeling
            [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
            idx_auto = PickSamplesForAutoLabeling(RIPRactModel, RIPRclsTestResults, X, r);
            %Yauto = RIPRclsTestResults.Yhat(idx_auto); % assume automatic samples are labeled correctly
            %idx_correct = (RIPRclsTestResults.Yhat == Y);
            RIPRactModel = RIPRactUpdateModel(RIPRactModel,X(idx_auto,:),Y(idx_auto,:),lambda);
            k = k+1; RIPRactModelTrace{k} = RIPRactModel;
            X = X(~idx_auto,:); Y=Y(~idx_auto);

            % get samples for manual labeling
            %save('debug_active_ripr.mat');
            [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
            idx_manual = PickSamplesForManualLabeling(RIPRactModel, RIPRclsTestResults, X, r);
            %idx_correct = (RIPRclsTestResults.Yhat == Y);
            RIPRactModel = RIPRactUpdateModel(RIPRactModel,X(idx_manual,:),Y(idx_manual,:),lambda);
            k = k+1; RIPRactModelTrace{k} = RIPRactModel;
            X = X(~idx_manual,:); Y=Y(~idx_manual);
        else
            [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
            switch lower(sampling_type)
                case 'uncertainty'
                    idx_active = PickUncertainSamples(RIPRactModel, RIPRclsTestResults, X, r);
                case 'infogain'
                    idx_active = PickInfoGainSamples(RIPRactModel, RIPRclsTestResults, X, r, d);
                case 'committee'
                    idx_active = PickQueryByCommitteeSamples(RIPRactModel, RIPRclsTestResults, X, r);
                case 'lowloss'
                    idx_active = PickLowLossSamples(RIPRactModel, RIPRclsTestResults, X, r);
                case 'lowlossall'
                    ModelOnAllProjections = RIPRactModel;
                    ModelOnAllProjections.ProjIdx = true(length(ModelOnAllProjections.Projections),1);
                    ModelOnAllProjectionsTestResults = RIPRclsTestModel(ModelOnAllProjections, X, zeros(size(X,1),1));
                    idx_active = PickLowLossSamples(ModelOnAllProjections, ModelOnAllProjectionsTestResults, X, r);
                case 'oracle'
                    % Assumption: the samples have been given in the
                    % correct order.                    
                    idx_active = PickInitialSamples(X,r);
                case 'random'
                    idx_active = PickRandomSamples(X,r);
                otherwise
                    error('Invalid sampling_type.');
            end
            save('debug_active_ripr.mat');
            RIPRactModel = RIPRactUpdateModel(RIPRactModel,X(idx_active,:),Y(idx_active),lambda);
            k = k+1; RIPRactModelTrace{k} = RIPRactModel;
            X = X(~idx_active,:); Y=Y(~idx_active);
        end
    end
end

function idx_initial = PickInitialSamples(X,r0)
    idx_initial = false(size(X,1),1);
    idx_initial(1:min(r0,size(X,1))) = true;
end

function idx_random = PickRandomSamples(X,r)
    idx_shuffle = randperm(size(X,1));
    idx_random = false(size(X,1),1);
    idx_random(idx_shuffle(1:min(r, size(X,1)))) = true;
end

% UNCERTAINTY SAMPLING variants:
% 1: pick the labels with the smallest margin
%    min_x ( max_{y_hat2 \in vals(Y)} P(y_hat|x) - P(y_hat2|x))
% 2: pick samples with the lowest confidence
%    min_x (1-P(y_hat|x))
% 3: pick samples with highest entropy
%    max_x H(y|x)
% For binary tasks, these are equivalent.
% Current implementation: pick samples with max score (cond. entropy)
function idx_uncertainty = PickUncertainSamples(RIPRactModel, RIPRclsTestResults, X, r)
    r = min(r, size(X,1));
    [sorted, idx] = sort(RIPRclsTestResults.Score, 'descend');
    idx_uncertainty = false(size(X,1),1);
    idx_uncertainty(idx(1:r)) = true;
end

function idx_info_gain = PickLowLossSamples(RIPRactModel, RIPRclsTestResults, X, r)
    r = min(r, size(X,1));
    [sorted, idx] = sort(RIPRclsTestResults.Score, 'ascend');
    idx_info_gain = false(size(X,1),1);
    idx_info_gain(idx(1:r)) = true;
end

% Pick samples with disagreeing predictions
function idx_qbc = PickQueryByCommitteeSamples(RIPRactModel, RIPRclsTestResults, X, r)
    r = min(r, size(X,1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    disagreeing = max(disagreement,[],2);
    [sorted, idx] = sort(double(disagreeing), 'ascend');
    idx_qbc = false(size(X,1),1);
    idx_qbc(idx(1:r)) = true;   
end

% Aim: the pick conforming points that are easiest to classify
% Pick samples with non-disagreeing projections, lowest loss first
% If there are not enough samples without disagreeing projections, pick
% some with disagreeing projections, lowest loss first
% Returns fewer than r samples only if X does not have sufficient points
function idx_auto = PickSamplesForAutoLabeling(RIPRactModel, RIPRclsTestResults, X, r)
    r = min(r, size(X,1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    agreeing = ~max(disagreement,[],2);
    max_score_agreeing = max(agreeing.*RIPRclsTestResults.Score);
    S = RIPRclsTestResults.Score;
    % ensure the active score of points with disagreeing projections are
    % higher than all scores of points without disagreeing projections
    if (sum(~agreeing)>0)
        S(~agreeing) = S(~agreeing) + max_score_agreeing*ones(sum(~agreeing),1) + 1;
    end
    [sorted, idx] = sort(S,'descend');
    idx_auto = false(size(X,1),1);
    idx_auto(idx(1:r)) = true;
end
                            
% Aim: pick the conforming points that aren't straightforward
% Pick samples with disagreeing projections, lowest loss first
% If there are not enough samples with disagreeing projections, pick
% some without disagreeing projections, lowest loss first
% Returns fewer than r samples only if X does not have sufficient points
function idx_manual = PickSamplesForManualLabeling(RIPRactModel, RIPRclsTestResults, X, r)
    r = min(r, size(X,1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    agreeing = max(disagreement,[],2);
    max_score_disagreeing = max((~agreeing).*RIPRclsTestResults.Score);
    S = RIPRclsTestResults.Score;
    % ensure the active score of points without disagreeing projections are
    % higher than all scores of points with disagreeing projections
    if (sum(agreeing)>0)
        S(agreeing) = S(agreeing) + max_score_disagreeing*ones(sum(agreeing),1) + 1;
    end
    [sorted, idx] = sort(S,'descend');
    idx_manual = false(size(X,1),1);
    idx_manual(idx(1:r)) = true;
end

function idx_active = PickActiveSamples(RIPRactModel,X,r,v)
    r = min(r,size(X,1));
    idx_active = false(size(X,1),1);
    [RIPRclsTestResults] = RIPRclsTestModel(RIPRactModel, X, zeros(size(X,1),1));
    disagreement = (repmat(RIPRclsTestResults.Yhat,1,size(RIPRclsTestResults.AllYhat,2))~=RIPRclsTestResults.AllYhat);
    S = repmat(RIPRclsTestResults.Score,1,size(RIPRclsTestResults.AllScores,2));
    switch v
        case 1
            % compute difference between score of not(Y_hat) and Y_hat
            % sort ascending by smallest difference
            diffscore = disagreement.*(RIPRclsTestResults.AllScores - S);
            diffscore = diffscore + (~disagreement).*(ones(size(S,1),size(S,2))./RIPRclsTestResults.AllScores - S);
            diffscore(sub2ind(size(S), 1:size(S,1) , RIPRclsTestResults.ScoreIdx')) = Inf;
            [undertainty_scores, uncertainty_idx] = sort(min(diffscore,[],2),'ascend');
        case 2
            % sort ascending by the smallest disagreeing score 
            diffscore = disagreement.*RIPRclsTestResults.AllScores;
            diffscore = diffscore + (~disagreement)*10e4;
            diffscore(sub2ind(size(S), 1:size(S,1) , RIPRclsTestResults.ScoreIdx')) = Inf;
            [undertainty_scores, uncertainty_idx] = sort(min(diffscore,[],2),'ascend');
        case 3
            % sort descending by the smallest disagreeing score
            diffscore = disagreement.*RIPRclsTestResults.AllScores;
            diffscore = diffscore + (~disagreement)*10e4;
            diffscore(sub2ind(size(S), 1:size(S,1) , RIPRclsTestResults.ScoreIdx')) = Inf;
            [undertainty_scores, uncertainty_idx] = sort(min(diffscore,[],2),'descend');
        case 4
            % sort descending by the largest disagreeing score
            diffscore = disagreement.*RIPRclsTestResults.AllScores;
            [undertainty_scores, uncertainty_idx] = sort(max(diffscore,[],2),'descend');
        case 5
            % sort ascending by largest disagreeing score
            diffscore = disagreement.*RIPRclsTestResults.AllScores;
            [undertainty_scores, uncertainty_idx] = sort(max(diffscore,[],2),'ascend');
        case 6
            % sort ascending by the classification score
            [undertainty_scores, uncertainty_idx] = sort(RIPRclsTestResults.Score,'ascend');
        case 7
            % sort ascending by any available score (from the model or not)
            [LossAll, Projections] = LocalSscLossEstimator([RIPRactModel.X;X],[RIPRactModel.Y;-ones(size(X,1),1)],RIPRactModel.d,1);
            MinLossAll = min(LossAll(size(RIPRactModel.X,1)+1:size(RIPRactModel.X,1)+size(X,1),:),[],2);
            [undertainty_scores, uncertainty_idx] = sort(MinLossAll,'ascend');
        case 8
            % select points for which there exists a projection not in the
            % model which performs better than the ones in the model
            [LossAll, Projections] = LocalSscLossEstimator([RIPRactModel.X;X],[RIPRactModel.Y;-ones(size(X,1),1)],RIPRactModel.d,1);
            LossAll = LossAll(size(RIPRactModel.X,1)+1:size(RIPRactModel.X,1)+size(X,1),:);
            LossDiff = RIPRclsTestResults.Score - min(LossAll,[],2);
            [undertainty_scores, uncertainty_idx] = sort(LossDiff,'descend');
    end
    idx_active(uncertainty_idx(1:r)) = true;
end