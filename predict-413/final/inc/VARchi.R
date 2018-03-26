"VARchi" <- function(x,p=1,include.mean=T,thres=1.96){
# Fits a vector AR(p) model, then performs 
# a chi-square test to zero out insignificant parameters.
if(!is.matrix(x))x=as.matrix(x)
Tn=dim(x)[1]
k=dim(x)[2]
if(p < 1)p=1
ne=Tn-p
ist=p+1
y=x[ist:Tn,]
if(include.mean){
xmtx=cbind(rep(1,ne),x[p:(Tn-1),])
}
else {
xmtx=x[p:(Tn-1),]
}
if(p > 1){
for (i in 2:p){
xmtx=cbind(xmtx,x[(ist-i):(Tn-i),])
}
}
#
#perform estimation
ndim=dim(xmtx)[2]
res=NULL
xm=as.matrix(xmtx)
xpx=t(xm)%*%xm
xpxinv=solve(xpx)
xpy=t(xm)%*%as.matrix(y)
beta=xpxinv%*%xpy
resi=y-xm%*%beta
sse=t(resi)%*%resi/(Tn-p-ndim)
C1=kronecker(sse,xpxinv)
dd=sqrt(diag(C1))
#
bhat=c(beta)
tratio=bhat/dd
para=cbind(bhat,dd,tratio)
npar=length(bhat)
K=NULL
omega=NULL
for (i in 1:npar){
if(abs(tratio[i]) < thres){
idx=rep(0,npar)
idx[i]=1
K=rbind(K,idx)
omega=c(omega,bhat[i])
}
}
v=dim(K)[1]
K=as.matrix(K)
cat("Number of targeted parameters: ",v,"\n")
#####print(K)
if(v > 0){
C2=K%*%C1%*%t(K)
C2inv=solve(C2)
tmp=C2inv%*%as.matrix(omega,v,1)
chi=sum(omega*tmp)
pvalue=1-pchisq(chi,v)
cat("Chi-square test and p-value: ",c(chi,pvalue),"\n")
}
else{
print("No contraints needed")
}
VARchi<-list(data=x,cnst=include.mean,order=p,coef=beta,constraints=K,omega=omega,covomega=C2)
}

###
"FEVdec" <- function(Phi,Theta,Sig,lag=4){
# Perform forecast error vcovariance decomposition
#
# Phi: k by kp matrix of AR coefficients, i.e. [AR1,AR2,AR3, ..., ARp]
# Theta: k by kq matrix of MA coefficients, i.e. [MA1,MA2, ..., MAq]
# Sig: residual covariance matrix
# Output: (a) Plot and (b) Decomposition
# Created by Ruey S. Tsay, April 2012.
#
if(length(Phi) > 0){
if(!is.matrix(Phi))Phi=as.matrix(Phi)
}
if(length(Theta) > 0){
if(!is.matrix(Theta))Theta=as.matrix(Theta)
}
if(!is.matrix(Sig))Sig=as.matrix(Sig)
if(lag < 1) lag=1
# Compute MA representions: This gives impulse response function without considering Sigma.
p = 0
if(length(Phi) > 0){
k=nrow(Phi)
m=ncol(Phi)
p=floor(m/k)
}
q=0
if(length(Theta) > 0){
k=dim(Theta)[1]
m=dim(Theta)[2]
q=floor(m/k)
}
cat("Order of the ARMA mdoel: ","\n")
print(c(p,q))
# Consider the MA part to psi-weights
Si=diag(rep(1,k))
if(q > 0){
Si=cbind(Si,-Theta)
}
m=(lag+1)*k
m1=(q+1)*k
if(m > m1){
Si=cbind(Si,matrix(0,k,(m-m1)))
}
#
if (p > 0){
for (i in 1:lag){
if (i <= p){
idx=(i-1)*k
tmp=Phi[,(idx+1):(idx+k)]
}
else{
tmp=matrix(0,k,k)
}
#
jj=i-1
jp=min(jj,p)
if(jp > 0){
for(j in 1:jp){
jdx=(j-1)*k
idx=(i-j)*k
w1=Phi[,(jdx+1):(jdx+k)]
w2=Si[,(idx+1):(idx+k)]
tmp=tmp+w1%*%w2
##print(tmp,digits=4)
}
}
kdx=i*k
Si[,(kdx+1):(kdx+k)]=tmp
## end of i loop
}
## end of (p > 0)
}
# Compute the impulse response of orthogonal innovations
orSi=NULL
m1=chol(Sig)
P=t(m1)
orSi=P
for(i in 1:lag){
idx=i*k
w1=Si[,(idx+1):(idx+k)]
w2=w1%*%P
orSi=cbind(orSi,w2)
}
#### Compute the covariance matrix of forecast errors
### Compute the squares of each element in orSi.
orSi2=orSi^2
##### compute the partial sum (summing over lags)
Ome=orSi2[,1:k]
wk=Ome
for (i in 1:lag){
idx=i*k
wk=wk+orSi2[,(idx+1):(idx+k)]
Ome=cbind(Ome,wk)
}
FeV=NULL
##
OmeRa = Ome[,1:k]
FeV=cbind(FeV,apply(OmeRa,1,sum))
OmeRa = OmeRa/FeV[,1]
for (i in 1:lag){
idx=i*k
wk=Ome[,(idx+1):(idx+k)]
FeV=cbind(FeV,apply(wk,1,sum))
OmeRa=cbind(OmeRa,wk/FeV[,(i+1)])
}
cat("Standard deviation of forecast error: ","\n")
print(sqrt(FeV))
#
cat("Forecast-Error-Variance Decomposition","\n")
for (i in 1:(lag+1)){
idx=(i-1)*k
cat("Forecast horizon: ",i,"\n")
Ratio=OmeRa[,(idx+1):(idx+k)]
print(Ratio)
}

FEVdec <- list(irf=Si,orthirf=orSi,Omega=Ome,OmegaR=OmeRa)
}
