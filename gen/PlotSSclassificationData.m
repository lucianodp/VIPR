function [] = PlotSSclassificationData(X,Y,Yt,P)
    for i=1:length(P)
        f = P{1};
        figure; hold on;
        scatter(X(Y==-1,f(1)),X(Y==-1,f(2)),'.black');
        scatter(X(Y==0,f(1)),X(Y==0,f(2)),'.b');
        scatter(X(Y==1,f(1)),X(Y==1,f(2)),'.r');
    end
end

