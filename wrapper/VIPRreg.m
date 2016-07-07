function [VIPRregressionModel] = VIPRreg(filename, d, P)
% Train and plot RIPR regression model
% Filename - mat file containing X, Y, Features
    load(filename);
    RegressionSolver = @SVMregressionSolver;
    VIPRregressionModel = VIPRregressionTrainModel(X,Y,d,P,RegressionSolver);
    %RegressionEval = @SVMregressionPredict;
    %VIPRregressionTestResult = VIPRregressionTestModel(VIPRregressionModel, X_test, Y_test, RegressionEval);
    %MSEVIPR = VIPRregressionTestResult.MSE; 
end