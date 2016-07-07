function [ClsModel] = TrainClassifier(X,Y)
%TRAINCLASSIFIER train a classfieir
% for now, we'll use CART
    ClsModel = struct;
    ClsModel.X = X;
    ClsModel.Y = Y;
    %ClsModel.B = TreeBagger(1,X,Y);
    %ClsModel.ClassNames = ClsModel.B.ClassNames;
    ClsModel.T = classregtree(X, Y, 'method', 'classification', 'minparent', 10, 'prune', 'on', 'splitcriterion', 'gdi');
    A = unique(Y);
    B = mat2cell(A,ones(size(A,1),1),ones(1,size(A,2)));
    ClsModel.ClassNames = cellfun(@num2str,B,'uniformoutput',0);
    %[Yhat, node, labels]  = eval(ClsModel.T, X);
    %ClsModel.ClassNames(labels) = Yhat;
    %ClsModel.ClassNames = ClsModel.ClassNames';
end