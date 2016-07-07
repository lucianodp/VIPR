function [Z,mu,TX]=DecorrelateData2(X)

mu=mean(X,2);
X2=X-repmat(mu,1,size(X,2));
cov=X2*X2'/size(X,2);
[U,V]=eig(cov);
mask=diag(V)>0;
U=U(:,mask);
V=V(mask,mask);
TX=V^(-0.5)*U';
Z=TX*X2;

end
%figure, imshow(Z*Z',[]);