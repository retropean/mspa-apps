### Problem 3 ###
# See Chapter 7 (Exponential Smoothing), Hyndeman text
require(fpp)
library(fpp)
data(package='fpp')
aust<-visitors
head(aust,50)
monthplot(aust)
seasonplot(aust)
plot.ts(aust)
#Multiplicative Method
austtrim <- window(aust,start=2000)
mult <- hw(austtrim,seasonal="multiplicative")
plot(mult,ylab="International visitor night in Australia (millions)",
     type="o", fcol="white", xlab="Year")
lines(fitted(mult), col="red", lty=2)
lines(mult$mean, type="o", col="red")
legend("topleft",lty=1, pch=1, col=1:2, c("Data","Holt Winters' Multiplicative"))
#Multiplcative + Exponential
mult_exp <- hw(austtrim,seasonal="multiplicative",damped=TRUE)
plot(mult_exp,ylab="International visitor night in Australia (millions)",
     type="o", fcol="white", xlab="Year")
lines(fitted(mult_exp), col="red", lty=2)
lines(mult_exp$mean, type="o", col="red")
legend("topleft",lty=1, pch=1, col=1:2, c("Data","Holt Winters' Multiplicative - Damped"))
#Multiplcative + Damped
mult_damp <- hw(austtrim,seasonal="multiplicative",exponential=TRUE)
plot(mult_damp,ylab="International visitor night in Australia (millions)",
     type="o", fcol="white", xlab="Year")
lines(fitted(mult_damp), col="red", lty=2)
lines(mult_damp$mean, type="o", col="red")
legend("topleft",lty=1, pch=1, col=1:2, c("Data","Holt Winters' Multiplicative - Exponential"))
#Multiplcative + Damped + Exponential
mult_exp_damp <- hw(austtrim,seasonal="multiplicative",exponential=TRUE, damped=TRUE)
plot(mult_exp_damp,ylab="International visitor night in Australia (millions)",
     type="o", fcol="white", xlab="Year")
lines(fitted(mult_exp_damp), col="red", lty=2)
lines(mult_exp_damp$mean, type="o", col="red")
legend("topleft",lty=1, pch=1, col=1:2, c("Data","Holt Winters' Multiplicative - Exponential"))
accuracy(mult)
accuracy(mult_exp)
accuracy(mult_damp)
accuracy(mult_exp_damp)
ets_model<-ets(aust, model="ZZZ", damped=NULL, alpha=NULL, beta=NULL,
               gamma=NULL, phi=NULL, additive.only=FALSE, lambda=NULL,
               lower=c(rep(0.0001,3), 0.8), upper=c(rep(0.9999,3),0.98),
               opt.crit=c("lik","amse","mse","sigma","mae"), nmse=3,
               bounds="usual",
               ic=c("aicc","aic","bic"), restrict=TRUE)
ets_forecast<-forecast(ets_model)
plot(ets_forecast)
ets_model_additive<-ets(aust, model="ZZZ", damped=NULL, alpha=NULL, beta=NULL,
                        gamma=NULL, phi=NULL, additive.only=TRUE, lambda=TRUE,
                        lower=c(rep(0.0001,3), 0.8), upper=c(rep(0.9999,3),0.98),
                        opt.crit=c("lik","amse","mse","sigma","mae"), nmse=3,
                        bounds="usual",
                        ic=c("aicc","aic","bic"), restrict=TRUE)
ets_model_additive_forecast<-forecast(ets_model_additive)
plot(ets_model_additive_forecast,xlab="Year")
snaive_model<-snaive(aust, lambda=TRUE)
snaive_model_forecast<-forecast(snaive_model)
plot(snaive_model_forecast,xlab="Year")
stl_model<-stlf(aust, s.window=24, robust=FALSE, method="ets", etsmodel="ZZN", lambda=TRUE)
stl_model_forecast<-forecast(stl_model)
plot(stl_model_forecast)
accuracy(stl_model_forecast)
accuracy(snaive_model_forecast)
accuracy(ets_forecast)
accuracy(ets_model_additive_forecast)


