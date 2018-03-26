library(rattle)

rattle()


setwd("C:/Users/00811289/Desktop/411/wine")
train <- read.csv("C:/Users/00811289/Desktop/411/wine/wine.csv")
train[train==""] <- NA

#https://www.r-bloggers.com/imputing-missing-data-with-r-mice-package/
#Helpful
library(mice)
md.pattern(train) #Look for patterns within the missing data
library(VIM)
aggr_plot <- aggr(train, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(train), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

train_clean<-train
#Fill Sulphates
train_clean$Sulphates_miss <- 0
train_clean$Sulphates_miss[is.na(train$Sulphates)] <- 1
train_clean$Sulphates_imp <- train_clean$Sulphates
train_clean$Sulphates_imp[train_clean$Sulphates_miss==1] <- 0.53

#Fill ResidualSugar
train_clean$ResidualSugar_miss <- 0
train_clean$ResidualSugar_miss[is.na(train$ResidualSugar)] <- 1
train_clean$ResidualSugar_imp <- train_clean$ResidualSugar
train_clean$ResidualSugar_imp[train_clean$ResidualSugar_miss==1] <- 5.56

#Fill Chlorides
train_clean$Chlorides_miss <- 0
train_clean$Chlorides_miss[is.na(train$Chlorides)] <- 1
train_clean$Chlorides_imp <- train_clean$Chlorides
train_clean$Chlorides_imp[train_clean$Chlorides_miss==1] <- 0.058

#Fill FreeSulfurDioxide
train_clean$FreeSulfurDioxide_miss <- 0
train_clean$FreeSulfurDioxide_miss[is.na(train$FreeSulfurDioxide)] <- 1
train_clean$FreeSulfurDioxide_imp <- train_clean$FreeSulfurDioxide
train_clean$FreeSulfurDioxide_imp[train_clean$FreeSulfurDioxide_miss==1] <- 29.9

#Fill TotalSulfurDioxide
train_clean$TotalSulfurDioxide_miss <- 0
train_clean$TotalSulfurDioxide_miss[is.na(train$TotalSulfurDioxide)] <- 1
train_clean$TotalSulfurDioxide_imp <- train_clean$TotalSulfurDioxide
train_clean$TotalSulfurDioxide_imp[train_clean$TotalSulfurDioxide_miss==1] <- 121.5

#Fill pH
train_clean$pH_miss <- 0
train_clean$pH_miss[is.na(train$pH)] <- 1
train_clean$pH_imp <- train_clean$pH
train_clean$pH_imp[train_clean$pH_miss==1] <- 3.202

#Fill Alcohol
train_clean$Alcohol_miss <- 0
train_clean$Alcohol_miss[is.na(train$Alcohol)] <- 1
train_clean$Alcohol_imp <- train_clean$Alcohol
train_clean$Alcohol_imp[train_clean$Alcohol_miss==1] <- 10.45

train_clean$STARS_miss <- 0
train_clean$STARS_miss[is.na(train$STARS)] <- 1
train_clean$STARS_imp <- train_clean$STARS
train_clean$STARS_imp[train_clean$STARS_miss==1] <- 2

train_clean$STARS_imp[train_clean$STARS_miss==1 & train_clean$LabelAppeal < .05 & train_clean$LabelAppeal < -.05] <- 1
train_clean$STARS_imp[train_clean$STARS_miss==1 & train_clean$LabelAppeal < .05 & train_clean$LabelAppeal > -.05] <- 2
train_clean$STARS_imp[train_clean$STARS_miss==1 & train_clean$LabelAppeal > .05 & train_clean$Alcohol_imp < 10 ] <- 2
train_clean$STARS_imp[train_clean$STARS_miss==1 & train_clean$LabelAppeal > .05 & train_clean$Alcohol_imp > 10 ] <- 3

