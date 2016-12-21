(365/365)*(1/365)
1*(1/365)*(2/365)*(3/365)*(4/365)*(5/365)
dbinom(1, size=5, prob=0.2739726)

pbinom(4, size=365, prob=0.2739726, lower.tail = TRUE)

1-pbinom(2, size=5, prob=0.002739726, lower.tail = TRUE)
1-((1/365)*(1/365)*(1/365)*(1/365)*(1/365)*365*364*363*362*361)

#one day
1-(1*(364/365))

#factorial(365)
1-(prod(365:(365+1-5))*(1/365)**5)
1-(prod(365:(365+1-10))*(1/365)**10)


#23 people need to be in the class
1-(prod(365:(365+1-23))*(1/365)**23)
#x<-seq(1,100,1)
curve((1-(prod(365:(366-x))*(1/365)**x)),n=100, from=2, to=100,add=T)
#curve((1-(factorial(365)-factorial(365+1-x))*(1/365)**x), n=100, from=2, to=100)
#warnings()


#probability of same birthday of teacher is 
1-((364)/365)**253
help(log)
log(.5,base=0.9972603)
curve((1-((364)/365)**x),n=100, from=2, to=600)
abline(h=.5,v=253,col=2)

curve(log(x,base=0.9972603))

1-(364/365)

prod(365:(366-3))*
  log(.5,base=0.002739726)
