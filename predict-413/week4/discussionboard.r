library(fBasics)
library(sjPlot)
library(fpp)
library(backtest)




y <- ts(numeric(100))
e <- rnorm(100)
for(i in 2:100)
y[i] <- 0.6*y[i-1] + e[i]


y1 <- ts(numeric(100))
e <- rnorm(100)
for(i in 2:100)
y1[i] <- 0.7*y1[i-1] + e[i]

y2 <- ts(numeric(100))
e <- rnorm(100)
for(i in 2:100)
y2[i] <- 0.8*y2[i-1] + e[i]


y3 <- ts(numeric(100))
e <- rnorm(100)
for(i in 2:100)
  y3[i] <- 0.9*y3[i-1] + e[i]

y4 <- ts(numeric(100))
e <- rnorm(100)
for(i in 2:100)
  y4[i] <- 1*y4[i-1] + e[i]

plot(y)  #.60
plot(y1) #.70
plot(y2) #.80
plot(y3) #.9
plot(y4) #.10
tsdisplay(y,main = "")  #.60
tsdisplay(y1,main = "") #.70
tsdisplay(y2,main = "") #.80
tsdisplay(y3,main = "") #.90
tsdisplay(y4,main = "") #1.0
