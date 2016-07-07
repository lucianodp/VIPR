function [Error, ErrorOk, ErrorNok] = PlotAccuracyCurves(EnsemblePrediction,Y)
%PLOTACCURACYCURVES
% Plot the accuracy curves for the ensemble.
    k = size(EnsemblePrediction.Trace,1);
    Accuracy = zeros(1,k);
    AccuracyOk = zeros(1,k);
    AccuracyNok = zeros(1,k);
    for i=1:k
        Error(i) = mean(EnsemblePrediction.Trace{i}.Prediction.Yhat~=Y);
        ErrorOk(i) = mean(EnsemblePrediction.Trace{i}.OkPrediction.Yhat~=Y);
        ErrorNok(i) = mean(EnsemblePrediction.Trace{i}.NokPrediction.Yhat~=Y);
    end
    figure; hold on;
    plot(ErrorOk,'b');
    plot(Error,'m');
    plot(ErrorNok,'r');
    legend('sharp ensemble','original ensemble','left-out trees');
    title('Ensemble performance curve');
    xlabel('Number of trees');
    ylabel('Error');
end

