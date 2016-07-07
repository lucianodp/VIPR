function [Xroc, Yroc, AUC] = PlotRoc(Score, Yhat, Y)
% Function plots an ROC curve, given the scores, the predictions and the
% labels. The higher the score, the more 'confident' the classification.
    [SortedScores, Idx] = sort(Score,'descend');
    Yhat = Yhat(Idx);
    Y = Y(Idx);
    Xroc = zeros(size(Y,1)+1,1);
    Yroc = zeros(size(Y,1)+1,1);
    AUC = 0;
    for i=2:size(Y,1)+1
        Xroc(i) = Xroc(i-1);
        Yroc(i) = Yroc(i-1);
        if (Yhat(i-1)==1 && Y(i-1)==0)
            Xroc(i) = Xroc(i)+1;
            AUC = AUC + Yroc(i);
        else
            if (Yhat(i-1)==1 && Y(i-1)==1)
                Yroc(i) = Yroc(i)+1;
            end
        end    
    end
    AUC = AUC/(sum(Yhat==1 & Y==0)*sum(Yhat==1 & Y==1));
    if sum(Yhat==1 & Y==0) == 0
        AUC = 1;
    end
    if sum(Yhat==1 & Y==1) == 0
        AUC = 0;
    end
end