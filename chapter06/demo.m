% demos for ch06


%% Kernel regression with gaussian kernel
clear; close all;
n = 100;
x = linspace(0,2*pi,n);   % test data
t = sin(x)+rand(1,n)/2;
model = knReg(x,t,1e-4,@knGauss);
knRegPlot(model,x,t);

%% Kernel regression with linear kernel is EQUIVALENT to linear regression
lambda = 1e-4;
model_kn = knReg(x,t,lambda,@knLin);
model_lin = linReg(x,t,lambda);

idx = 1:2:n;
xt = x(:,idx);
tt = t(idx);

[y_kn, sigma_kn,p_kn] = knRegPred(model_kn,xt,tt);
[y_lin, sigma_lin,p_lin] = linRegPred(model_lin,xt,tt);

maxdiff(y_kn,y_lin)
maxdiff(sigma_kn,sigma_lin)
maxdiff(p_kn,p_lin)
%% Kernel kmeans with linear kernel is EQUIVALENT to kmeans
clear; close all;
d = 2;
k = 3;
n = 500;
[X,y] = kmeansRnd(d,k,n);
init = ceil(k*rand(1,n));
[y_kn,en_kn,model_kn] = knKmeans(X,init,@knLin);
[y_lin,en_lin,model_lin] = kmeans(X,init);

idx = 1:2:n;
Xt = X(:,idx);

[t_kn,ent_kn] = knKmeansPred(model_kn, Xt);
[t_lin,ent_lin] = kmeansPred(model_lin, Xt);

maxdiff(y_kn,y_lin)
maxdiff(en_kn,en_lin)

maxdiff(t_kn,t_lin)
maxdiff(ent_kn,ent_lin)
%% Kernel PCA with linear kernel is EQUIVALENT TO PCA
clear; close all;
d = 10;
q = 2;
n = 500;
X = randn(d,n);


model_kn = knPca(X,q,@knLin);
idx = 1:2:n;
Xt = X(:,idx);

Y_kn = knPcaPred(model_kn,Xt);

[U,L,mu,err1] = pca(X,q);
Y_lin = U'*bsxfun(@minus,Xt,mu);   % projection


R = Y_lin/Y_kn;    % the results are equivalent up to a rotation.
maxdiff(R*R', eye(q))

%% demo for knCenter
clear; close all;
kn = @knGauss;
X=rand(2,100);
X1=rand(2,10);
X2=rand(2,5);

maxdiff(knCenter(kn,X,X1),diag(knCenter(kn,X,X1,X1)))
maxdiff(knCenter(kn,X),knCenter(kn,X,X,X))