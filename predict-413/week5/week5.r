library(fBasics)
library(sjPlot)
library(fpp)
library(fUnitRoots)
source("backtest.R")
setwd("C:/Users/00811289/Desktop/413/week5")

# Section 1

fama <- read.table("data/m-FamaFrench.txt",header=T)
head(fama)
fama.ts <- ts(fama$hml, start=c(1961,1), frequency=12)

plot(fama.ts, main="Fama-French factors", xlab="Year", ylab="hml")
acf(fama.ts)

m1 <- arima(fama.ts,order=c(0,0,1))
m1

tsdiag(m1)
Box.test(residuals(m1),type='Ljung')
help(predict)
pm1 <- predict(m1,2)
print(pm1)
lcl <- pm1$pred-1.96*pm1$se
print(lcl)
ucl <- pm1$pred+1.96*pm1$se
print(ucl)

# Section 2

pastor <- read.table("data/m-PastorStambaugh.txt",header=T)
head(pastor)
tail(pastor)

pslvl <- ts(pastor$PS_LEVEL, start=c(1962,8), frequency=12)

plot(pslvl, main="Monthly Market Liquidity Measure of Professors Pastor and Stambaugh", xlab="Year", ylab="Liquidity")
acf(pslvl)

m2 <- arima(pslvl,order=c(5,0,0))
print(m2)

tsdiag(m2)

which.min(m2$residuals) #303
m2$residuals[303] #-.4462932
#m2$residuals[441]
#help(which.max)
dim(pastor) #605

i303 <- rep(0,605)
i303[303] <- 1

m3 <- arima(pslvl,order=c(5,0,0),xreg=i303)
m3
tsdiag(m3)

modelse <- sqrt(diag(vcov(m3)))
modeltratio <- abs(m3$coef/modelse)
print(modeltratio)

c1 <- c(NA,NA,NA,0,NA,NA,NA)
m3 <- arima(pslvl,order=c(5,0,0),xreg=i303,fixed=c1)
m3
tsdiag(m3)

# Section 3

microsoft <- read.table("data/q-earn-msft.txt",header=T)
head(microsoft)

microval <- ts(microsoft$value, start=c(1986,2), frequency=4)

plot(microval, main="Microsoft Earnings Per Share", xlab="Year", ylab="EPS")
acf(microval)
log_microval <- log(microval)

plot(log_microval, main="Log Microsoft Earnings Per Share", xlab="Year", ylab="EPS")

m4 <- arima(log_microval,order=c(0,1,1),seasonal=list(order=c(0,1,1),period=4))
m4
tsdiag(m4,gof=20)

m5 <- arima(log_microval,order=c(0,1,1),seasonal=list(order=c(0,0,1),period=4))
m5
tsdiag(m5,gof=20)

backtest(m4,log_microval,81,1)
backtest(m5,log_microval,81,1)

# Section 4

fbliss <- read.table("data/m-FamaBlissdbndyields.txt",header=T)
head(fbliss)
fbliss <- ts(fbliss$value, start=c(1961,1), frequency=12)

y1t <- ts(fbliss$yield1, start=c(1961,1), frequency=12)
y3t <- ts(fbliss$yield3, start=c(1961,1), frequency=12)
plot(y1t, main="Fama-Bliss bond yields", type="l", xlab="Year", ylab="Yield",col="#084594")
lines(y3t,col="#6BAED6" )

m6 <- lm(y3t~y1t)

print(m6)
summary(m6)
acf(m6$residuals)

d1t <- diff(y1t)
d3t <- diff(y3t)
m7 <- lm(d3t~-1+d1t)

print(m7)
summary(m7)
acf(m7$residuals)
pacf(m7$residuals)

m8 <- ar(m7$residuals, method="mle")
m8$order

m9 <- arima(d3t, order=c(5,0,0), xreg=d1t, include.mean=FALSE)
m9
tsdiag(m9,gof=24)

c1 <- c(NA,NA,0,NA,NA,NA)
m10 <- arima(d3t,order=c(5,0,0),xreg=d1t,include.mean=F,fixed=c1)
m10
tsdiag(m10,gof=24) 

# Section 5

m11 <- arima(y3t, order=c(6,0,0), xreg=y1t)
print(m11)
tsdiag(m11,gof=24)

c2 <- c(NA,0,NA,NA,0,NA,NA,NA)
m12 <- arima(y3t,order=c(6,0,0),xreg=y1t,fixed=c2)
m12
tsdiag(m12,gof=24)

p1 <- c(1,-m12$coef[1:6])
s1 <- polyroot(p1)
s1

Mod(s1)
1/Mod(s1)
