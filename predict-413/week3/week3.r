library(fBasics)
library(sjPlot)
library(fpp)
library(backtest)
setwd("C:/Users/00811289/Desktop/413/week3")
umc<-read.table("m-umcsent.txt",header=T)
head(umc)
tail(umc)

umc.ts <- ts(umc$VALUE, start=c(1978,1),end=c(2013,8), frequency=12)
plot(umc.ts, main="Consumer Sentiment of the University of Michigan", xlab="Year", ylab="Consumer Sentiment")
monthplot(umc.ts)
plot(stl(umc.ts, s.window="periodic"))

tsdisplay(umc.ts,main = "")
adf.test(umc.ts, alternative = "stationary")
kpss.test(umc.ts)

dumc.ts <- diff(umc.ts)
tsdisplay(dumc.ts,main="")

t.test(dumc.ts)
Box.test(dumc.ts,lag=12,type='Ljung')

#part 2
ar(dumc.ts, method = "mle")
acf(dumc.ts)
m2 <- Arima(dumc.ts, order=c(5,0,0), include.mean=F)
m2

tsdiag(m2)
plot(forecast(m2,h=10),include=80)

p1=c(1,-m2$coef)
r1=polyroot(p1)
r1


m2p=predict(m2,4)### prediction 1 to 4-step ahead
print(m2p)

lcl=m2p$pred-1.96*m2p$se
lcl
ucl=m2p$pred+1.96*m2p$se
ucl

#part 3
modelse<-sqrt(diag(vcov(m2)))
modeltratio<-abs(m2$coef/modelse)
print(modeltratio)

c1=c(0,NA,NA,0,NA)
m3=arima(dumc.ts,order=c(5,0,0),include.mean=FALSE,fixed=c1)
print(m3)

tsdiag(m3,gof=24)  ### Model checking
Box.test(residuals(m3),lag=12,type='Ljung')

accuracy(m3)
accuracy(m2)

p2=c(1,-m3$coef)
s2=polyroot(p2)
s2
backtest(m2,chg,380,1,inc.mean=FALSE)
help(backtest)
??backtest





