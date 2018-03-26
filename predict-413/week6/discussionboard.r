ibm <- ibmclose
# Difference the data
ibm <- diff(ibm)
plot(ibm)

# Check mean and subtract mean from non-0 mean to standardize, square
t.test(ibm)
ibm_sq <- ibm^2

acf(ibm_sq)
pacf(ibm_sq)
Box.test(ibm_sq,lag=12,type='Ljung')

m1 <- garchFit(~1+garch(1,1),data=ibm,trace=F)
summary(m1)
