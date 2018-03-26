setwd("C:/Users/00811289/Desktop/insurance")
train <- read.csv("C:/Users/00811289/Desktop/insurance/logit_insurance.csv")
train_complete <- train[complete.cases(train),]
install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')
install.packages('randomForest')
install.packages('party')
library(party)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(randomForest)

convertCurrency <- function(currency) {
  currency1 <- sub('$','',as.character(currency),fixed=TRUE)
  currency2 <- as.numeric(gsub('\\,','',as.character(currency1))) 
  currency2
}
train_complete$INCOME <- convertCurrency(train_complete$INCOME)
train_complete$HOME_VAL <- convertCurrency(train_complete$HOME_VAL)
train_complete$BLUEBOOK <- convertCurrency(train_complete$BLUEBOOK)
#FOR JOB
#Remove #NA
summary(train_complete$JOB)
train_complete[train_complete==""] <- NA
train_complete <- na.omit(train_complete)
#Create Tree
tree.1 <- rpart(JOB~EDUCATION+YOJ+CAR_USE+AGE+INCOME,data=train_complete,method="class",control=rpart.control(minsplit=30,cp=0.0001,maxsurrogate=0,maxdepth=5))
printcp(tree.1)
print(tree.1)
plot(tree.1)
text(tree.1, cex = 0.5)
fancyRpartPlot(tree.1, tweak=1.5,nn.cex=.1, gap=3, under.cex=1, compress=TRUE, ycompress=TRUE, shadow=0)
#Prune Tree
tree.pruned<-prune(tree.1, cp=0.00218866)
fancyRpartPlot(tree.pruned, tweak=1.5,nn.cex=.8, gap=3, under.cex=1, compress=TRUE, ycompress=TRUE, shadow=0)

#CAR AGE TREE
summary(train_complete$CAR_AGE)
car_age_tree <- rpart(CAR_AGE~CAR_USE+YOJ+TIF+BLUEBOOK+INCOME,data=train_complete,method="anova",control=rpart.control(minsplit=30,cp=0.0001,maxsurrogate=0,maxdepth=5))
printcp(car_age_tree)
print(car_age_tree)
plot(car_age_tree)
text(car_age_tree, cex = 0.5)
fancyRpartPlot(car_age_tree, tweak=1.5,nn.cex=.1, gap=3, under.cex=1, compress=TRUE, ycompress=TRUE, shadow=0)
printcp(car_age_tree)
car.tree.pruned<-prune(car_age_tree, cp= 0.00774443)
fancyRpartPlot(car.tree.pruned, tweak=1.5,nn.cex=.1, gap=5, under.cex=1, compress=TRUE, ycompress=TRUE, shadow=0)