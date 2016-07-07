function PlotBinaryOutputData(X,Y)
    X0 = X(Y==0,:);
    X1 = X(Y==1,:);
    figure;hold on;
    scatter(X0(:,1),X0(:,2),'.b');
    scatter(X1(:,1),X1(:,2),'.r');
end