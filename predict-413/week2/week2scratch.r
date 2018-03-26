
head(db)
rtnb=log(db[,3:6]+1)
head(rtnb)
#t-test for confidence interval
t.test(rtnb$ge)
#test skewness
tm3=skewness(rtnb$ge)/sqrt(6/length(rtnb$ge))
tm3
#graph GE
d3=density(rtnb$ge)
plot(d3$x,d3$y,xlab='returns',ylab='density',main='GE',type='l')
#test kurtosis
kurtosis(rtnb$ge)
tk=kurtosis(rtnb$ge)/sqrt(24/length(rtnb$ge))
tk



### Problem 1 ###
setwd("/northwestern/pred413")
da=read.table("d-nflx3dx0913.txt",header=T)
head(da)
basicStats(da$nflx)
basicStats(da$vwretd)
basicStats(da$ewretd)
basicStats(da$sprtrn)
rtn=log(da[,3:6]+1) ### Compute log returns
head(rtn)
basicStats(rtn$nflx)
basicStats(rtn$vwretd)
basicStats(rtn$ewretd)
basicStats(rtn$sprtrn)
t.test(rtn$nflx)
d1=density(rtn$nflx)
d2=density(rtn$sprtrn)
par(mfcol=c(1,2))
plot(d1$x,d1$y,xlab='returns',ylab='density',main='Netflix',type='l')
plot(d2$x,d2$y,xlab='returns',ylab='density',main='SP',type='l')
