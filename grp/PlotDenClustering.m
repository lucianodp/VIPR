function [proj,L,T,idx,idxc,L_r,T_r,idx_r,idxc_r] = PlotDenClustering(X,Xnames,d,k,p_num,name)
    filename = sprintf('Exp_%s_%s_d_%d_k_%d_pnum_%d',name,datestr(now, 'yymmddHHMMSS'),d,k,p_num);
    [L, proj] = LocalDenClusteringLoss(X,d,k);
    [T, idx] = min(L,[],2);
    if(p_num > length(idx))
        p_num = length(idx);
    end
    idxc = [unique(idx), histc(idx,unique(idx))];
    [idxc_s, idx_s_idx] = sort(idxc(:,2),'descend');
    idxc_r = idxc(idx_s_idx,:);
    idxc_r = idxc_r(1:p_num,:);
    L_r = L(:,idxc_r(:,1));
    [T_r, idx_r] = min(L_r,[],2);
    for i=1:p_num
        p_idx = i;
        p = proj{idxc_r(i,1)};
        h = figure('position',[100,200,1000,600]); hold on;
        if(length(p)==1)
            scatter(X(:,p(1)),X(:,p(1)),'.black');
            scatter(X(idx_r==p_idx,p(1)),X(idx_r==p_idx,p(1)),'.red');
            xlabel(Xnames(p(1)));ylabel(Xnames(p(1)));
        end
        if(length(p)==2)
            scatter(X(:,p(1)),X(:,p(2)),'.black');
            scatter(X(idx_r==p_idx,p(1)),X(idx_r==p_idx,p(2)),'.red');
            xlabel(Xnames(p(1)));ylabel(Xnames(p(2)));
        end
        if(length(p)==3)
            plot3k([X(idx_r==p_idx,p(1)),X(idx_r==p_idx,p(2)),X(idx_r==p_idx,p(3))]);
            xlabel(Xnames(p(1)));ylabel(Xnames(p(2)));zlabel(Xnames(p(3)));
        end
        %eps_name = [filename,'_',num2str(i),'.eps'];
        %print(h,'-depsc',eps_name);
        %pdf_name = [filename,'_',num2str(i),'.pdf'];
        %print(h,'-dpdf',pdf_name);
        saveas(h, [filename,'_',num2str(i),'.fig']);
        png_name = [filename,'_',num2str(i),'.png'];
        print(h,'-dpng',png_name);
        close(h);
    end
    save([filename,'.mat']);
end