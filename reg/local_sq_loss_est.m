function L = local_sq_loss_est(X,pi,k,Y)
    [idx, d] = knnsearch(X(:,pi),X(:,pi),'K',k+1);
    d_nn = d(:,2:k+1);
    y_nn = Y(idx);
    y_nn = y_nn(:,2:k+1);
    w_nn = RobustDivision(ones(size(d_nn,1),size(d_nn,2)),d_nn);
    y_est = RobustDivision(sum(y_nn.*w_nn,2),sum(w_nn,2));
    L = Y-y_est;
    L = L.*L;
end