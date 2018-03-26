library(fBasics)
library(sjPlot)
library(fpp)
library(fUnitRoots)
library(fGarch)
source("garchM.R")
source("Igarch.R")
source("Tgarch11.R")
source("archTest.R")

setwd("C:/Users/00811289/Desktop/413/week6")
msft <- read.table("data/d-msft3dx0113.txt",header=T)
head(msft)
tail(msft)

plot(msft$msft,type='l')
msftlog <- log(msft$msft+1)

#1
#A
plot(msftlog,type='l')
acf(msftlog)
Box.test(msftlog,lag=10,type='Ljung')
t.test(msftlog)

#B
m1 <- arima(msftlog,order=c(0,0,2),include.mean=F)
m1
tsdiag(m1)
Box.test(m1$residuals,lag=10,type='Ljung')
Box.test(m1$residuals^2,lag=10,type='Ljung')
archTest(m1$residuals,10)

#C
m2 <- garchFit(~arma(0,2)+garch(1,1),data=msftlog,trace=F)
summary(m2)
m2 <- garchFit(~arma(0,1)+garch(1,1),data=msftlog,trace=F)
summary(m2)
plot(m2)

#D
m3 <- garchFit(~arma(0,1)+garch(1,1),data=msftlog,trace=F,cond.dist="std")
summary(m3)
plot(m3)

#E
pm3 <- predict(m3,5)
pm3

#2
#A
source("Igarch.R")
m4 <- Igarch(msftlog)
m4
names(m4)

#B
sigma.t <- m4$volatility
resi <- msftlog/sigma.t
acf(resi)

#C
acf(resi^2)
Box.test(resi,lag=10,type='Ljung')
Box.test(resi^2,lag=10,type='Ljung')

pm4 <- predict(m4,4)
pm4

length(msftlog) #3268
v1 <- (1-0.973)*msftlog[3268]^2+.973*sigma.t[3268]^2
sqrt(v1)
msftlog[3268]

#3
#A
da1 <- read.table("data/m-ba3dx6113.txt",header=T)
head(da1)
ba <- log(da1$ba+1)
plot(ba,type='l',main='BA log returns')

t.test(ba)
Box.test(ba,lag=12,type='Ljung')
acf(ba)
at=ba-mean(ba)
Box.test(at^2,lag=12,type='Ljung')
acf(at^2)

#B
n1 <- garchFit(~garch(1,1),data=ba,trace=F)
summary(n1)
plot(n1)

#C
n2 <- garchFit(~garch(1,1),data=ba,trace=F,cond.dist="sstd")
summary(n2)
plot(n2)
tt=(.888-1)/.06
tt
n3=garchM(ba)

#F
source("Tgarch11.R")
n4=Tgarch11(ba)
