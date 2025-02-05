function [label, model, llh] = mixMnEm(X, k)
% Perform EM algorithm for fitting the multinomial mixture model.
% Input: 
%   X: d x n data matrix
%   k: number of cluster (1 x 1) or label (1 x n, 1<=label(i)<=k) or model structure
% Output:
%   label: 1 x n cluster label
%   model: trained model structure
%   llh: loglikelihood
% Written by Mo Chen (sth4nth@gmail.com).
%% initialization
fprintf('EM for mixture model: running ... \n');
n = size(X,2);
label = ceil(k*rand(1,n));  % random initialization
R = sparse(1:n,label,1,n,k,n);
tol = 1e-4;
maxiter = 500;
llh = -inf(1,maxiter);
for iter = 2:maxiter
    model = maximization(X,R);
    [R, llh(iter)] = expectation(X,model);
    if abs(llh(iter)-llh(iter-1)) < tol*abs(llh(iter)); break; end;
end
[~,label(:)] = max(R,[],2);
llh = llh(2:iter);

function [R, llh] = expectation(X, model)
mu = model.mu;
w = model.weight;
n = size(X,2);
logRho = X'*log(mu);
logRho = bsxfun(@plus,logRho,log(w));
T = logsumexp(logRho,2);
llh = sum(T)/n; % loglikelihood
logR = bsxfun(@minus,logRho,T);
R = exp(logR);

function model = maximization(X, R)
n = size(X,2);
nk = sum(R,1);
w = nk/n;
mu = bsxfun(@times, X*R, 1./nk);
d = size(X,1);
lambda = 1e-4;
prior = (1/d)*ones(d,1);
mu = bsxfun(@plus,(1-lambda)*mu,lambda*prior);
model.mu = mu;
model.weight = w;