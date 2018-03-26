### Problem 1 ###
library(fBasics)
library(fpp)
library(sjPlot)
setwd("C:/Users/00811289/Desktop/413")
ge=read.table("m-ge3dx8113.txt",header=T)

ge_stats<-basicStats(ge)
ge_stats<- subset(ge_stats,select = c(ge,vwretd,ewretd,sprtrn))
sjt.df(basicStats(ge_stats))

ge_log=log(ge[,3:6]+1)
ge_stats<-basicStats(ge_log)
ge_stats<- subset(ge_stats,select = c(ge,vwretd,ewretd,sprtrn))
sjt.df(basicStats(ge_stats))

t.test(ge_log$ge)

d1=density(ge_log$ge)
d2=density(ge_log$sprtrn)
par(mfcol=c(1,2))
plot(d1$x,d1$y,xlab='returns',ylab='density',main='GE',type='l')
plot(d2$x,d2$y,xlab='returns',ylab='density',main='SP',type='l')

### Problem 2 ###

nflx<-read.table("d-nflx3dx0913.txt",header=T)
nflx_log=log(nflx[,3:6]+1)
nflx_log_return<-nflx_log$nflx
tm3=skewness(nflx_log_return)/sqrt(6/length(nflx_log_return))
tm3
tk=kurtosis(nflx_log_return)/sqrt(24/length(nflx_log_return))
tk
t.test(nflx_log_return)

### Problem 3 ###

ukcars<-ukcars
ukcarstrim <- window(ukcars,start=1997)
plot(ukcarstrim,ylab="Vehicles",xlab="Year",main="UK Passenger Vehicle Production")

plot(stl(ukcarstrim, s.window=5),main="UK Passenger Vehicle Production Seasonal Decomposition ")
monthplot(ukcarstrim)

# C
ukcars_stl<-stl(ukcarstrim, s.window="periodic")
ukcars_sadj<-seasadj(ukcars_stl)


head(ukcars_stl)
#ukcars_seasonal <- ukcars_stl$time.series[30:33,"seasonal"]

plot(ukcars_sadj)

additive_damped_fit <- holt(ukcars_sadj, damped=TRUE, h=8, opt.crit=c("lik","amse","mse","sigma","mae")) 
plot(additive_damped_fit)
ukcars_reseason <- forecast(ukcars_stl, method="naive")
plot(ukcars_reseason)
#ukcars_reseason <- additive_damped_fit$mean+ukcars_seasonal
#plot(ukcars_reseason)

summary(additive_damped_fit)
summary(ukcars_reseason)
accuracy(ukcars_reseason)


# D
ukcars_stl<-stl(ukcarstrim, s.window="periodic")
ukcars_sadj<-seasadj(ukcars_stl)
plot(ukcars_sadj)

holt_fit <- holt(ukcars_sadj, h=8) 
plot(holt_fit)
ukcars_holt_reseason <- forecast(ukcars_stl, method="naive")
plot(ukcars_holt_reseason)

summary(holt_fit)
summary(ukcars_holt_reseason)
accuracy(ukcars_holt_reseason)

# E
ukcars_ets_model<-ets(ukcarstrim, model="ZZZ")
ukcars_ets_model_forecast<-forecast(ukcars_ets_model)
plot(ukcars_ets_model_forecast)

summary(ukcars_ets_model_forecast)
accuracy(ukcars_ets_model_forecast)


fit <- stl(elecequip, t.window=15, s.window="periodic", robust=TRUE)
plot(fit)
fcast <- forecast(fit, method="naive")
plot(fcast, ylab="New orders index")
