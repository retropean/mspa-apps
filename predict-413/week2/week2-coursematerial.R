### Problem 1 ###

da1=read.table("m-ge3dx8113.txt",header=T)
head(da1)
basicStats(da1$ge)
basicStats(da1$vwretd)
basicStats(da1$ewretd)
basicStats(da1$sprtrn)
rtn1=log(da1[,3:6]+1)
basicStats(rtn1$ge)
basicStats(rtn1$vwretd)
basicStats(rtn1$ewretd)
basicStats(rtn1$sprtrn)
t.test(rtn1$ge)
d1=density(rtn1$ge)
d2=density(rtn1$sprtrn)
plot(d1$x,d1$y,type='l',xlab='returns',ylab='density',main='GE stock')
plot(d2$x,d2$y,type='l',xlab='returns',ylab='density',main='SP index')

### Problem 2 ###

nflx=rtn$nflx
tm3=skewness(nflx)/sqrt(6/length(nflx))
tm3
tk=kurtosis(nflx)/sqrt(24/length(nflx))
tk
t.test(nflx)

### Problem 3 ###

### Use Hyndeman text 

