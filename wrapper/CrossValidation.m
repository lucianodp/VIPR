function [Metrics, Models] = CrossValidation(Xcvtr, Ycvtr, Xcvts, Ycvts, Solver, Predict, Params, MetricEvalFunctions)
% This function performs cross validation on the specified solver,
% training models on the specified 
% Xcv, Ycv and MetricEvalFunctions are cell arrays
    Metrics = cell(length(Xcvtr), length(MetricEvalFunctions));
    Models = cell(size(Xcvtr));
    for i=1:length(Xcvtr)
    %for i=1:1
        fprintf(1, 'Training model %d ... ', i);
        if (isempty(Params))
            Models{i} = Solver(Xcvtr{i}, Ycvtr{i});
        else
            Models{i} = Solver(Xcvtr{i}, Ycvtr{i}, Params);
        end
        fprintf('done.\nPerforming prediction ... ');
        Yhat= Predict(Xcvts{i}, Ycvts{i}, Models{i});
        fprintf('done.\n');
        for j=1:length(MetricEvalFunctions)
            fprintf('Computing metric %d ... ', j);
            metricfun = MetricEvalFunctions{j};
            Metrics{i,j} = metricfun(Xcvtr{i}, Ycvtr{i}, Xcvts{i}, Ycvts{i}, Yhat, Models{i});
            fprintf('done.\n');
        end
    end
end