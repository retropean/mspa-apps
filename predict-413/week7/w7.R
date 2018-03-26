library(fBasics)
library(sjPlot)
library(fpp)
library(fUnitRoots)
library(fGarch)
setwd("C:/Users/00811289/Desktop/413/week7")
source("inc/garchM.R")
source("inc/Igarch.R")
source("inc/Tgarch11.R")
source("inc/archTest.R")

da <- read.table("data/m-ba3dx6113.txt",header=T)
head(da)
tail(da)
sp <- log(da$sprtrn+1)
plot(sp,type='l',main='Log Returns of S&P Composite Index')

acf(sp)
Box.test(sp,lag=10,type='Ljung')
t.test(sp)

#1A
m3 <- garchFit(~garch(1,1),data=sp,trace=F,cond.dist="sstd")
summary(m3)
plot(m3)

#1B
predict(m3,5)

#1C
m4 <- garchFit(~aparch(1,1), data=sp, delta=2, include.delta=F,trace=F,cond.dist="sstd")
summary(m4)
1-pnorm(0.978) #0.1640372

#2A
da <- read.table('data/d-fxjpus0514.txt',header=F)
x2 = 1 + da$V1 
rtn <- log(x2)
plot(rtn,type='l',main="Daily exchange rate between Japanese Yen and U.S. Dollar")
acf(rtn)
t.test(rtn)
Box.test(rtn,lag=10,type='Ljung')

require(fGarch)
m5 <- garchFit(~garch(1,1),data=rtn,trace=F)
summary(m5)
plot(m5)

m7<- garchFit(~garch(1,1),include.mean=F,trace=F,cond.dist="std",leverage=T)
summary(m7)
plot(m7)

#2B
y1 <- rtn*100

m10 <- garchFit(~garch(1,1),data=y1,trace=F,cond.dist="std",leverage=T,include.mean=F)
summary(m10)
plot(m10)
