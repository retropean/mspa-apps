library(fBasics)
library(sjPlot)
library(fpp)
library(fUnitRoots)
source("backtest.R")
setwd("C:/Users/00811289/Desktop/413/week4")

# Section 1

employ <- read.table("m-unempmean.txt",header=T)
head(employ)

# Plot EDA
employ.ts <- ts(employ$Value, start=c(1948,1),end=c(2014,3), frequency=12)
plot(employ.ts, main="Duration of Unemployment in the U.S.", xlab="Year", ylab="Unemployment")
monthplot(employ.ts)
plot(stl(employ.ts, s.window="periodic"))

# Unit Root Test
adf.test(employ.ts, alternative = "stationary")
adfTest(employ.ts,lags=12,type="c")
kpss.test(employ.ts)
tsdisplay(employ.ts,main="Time Series Display for Duration of Unemployment in the U.S.")

# Difference data
demploy <- diff(employ.ts)

# Test stationarity
tsdisplay(demploy,main="Differenced Time Series Display for data")
t.test(demploy)

# Create/Diagnose AR model
model1 <- arima(demploy,order=c(12,0,0),include.mean=FALSE)
model1
tsdiag(model1,gof=24)

# Create a seasonal model
model2 <- arima(demploy,order=c(2,0,1),seasonal=list(order=c(1,0,1),period=12),include.mean=FALSE)
model2
tsdiag(model2,gof=24)

accuracy(model1)
accuracy(model2)

backtest(model1,demploy,750,1,inc.mean=F)
backtest(model2,demploy,750,1,inc.mean=F)

# Section 2
coil <- read.table("w-coilwtico.txt",header=T)
head(coil)
tail(coil)
plot(coil$Value)

# Plot EDA
coil.ts <- ts(coil$Value, start=c(1986,1), frequency=52)
plot(coil.ts, main="Weekly Crude Oil Prices", xlab="Year", ylab="Prices")
plot(stl(coil.ts, s.window="periodic"))
tsdisplay(coil.ts,main="Time Series Display for Weekly Crude Oil Prices")

# Convert to first difference of log oil prices
dlcoil <- diff(log(coil.ts))
plot(dlcoil,type='l')
tsdisplay(dlcoil,main="Time Series Display for Weekly Crude Oil Prices")

# Check serial correlation
Box.test(dlcoil,lag=10,type='Ljung')

# Check order and create ARIMA model
coil_model1 <- ar(dlcoil, method="mle")
coil_model1$order #11

coil_model2 <- arima(dlcoil,order=c(11,0,0))
coil_model2

tsdiag(coil_model2, gof=20)
Box.test(residuals(coil_model2),type='Ljung')

# Create ARIMA(3,0,2) model
coil_model3 <- arima(rtn,order=c(3,0,2),include.mean=FALSE)
coil_model3
tsdiag(coil_model3,gof=20)
Box.test(residuals(coil_model3),type='Ljung')

# Compare fit between the models
accuracy(coil_model2)
accuracy(coil_model3)