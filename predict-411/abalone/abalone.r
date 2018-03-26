library(rattle)

rattle()


setwd("C:/Users/00811289/Desktop/411/wine")
train <- read.csv("C:/Users/00811289/Desktop/411/abalone/abalone.csv")
train_test<-train
train_test$TARGET_RINGS[train$TARGET_RINGS==0] <- NA

library(mice)
md.pattern(train) #Look for patterns within the missing data
library(VIM)
aggr_plot <- aggr(train, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(train), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))
