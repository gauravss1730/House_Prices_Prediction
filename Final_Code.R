library('scales')
library('ggplot2')
library('dplyr')
library('psych')
library('corrplot')
train<-read.csv('train.csv')
#Dimensions of data
dim(train)
#Column basic description
str(train)
sum(is.na(train))

#Basic overview of the data
summary(train)
#EDA according the given description file 
#Changing NA to relevant values as described in description
#Changing them to chracters
cs<-c("Alley", "FireplaceQu","BsmtQual","BsmtCond","BsmtExposure", "BsmtFinType1",
      "BsmtFinType2", "GarageType", "GarageFinish", "GarageQual","GarageCond",
      "PoolQC", "Fence","MiscFeature")

train[cs]<-lapply(train[cs], as.character, stringsAsFactors=FALSE)
#Changing NA values to relevant values 
train$Alley[is.na(train$Alley)] <-"No Access"
train$FireplaceQu[is.na(train$FireplaceQu)] <-"No Fireplace"
train$BsmtQual[is.na(train$BsmtQual)]<-"No~Basement"
train$BsmtCond[is.na(train$BsmtCond)]<-"NoBasement"
train$BsmtExposure[is.na(train$BsmtExposure)]<-"NoBasement"
train$BsmtFinType1[is.na(train$BsmtFinType1)]<-"No-Basement"
train$BsmtFinType2[is.na(train$BsmtFinType2)]<-"No_Basement"
train$GarageType[is.na(train$GarageType)]<-"NoGarage"
train$GarageFinish[is.na(train$GarageFinish)]<-"No-Garage"
train$GarageQual[is.na(train$GarageQual)]<-"No_Garage"
train$GarageCond[is.na(train$GarageCond)]<-"No~Garage"
train$PoolQC[is.na(train$PoolQC)]<-"No Pool"
train$Fence[is.na(train$Fence)]<-"No Fence"
train$MiscFeature[is.na(train$MiscFeature)]<-"None"
#Now reverting the column back
revs<-c("Alley", "FireplaceQu","BsmtQual","BsmtCond","BsmtExposure", "BsmtFinType1",
        "BsmtFinType2", "GarageType", "GarageFinish", "GarageQual","GarageCond",
        "PoolQC", "Fence","MiscFeature")

train[revs]<-lapply(train[revs], as.factor)

summary(train)

#PoolQC, Central AIr are irrelevant
#Visualization
ggplot(train, aes(x=train$SalePrice))+geom_histogram(binwidth=100000,color='black',fill='maroon')+
  xlab('Sale Price')+ylab('Count')


ggplot(train,aes(x=train$SalePrice, y=train$OverallQual))+geom_point(color='blue')+
  xlab('Sale Price')+ylab('Overall Quality')+ scale_x_continuous(labels = comma)

#This shows quality above 8 houses were sold at very high prices.

#Quality and Sale Price (Prices that are above average)
summary(train$OverallQual)
a<-train[which(train[,81]>180000),]
ggplot(a,aes(x=a$SalePrice, y=a$OverallQual))+geom_point(aes(x=a$SalePrice), color='maroon')+
  xlab('Sale Price')+ylab('Overall Quality') + scale_x_continuous(labels = comma)
#Quality and Sale Price (Houses with the highest prices)
b<-train[which(train[,81]>500000),]
ggplot(b,aes(x=b$SalePrice, y=b$OverallQual))+geom_point(aes(x=b$SalePrice), color='blue')+
  xlab('Sale Price')+ylab('Overall Quality')+scale_x_continuous(labels = comma)
#Visualising overall Condition 
describe(train$OverallCond)
a1<-table(train$OverallCond)
table(train$OverallCond)
plot(a1)
 ggplot(train, aes(x=train$SalePrice, y=factor(train$OverallCond)))+geom_point(color='blue', fill='red')+
  xlab('Sale Price')+ylab('Overall Condition')+scale_x_continuous(labels = comma)
#In the data set no of houses havig Overalll quality 5 were abundant.
#This shows that the houses having Overall quality to be 5 sold in high prices. 
ggplot(train,aes(x=train$SaleType,y=train$SalePrice))+
  geom_histogram(stat = 'identity', color='maroon')+
  ylab('Sale Price (Sum)')+xlab('Sales Type') + scale_y_continuous(labels = comma)
#WD sale type contributes highest significance in price determination.
#Neighbourhood
#Number of house with each neighborhood
ggplot(train,aes(x=train$Neighborhood))+geom_bar(color='blue', fill='maroon')+
  xlab('Neighbourhood')+ylab('Count')
#Their influence in sale prices
ggplot(train,aes(x=train$Neighborhood, y=train$SalePrice))+
 geom_histogram(stat = 'identity', fill='blue')+xlab('Neighbourhood')+ylab('Sale Price (Sum)')+
  scale_y_continuous(labels = comma)
  

#Removing NA Values
train1<-na.omit(train)
#Correlation Matrix
num.V<-cor(select_if(train1, is.numeric))
write.csv(num.V, file="TABLEAU.csv")
corrplot(num.V)
#Now removing irrelevant columns to perform the Regression.
names(train1)
train2<-train1[,c(-1,-2,-10,-22,-24,-29,-37,-56,-59,-61,-64,-65,-68,-69,-70,-71,-72,-73,-74,-75,-76,-77,-78)]

#EDA on TEST data set
test<-read.csv('test.csv')
test1<-test
test1[cs]<-lapply(test1[cs], as.character, stringsAsFactors=FALSE)
#Changing NA values to relevant values 
test1$Alley[is.na(test1$Alley)] <-"No Access"
test1$FireplaceQu[is.na(test1$FireplaceQu)] <-"No Fireplace"
test1$BsmtQual[is.na(test1$BsmtQual)]<-"No~Basement"
test1$BsmtCond[is.na(test1$BsmtCond)]<-"NoBasement"
test1$BsmtExposure[is.na(test1$BsmtExposure)]<-"NoBasement"
test1$BsmtFinType1[is.na(test1$BsmtFinType1)]<-"No-Basement"
test1$BsmtFinType2[is.na(test1$BsmtFinType2)]<-"No_Basement"
test1$GarageType[is.na(test1$GarageType)]<-"NoGarage"
test1$GarageFinish[is.na(test1$GarageFinish)]<-"No-Garage"
test1$GarageQual[is.na(test1$GarageQual)]<-"No_Garage"
test1$GarageCond[is.na(test1$GarageCond)]<-"No~Garage"
test1$PoolQC[is.na(test1$PoolQC)]<-"No Pool"
test1$Fence[is.na(test1$Fence)]<-"No Fence"
test1$MiscFeature[is.na(test1$MiscFeature)]<-"None"

test1[revs]<-lapply(test1[revs], as.factor)
test1<-test1[,c(-1,-2,-10,-22,-24,-29,-37,-56,-59,-61,-64,-65,-68,-69,-70,-71,-72,-73,-74,-75,-76,-77,-78)]
#Training model
Reg<-lm(SalePrice~., data=train2)
summary(Reg)
#Prediction
SP<-predict(Reg, newdata = test1)
View(SP)
d<-data.frame(test$Id,SP)
write.csv(d,file='Prediction.csv')
###DECISION TRESS
#TRAINING THE MODEL
m3 <- rpart(
  formula = SalePrice ~ .,
  data    = train2,
  method  = "anova",)
printcp(m3) # display the results
plotcp(m3) # visualize cross-validation results
summary(m3) # detailed summary of splits 
plot(m3, uniform=TRUE,
     main="Classification Tree for sales prices")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

pfit<- prune(m3, cp=   m3$cptable[which.min(m3$cptable[,"xerror"]),"CP"])
plot(pfit)
#PREDICTION
P<-predict(pfit, newdata = test1)
c<-data.frame(test$Id,P)
write.csv(c, file="Prediction 2.csv")
