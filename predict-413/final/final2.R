library(fBasics)
library(fGarch)
library(MTS)
library(quantmod)
library(rmgarch)
library(rugarch)

library(car)
library(FinTS)
library(PerformanceAnalytics)
source("inc/covEWMA.r")
source("inc/ccm.R")
source("inc/mq.R")
source("inc/VARchi.R")
source("inc/VAR.R")

setwd("C:/Users/00811289/Desktop/413/final")

# download data
MSFT <- read.table("inc/MSFT.csv",header=TRUE,sep=",")
INTC <- read.table("inc/INTC.csv",header=TRUE,sep=",")

colnames(MSFT)
head(MSFT)
tail(MSFT)

# convert to time series, extract adjusted closing prices
MSFTts <- xts(MSFT$Adj.Close, as.Date(MSFT$Date, format='%Y-%m-%d'))
INTCts <- xts(INTC$Adj.Close, as.Date(INTC$Date, format='%Y-%m-%d'))

head(MSFTts)
head(INTCts)

# plot prices
plot(MSFTts, main='Closing Prices, MSFT')
plot(INTCts, main='Closing Prices, INTC')

# calculate log-returns for GARCH analysis
MSFT.ret <- CalculateReturns(MSFTts, method="log")
INTC.ret <- CalculateReturns(INTCts, method="log")

# remove first NA observation
MSFT.ret <- MSFT.ret[-1,]
INTC.ret <- INTC.ret[-1,]
colnames(MSFT.ret) <- "MSFT"
colnames(INTC.ret) <- "INTC"

# create combined data series
returnIM <- merge(MSFT.ret,INTC.ret)
head(returnIM)

head(MSFT.ret)
# plot returns
plot(MSFT.ret)
plot(INTC.ret)

plot(coredata(INTC.ret), coredata(MSFT.ret), xlab="INTC", ylab="MSFT",
     type="p", pch=16, lwd=2, col="gray48", main='Returns Scatterplot')
abline(h=0,v=0)

basicStats(MSFT.ret)
basicStats(INTC.ret)

t.test(MSFT.ret)
t.test(INTC.ret)
t.test(rtnb$ge)

mm3 <- skewness(MSFT.ret)/sqrt(6/length(MSFT.ret))
mm3
im3 <- skewness(INTC.ret)/sqrt(6/length(INTC.ret))
im3

kurtosis(MSFT.ret)
tk=kurtosis(MSFT.ret)/sqrt(24/length(MSFT.ret))
tk

kurtosis(INTC.ret)
tk=kurtosis(INTC.ret)/sqrt(24/length(INTC.ret))
tk

d3=density(MSFT.ret)
plot(d3$x,d3$y,xlab='returns',ylab='density',main='MSFT',type='l')
d3=density(INTC.ret)
plot(d3$x,d3$y,xlab='returns',ylab='density',main='INTC',type='l')

acf(MSFT.ret)
acf(INTC.ret)

pacf(MSFT.ret)
pacf(INTC.ret)

Box.test(INTC.ret, type = "Ljung")
Box.test(MSFT.ret, type = "Ljung")
t.test(MSFT.ret)
t.test(INTC.ret)

m1 <- arima(MSFT.ret, order=c(6,0,0))
m1
tsdiag(m1)

msft_m3 <- garchFit(~arma(0,6)+garch(1,1),data=MSFT.ret,trace=F)
summary(msft_m3)
plot(msft_m3)

intc_m3 <- garchFit(~arma(0,1)+garch(1,1),data=INTC.ret,trace=F)
summary(intc_m3)
plot(intc_m3)

msft_m4 <- garchFit(~arma(1,1)+garch(1,1),data=MSFT.ret,trace=F,cond.dist="std")
summary(msft_m4)
plot(msft_m4)

intc_m4 <- garchFit(~arma(0,1)+garch(1,1),data=INTC.ret,trace=F,cond.dist="std")
summary(intc_m4)
plot(intc_m4)

plot( coredata(INTC.ret), coredata(MSFT.ret), xlab="INTC", ylab="MSFT",
      type="p", pch=16, lwd=2, col="gray48", main='Returns Scatterplot')
abline(h=0,v=0)

plot(returnIM$MSFT, main="Log Returns", type="l", xlab="Year", ylab="", col="blue")
lines(returnIM$INTC,col="#6BAED6")
legend(-3.5,-.06,legend=c("Foreign and International Investors","Federal Reserve Banks"),lty=c(1,1), lwd=c(2.5,2.5),col=c("#084594","#6BAED6"))

ccm(returnIM,10)

chart.RollingCorrelation(returnIM$MSFT, returnIM$INTC, width=30)

cor.fun = function(x){
  cor(x)[1,2]
}

cov.fun = function(x){
  cov(x)[1,2]
}

roll.cov <- rollapply(as.zoo(returnIM), FUN=cov.fun, width=20,
                     by.column=FALSE, align="right")
roll.cor <- rollapply(as.zoo(returnIM), FUN=cor.fun, width=20,
                     by.column=FALSE, align="right")
par(mfrow=c(2,1))
plot(roll.cov, main="20-day rolling covariances",
     ylab="covariance", lwd=2, col="blue")
grid()
abline(h=cov(returnIM)[1,2], lwd=2, col="red")
plot(roll.cor, main="20-day rolling correlations",
     ylab="correlation", lwd=2, col="blue")
grid()
abline(h=cor(returnIM)[1,2], lwd=2, col="red")
par(mfrow=c(1,1))

garch11.spec = ugarchspec(mean.model = list(armaOrder = c(0,0)), 
                          variance.model = list(garchOrder = c(1,1), 
                                                model = "sGARCH"), 
                          distribution.model = "norm")

# dcc specification - GARCH(1,1) for conditional correlations
dcc.garch11.spec = dccspec(uspec = multispec( replicate(2, garch11.spec) ), 
                           dccOrder = c(1,1), 
                           distribution = "mvnorm")
dcc.garch11.spec

dcc.fit = dccfit(dcc.garch11.spec, data = returnIM)
class(dcc.fit)
slotNames(dcc.fit)
names(dcc.fit@mfit)
names(dcc.fit@model)

# many extractor functions - see help on DCCfit object
# coef, likelihood, rshape, rskew, fitted, sigma, 
# residuals, plot, infocriteria, rcor, rcov
# show, nisurface

# show dcc fit
dcc.fit

# plot method
plot(dcc.fit)


dcc.fcst = dccforecast(dcc.fit, n.ahead=20)
class(dcc.fcst)
slotNames(dcc.fcst)
class(dcc.fcst@mforecast)
names(dcc.fcst@mforecast)


dcc.fcst

# plot forecasts
dcc.fcst.cov <- rcov(dcc.fcst)
dcc.fcst.cov <- dcc.fcst.cov[[1]]
ts.plot(dcc.fcst.cov[1, 2, ],main = "DCC Conditional Covariance for INTC & MSFT",ylab = "Correlation", xlab = "Time")

# Conditional Correlations
dcc.fcst.cor <- rcor(dcc.fcst)
dcc.fcst.cor <- dcc.fcst.cor[[1]]
ts.plot(dcc.fcst.cor[1, 2, ], main = "DCC Conditional Correlation for INTC & MSFT", ylab = "Correlation", xlab = "Time")

#IMPORT APR
MSFTapr <- read.table("inc/MSFTapr.csv",header=TRUE,sep=",")
INTCapr <- read.table("inc/INTCapr.csv",header=TRUE,sep=",")

colnames(MSFTapr)
head(MSFTapr)
tail(MSFTapr)

# convert to time series, extract adjusted closing prices
MSFTaprts <- xts(MSFTapr$Adj.Close, as.Date(MSFTapr$Date, format='%Y-%m-%d'))
INTCaprts <- xts(INTCapr$Adj.Close, as.Date(INTCapr$Date, format='%Y-%m-%d'))

head(MSFTaprts)
head(INTCaprts)

# plot prices
plot(MSFTaprts, main='Closing Prices, MSFT')
plot(INTCaprts, main='Closing Prices, INTC')

# calculate log-returns for GARCH analysis
MSFT.ret.apr <- CalculateReturns(MSFTaprts, method="log")
INTC.ret.apr <- CalculateReturns(INTCaprts, method="log")

# remove first NA observation
MSFT.ret.apr <- MSFT.ret.apr[-1,]
INTC.ret.apr <- INTC.ret.apr[-1,]
colnames(MSFT.ret.apr) <- "MSFT"
colnames(INTC.ret.apr) <- "INTC"
plot(MSFT.ret.apr)
plot(INTC.ret.apr)
