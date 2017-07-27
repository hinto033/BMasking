#####
# Installs necessary packages to do the analysis
install.packages("R.matlab")
install.packages("ROCR")
install.packages("dplyr")
install.packages("e1071")
install.packages("ICC")
install.packages("lattice")
install.packages("psych")
install.packages("gdata")
install.packages("PredictABEL")
require("R.matlab")
require("ROCR")
require("dplyr")
require("e1071")
require("ICC")
require("lattice")
require("psych")
require("gdata")
require("PredictABEL")
#####
#Defines the dataset that I'll analyze
#Similar patches by mean/stdev

dateOfAnalysis = "7.13.17"
# savePath = "D:\\LabData\\BreastMasking\\FinalAnalysisImages\\"
savePath = "W:\\Breast Studies\\Masking\\AnalysisImages\\"

#Similar By Statistics
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_Simulated\\"
wdAll <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\6.20.17_CompiledData_Simulated\\"
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_SimilarStat\\"
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_SimilarLoc\\"

keepNoVar <- c('Interval',  'density', 'age', 'bmi', 'race','X_menopause_', 'X_firstdeg_','biop_hist')
# keepNoVar <- c('Interval',  'density', 'age', 'bmi', 'X_menopause_', 'X_firstdeg_','biop_hist')


##### 
# Imports the dataset of the interval and screen detected cancers and places them in two tables
setwd(wdAll)
fileNames <- list.files(wdAll)
nRows <- length(fileNames)
allData <- data.frame(num=1:nRows)
for (i in 1:nRows){
  imageStats <- readMat(fileNames[i])
  
  allData$fileName[i] <- fileNames[i]
  allData$tmp[i] <- strsplit(fileNames[i], '_')[[1]][2]
  allData$acquisition_id[i] <- strsplit(allData$tmp[i], '[.]')[[1]][1]
  allData$view[i] <- imageStats$stats[,,1]$DICOMData[,,1]$Position[1,1]
  allData$Interval <- NA
  allData$ScreenDetected <- NA
  allData$largeMean[i] <- imageStats$stats[,,1]$Large[,,1]$Mean[1,1]
  allData$largeMedian[i] <- imageStats$stats[,,1]$Large[,,1]$Median[1,1]
  allData$largeStDev[i] <- imageStats$stats[,,1]$Large[,,1]$StDev[1,1]
  allData$largeSum[i] <- imageStats$stats[,,1]$Large[,,1]$Sum[1,1]
  allData$largeEntropy[i] <- imageStats$stats[,,1]$Large[,,1]$Entropy[1,1]
  allData$largeKurtosis[i] <- imageStats$stats[,,1]$Large[,,1]$Kurtosis[1,1]
  allData$largeSkewness[i] <- imageStats$stats[,,1]$Large[,,1]$Skewness[1,1]
  allData$largePctile10[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile10[1,1]
  allData$largePctile25[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile25[1,1]
  allData$largePctile75[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile75[1,1]
  allData$largePctile90[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile90[1,1]
  allData$largePctBelowPnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelowPnt5[1,1]
  allData$largePctBelow1[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1[1,1]
  allData$largePctBelow1Pnt25[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt25[1,1]
  allData$largePctBelow1Pnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt5[1,1]
  allData$largePctBelow2[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow2[1,1]
  allData$largePctBelow3[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow3[1,1]
  allData$largePctBelow4[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow4[1,1]
  allData$largePctBelow5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow5[1,1]
  allData$largePctBelow7[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow7[1,1]
  allData$largePctBelow10[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow10[1,1]
  allData$largePctBelow12[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow12[1,1]
  allData$largePctBelow14[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow14[1,1]
  allData$largePctBelow16[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow16[1,1]
  allData$largePctBelow18[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow18[1,1]
  allData$largePctBelow20[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow20[1,1]
  allData$largeGLCMContrast[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMContrast[1,1]
  allData$largeGLCMCorr[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMCorr[1,1]
  allData$largeGLCMEnergy[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMEnergy[1,1]
  allData$largeGLCMHomog[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMHomog[1,1]
  
  allData$mediumMean[i] <- imageStats$stats[,,1]$Medium[,,1]$Mean[1,1]
  allData$mediumMedian[i] <- imageStats$stats[,,1]$Medium[,,1]$Median[1,1]
  allData$mediumStDev[i] <- imageStats$stats[,,1]$Medium[,,1]$StDev[1,1]
  allData$mediumSum[i] <- imageStats$stats[,,1]$Medium[,,1]$Sum[1,1]
  allData$mediumEntropy[i] <- imageStats$stats[,,1]$Medium[,,1]$Entropy[1,1]
  allData$mediumKurtosis[i] <- imageStats$stats[,,1]$Medium[,,1]$Kurtosis[1,1]
  allData$mediumSkewness[i] <- imageStats$stats[,,1]$Medium[,,1]$Skewness[1,1]
  allData$mediumPctile10[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile10[1,1]
  allData$mediumPctile25[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile25[1,1]
  allData$mediumPctile75[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile75[1,1]
  allData$mediumPctile90[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile90[1,1]
  allData$mediumPctBelowPnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelowPnt5[1,1]
  allData$mediumPctBelow1[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1[1,1]
  allData$mediumPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt25[1,1]
  allData$mediumPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt5[1,1]
  allData$mediumPctBelow2[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow2[1,1]
  allData$mediumPctBelow3[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow3[1,1]
  allData$mediumPctBelow4[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow4[1,1]
  allData$mediumPctBelow5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow5[1,1]
  allData$mediumPctBelow7[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow7[1,1]
  allData$mediumPctBelow10[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow10[1,1]
  allData$mediumPctBelow12[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow12[1,1]
  allData$mediumPctBelow14[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow14[1,1]
  allData$mediumPctBelow16[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow16[1,1]
  allData$mediumPctBelow18[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow18[1,1]
  allData$mediumPctBelow20[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow20[1,1]
  allData$mediumGLCMContrast[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMContrast[1,1]
  allData$mediumGLCMCorr[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMCorr[1,1]
  allData$mediumGLCMEnergy[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMEnergy[1,1]
  allData$mediumGLCMHomog[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMHomog[1,1]
  
  allData$smallMean[i] <- imageStats$stats[,,1]$Small[,,1]$Mean[1,1]
  allData$smallMedian[i] <- imageStats$stats[,,1]$Small[,,1]$Median[1,1]
  allData$smallStDev[i] <- imageStats$stats[,,1]$Small[,,1]$StDev[1,1]
  allData$smallSum[i] <- imageStats$stats[,,1]$Small[,,1]$Sum[1,1]
  allData$smallEntropy[i] <- imageStats$stats[,,1]$Small[,,1]$Entropy[1,1]
  allData$smallKurtosis[i] <- imageStats$stats[,,1]$Small[,,1]$Kurtosis[1,1]
  allData$smallSkewness[i] <- imageStats$stats[,,1]$Small[,,1]$Skewness[1,1]
  allData$smallPctile10[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile10[1,1]
  allData$smallPctile25[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile25[1,1]
  allData$smallPctile75[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile75[1,1]
  allData$smallPctile90[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile90[1,1]
  allData$smallPctBelowPnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelowPnt5[1,1]
  allData$smallPctBelow1[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1[1,1]
  allData$smallPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt25[1,1]
  allData$smallPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt5[1,1]
  allData$smallPctBelow2[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow2[1,1]
  allData$smallPctBelow3[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow3[1,1]
  allData$smallPctBelow4[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow4[1,1]
  allData$smallPctBelow5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow5[1,1]
  allData$smallPctBelow7[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow7[1,1]
  allData$smallPctBelow10[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow10[1,1]
  allData$smallPctBelow12[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow12[1,1]
  allData$smallPctBelow14[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow14[1,1]
  allData$smallPctBelow16[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow16[1,1]
  allData$smallPctBelow18[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow18[1,1]
  allData$smallPctBelow20[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow20[1,1]
  allData$smallGLCMContrast[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMContrast[1,1]
  allData$smallGLCMCorr[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMCorr[1,1]
  allData$smallGLCMEnergy[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMEnergy[1,1]
  allData$smallGLCMHomog[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMHomog[1,1]
  
  # 
  allData$fullMean[i] <- imageStats$stats[,,1]$Full[,,1]$Mean[1,1]
  allData$fullMedian[i] <- imageStats$stats[,,1]$Full[,,1]$Median[1,1]
  allData$fullStDev[i] <- imageStats$stats[,,1]$Full[,,1]$StDev[1,1]
  allData$fullSum[i] <- imageStats$stats[,,1]$Full[,,1]$Sum[1,1]
  allData$fullEntropy[i] <- imageStats$stats[,,1]$Full[,,1]$Entropy[1,1]
  allData$fullKurtosis[i] <- imageStats$stats[,,1]$Full[,,1]$Kurtosis[1,1]
  allData$fullSkewness[i] <- imageStats$stats[,,1]$Full[,,1]$Skewness[1,1]
  allData$fullPctile10[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile10[1,1]
  allData$fullPctile25[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile25[1,1]
  allData$fullPctile75[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile75[1,1]
  allData$fullPctile90[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile90[1,1]
  allData$fullPctBelowPnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelowPnt5[1,1]
  allData$fullPctBelow1[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1[1,1]
  allData$fullPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt25[1,1]
  allData$fullPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt5[1,1]
  allData$fullPctBelow2[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow2[1,1]
  allData$fullPctBelow3[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow3[1,1]
  allData$fullPctBelow4[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow4[1,1]
  allData$fullPctBelow5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow5[1,1]
  allData$fullPctBelow7[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow7[1,1]
  allData$fullPctBelow10[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow10[1,1]
  allData$fullPctBelow12[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow12[1,1]
  allData$fullPctBelow14[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow14[1,1]
  allData$fullPctBelow16[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow16[1,1]
  allData$fullPctBelow18[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow18[1,1]
  allData$fullPctBelow20[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow20[1,1]
  allData$fullGLCMContrast[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMContrast[1,1]
  allData$fullGLCMCorr[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMCorr[1,1]
  allData$fullGLCMEnergy[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMEnergy[1,1]
  allData$fullGLCMHomog[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMHomog[1,1]
  # 
  # 
  allData$imgBMean[i] <- imageStats$stats[,,1]$imgB[,,1]$Mean[1,1]
  allData$imgBMedian[i] <- imageStats$stats[,,1]$imgB[,,1]$Median[1,1]
  allData$imgBSum[i] <- imageStats$stats[,,1]$imgB[,,1]$Sum[1,1]
  allData$imgBPctile10[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile10[1,1]
  allData$imgBPctile25[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile25[1,1]
  allData$imgBPctile75[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile75[1,1]
  allData$imgBPctile90[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile90[1,1]
  allData$imgAMean[i] <- imageStats$stats[,,1]$imgA[,,1]$Mean[1,1]
  allData$imgAMedian[i] <- imageStats$stats[,,1]$imgA[,,1]$Median[1,1]
  allData$imgASum[i] <- imageStats$stats[,,1]$imgA[,,1]$Sum[1,1]
  allData$imgAPctile10[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile10[1,1]
  allData$imgAPctile25[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile25[1,1]
  allData$imgAPctile75[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile75[1,1]
  allData$imgAPctile90[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile90[1,1]
}


print("DONE")
#####



# Combines data and merges with Demographic/Density Information#####
#Adds Data from Demographic Indicators
# wdDemog = "D:\\LabData\\BreastMasking\\"
wdDemog = "W:\\Breast Studies\\Masking\\"
fileName<-'masking_matched.csv'
demogData <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

#merge the SXA and the Masking Datasets
mergedData <- merge(allData, demogData, by='acquisition_id')
#Shuffles for a random result
mergedData<-mergedData[sample(nrow(mergedData)),]


#Ensures equal Numbers of Int/Scd and Splits CC/MLO#####



mergedData$Interval[mergedData$group=="FN"] <- 1
mergedData$ScreenDetected[mergedData$group=="FN"] <- 0

mergedData$Interval[mergedData$group=="TP"] <- 0
mergedData$ScreenDetected[mergedData$group=="TP"] <- 1


#Split by int/nonInt
splitMerged <- split(mergedData, mergedData$Interval)
dataInt <- splitMerged$`1`
dataScreen <- splitMerged$`0`


#Generate Data of all relevant information #####

table(dataInt$race)
table(dataScreen$race)

table(dataInt$X_firstdeg_)
table(dataScreen$X_firstdeg_)

table(dataInt$X_menopause_)
table(dataScreen$X_menopause_)

table(dataInt$biop_hist)
table(dataScreen$biop_hist)

table(dataInt$density)
table(dataScreen$density)

table(dataInt$site_id)
table(dataScreen$site_id)

length(unique(dataInt$linkage_id))
length(unique(dataScreen$linkage_id))

summary(dataScreen$age)
summary(dataInt$age)
sd(dataScreen$age)
sd(dataInt$age)

t.test(dataInt$age, dataScreen$age)


summary(dataScreen$bmi)
summary(dataInt$bmi)
sd(dataScreen$bmi)
sd(dataInt$bmi)

t.test(dataInt$bmi, dataScreen$bmi)


#Splits up data by CC andMLO
splitInt<-split(dataInt, dataInt$view)
splitScreen<-split(dataScreen, dataScreen$view)
intDataMLO <- splitInt$MLO
intDataCC <- splitInt$CC
screenDataMLO <- splitScreen$MLO
screenDataCC <- splitScreen$CC

combinedDataCC <- rbind(intDataCC, screenDataCC)
combinedDataMLO <- rbind(intDataMLO, screenDataMLO)


#Generates K Folds for analysis#####

#Randomly shuffle the data (CC)
DataCC <-combinedDataCC[sample(nrow(combinedDataCC)),]
#Create 10 equally size folds (CC)
CCfolds <- cut(seq(1,nrow(DataCC)),breaks=10,labels=FALSE)

#Randomly shuffle the data (MLO)
DataMLO <-combinedDataMLO[sample(nrow(combinedDataMLO)),]
#Create 10 equally size folds (MLO)
MLOfolds <- cut(seq(1,nrow(DataMLO)),breaks=10,labels=FALSE)


#Calculating correlation of the Interval cancer with the IQF Variables.#####
SXACorVals <- cor(mergedData$Interval, mergedData[,c(8:141)], use="pairwise.complete.obs")
SXACorVals <- t(SXACorVals)
write.csv(SXACorVals, file = paste(savePath,dateOfAnalysis,"CorWithSXA.csv", sep=""),row.names=TRUE)

#Logistic Regression of each masking variable (No Controls)#####

#Done with K-Folds regression
#For Both CC and MLO

nCols <- ncol(allData)
regResults <- data.frame(matrix(ncol = 7, nrow = (nCols-5)))
colnames(regResults) <- c('Variable','pValCCTrain', 'pValMLOTrain', 'pctCorrTestCC', 'pctCorrTestMLO', 'AUCCC', 'AUCMLO')
pValCC = NULL
AccuracyCC = NULL
aucCC = NULL
pValMLO = NULL
AccuracyMLO = NULL
aucMLO = NULL

for (i in 8:nCols){
  
  for(j in 1:10){
    CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
    testSetCC <- DataCC[CCtestIndexes, ]
    trainSetCC <- DataCC[-CCtestIndexes, ]
    
    MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
    testSetMLO <- DataMLO[MLOtestIndexes, ]
    trainSetMLO <- DataMLO[-MLOtestIndexes, ]
    # i<-7
    
    varT <- i
    modelDataCC <- trainSetCC[,c(6,varT)]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    summary(model)
    if (nrow(coef(summary(model)))==2) {
      pValCC[j] <- (coef(summary(model))[2,4])
    }
    else if (nrow(coef(summary(model)))==1) {pValCC[j] <- 1}
    
    testPredictionsData <- testSetCC[,c(6,varT)]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    print(paste('Accuracy',1-misClasificError))
    AccuracyCC[j]<- 1-misClasificError
    p <- predict(model, newdata=testPredictionsData, type="response")
    pr <- prediction(p, testPredictionsData$Interval)
    prf <- performance(pr, measure = "tpr", x.measure = "fpr")
    # plot(prf)
    auc <- performance(pr, measure = "auc")
    aucCC[j] <- auc@y.values[1]
    print(colnames(allData[i]))
    # print(aucCC[j])
    
    
    modelDataMLO <- trainSetMLO[,c(6,varT)]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    summary(model)
    if (nrow(coef(summary(model)))==2) {
      pValMLO[j] <- (coef(summary(model))[2,4])
    }
    else if (nrow(coef(summary(model)))==1) {pValMLO[j] <- 1}
    # pValMLO <- (coef(summary(model))[2,4])
    
    testPredictionsData <- testSetMLO[,c(6,varT)]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    print(paste('Accuracy',1-misClasificError))
    AccuracyMLO[j] <- 1-misClasificError
    p <- predict(model, newdata=testPredictionsData, type="response")
    pr <- prediction(p, testPredictionsData$Interval)
    prf <- performance(pr, measure = "tpr", x.measure = "fpr")
    # plot(prf)
    auc <- performance(pr, measure = "auc")
    aucMLO[j] <- auc@y.values[1]
    print(colnames(allData[i]))
    # print(aucMLO[j])
  } 
  
  regResults[(i-5),1] <- colnames(allData[i])
  regResults[(i-5),2] <- mean(pValCC)
  regResults[(i-5),3] <- mean(pValMLO)
  regResults[(i-5),4] <- mean(AccuracyCC)
  regResults[(i-5),5] <- mean(AccuracyMLO)
  regResults[(i-5),6] <- mean(unlist(aucCC))
  regResults[(i-5),7] <- mean(unlist(aucMLO))
}

#identifies the top performers of CC and MLO and shows some results and details of those items

write.csv(regResults, file = paste(savePath,dateOfAnalysis,"regResults.csv", sep=""),row.names=TRUE)

regResultsBest <- subset(regResults, pValCCTrain<0.2)
sortedAUCCC <- regResultsBest[order(regResultsBest$AUCCC, regResultsBest$Variable, decreasing = TRUE) , ] 
bestEntriesAUCCC<-sortedAUCCC[(1):(10),]
keep <- bestEntriesAUCCC[,1]
nEnt <- length(keep)
keep[nEnt+1] <- 'Interval'
bestData <- allData[keep]

write.csv(regResultsBest, file = paste(savePath,dateOfAnalysis,"regResultsAUCCC.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCCC.csv", sep=""),row.names=TRUE)






#Regression after controlling for BIRADS/Demographic Information#####

nCols <- ncol(allData)
regResultsCtrl <- data.frame(matrix(ncol = 13, nrow = (nCols-5)))
colnames(regResultsCtrl) <- c('Variable','pValCCTrainSXA','pValCCTrainVar', 'pValMLOTrainSXA', 
                              'pValMLOTrainVar','pctCorrTestCC', 'pctCorrTestMLO', 'AUCCC', 'AUCMLO',
                              'estimateSXACC','estimateVarCC','estimateSXAMLO','estimateVarMLO')

pValCCSXA = NULL
pValCCVar = NULL
pValMLOSXA = NULL
pValMLOVar = NULL
AccuracyCC = NULL
AccuracyMLO = NULL
aucCC = NULL
aucMLO = NULL
estimateSXACC = NULL
estimateVarCC = NULL
estimateSXAMLO = NULL
estimateVarMLO = NULL


for (i in 8:nCols){
  keepVar<- c(keepNoVar, colnames(DataMLO[i]))
  for(j in 1:10){
    CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
    testSetCC <- DataCC[CCtestIndexes, ]
    trainSetCC <- DataCC[-CCtestIndexes, ]
    
    MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
    testSetMLO <- DataMLO[MLOtestIndexes, ]
    trainSetMLO <- DataMLO[-MLOtestIndexes, ]
    # i<-9
    varT <- i
    modelDataCC <- trainSetCC[keepVar]
    
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    nControls <- length((rownames(coef(summary(model)))))
    # print(summary(model))
    pValCCSXA[j] <- (coef(summary(model))[2,4])
    pValCCVar[j] <- (coef(summary(model))[nControls,4])
    estimateSXACC[j] <- (coef(summary(model))[2,1])
    estimateVarCC[j] <- (coef(summary(model))[nControls,1])
    
    
    testPredictionsData <- testSetCC[keepVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    print(paste('Accuracy',1-misClasificError))
    AccuracyCC[j]<- 1-misClasificError
    p <- predict(model, newdata=testPredictionsData, type="response")
    pr <- prediction(p, testPredictionsData$Interval)
    prf <- performance(pr, measure = "tpr", x.measure = "fpr")
    # plot(prf)
    auc <- performance(pr, measure = "auc")
    aucCC[j] <- auc@y.values[1]
    print(colnames(allData[i]))
    auc
    
    modelDataMLO <- trainSetMLO[keepVar]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    nControls <- length((rownames(coef(summary(model)))))
    # summary(model)
    pValMLOSXA[j] <- (coef(summary(model))[2,4])
    pValMLOVar[j] <- (coef(summary(model))[nControls,4])
    estimateSXAMLO[j] <- (coef(summary(model))[2,1])
    estimateVarMLO[j] <- (coef(summary(model))[nControls,1])
    
    testPredictionsData <- testSetMLO[keepVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    print(paste('Accuracy',1-misClasificError))
    AccuracyMLO[j]<- 1-misClasificError
    p <- predict(model, newdata=testPredictionsData, type="response")
    pr <- prediction(p, testPredictionsData$Interval)
    prf <- performance(pr, measure = "tpr", x.measure = "fpr")
    # plot(prf)
    auc <- performance(pr, measure = "auc")
    aucMLO[j] <- auc@y.values[1]
    print(colnames(allData[i]))
    auc
  }
  regResultsCtrl[(i-5),1] <- colnames(allData[i])
  regResultsCtrl[(i-5),2] <- mean(pValCCSXA)
  regResultsCtrl[(i-5),3] <- mean(pValCCVar)
  regResultsCtrl[(i-5),4] <- mean(pValMLOSXA)
  regResultsCtrl[(i-5),5] <- mean(pValMLOVar)
  regResultsCtrl[(i-5),6] <- mean(AccuracyCC, na.rm = TRUE)
  regResultsCtrl[(i-5),7] <- mean(AccuracyMLO, na.rm = TRUE)
  regResultsCtrl[(i-5),8] <- mean(unlist(aucCC))
  regResultsCtrl[(i-5),9] <- mean(unlist(aucMLO))
  regResultsCtrl[(i-5),10] <- mean(estimateSXACC)
  regResultsCtrl[(i-5),11] <- mean(estimateVarCC)
  regResultsCtrl[(i-5),12] <- mean(estimateSXAMLO)
  regResultsCtrl[(i-5),13] <- mean(estimateVarMLO)
}


write.csv(regResultsCtrl, file = paste(savePath,dateOfAnalysis,"regResultsCtrl.csv", sep=""),row.names=TRUE)

regResultsBestCC <- regResultsCtrl
sortedAUCCC <- regResultsBestCC[order(regResultsBestCC$AUCCC, regResultsBestCC$Variable, decreasing = TRUE) , ] 
bestEntriesAUCCC<-sortedAUCCC[(1):(10),]

regResultsBestMLO <- regResultsCtrl
sortedAUCMLO <- regResultsBestMLO[order(regResultsBestMLO$AUCMLO, regResultsBestMLO$Variable, decreasing = TRUE) , ] 
bestEntriesAUCMLO<-sortedAUCMLO[(1):(10),]

write.csv(regResultsBestCC, file = paste(savePath,dateOfAnalysis,"regResultsAUCCCControls.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCCCControls.csv", sep=""),row.names=TRUE)
write.csv(regResultsBestMLO, file = paste(savePath,dateOfAnalysis,"regResultsAUCMLOControls.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCMLO, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCMLOControls.csv", sep=""),row.names=TRUE)

#Calculates Average ROC Curve and Saves (CC)#####

nCols <- ncol(allData)
CC_AUCs_withWithoutMasking <- data.frame(matrix(ncol = 4, nrow = (10)))
colnames(CC_AUCs_withWithoutMasking) <- c('Variable','AUCDemogsOnly','AUCWithMaskingAddedOnly', 'pValWithMaskingAdded')
# predRisk1=data.frame(matrix(ncol = 1, nrow = (nrow(DataCC))))
# predRisk2=data.frame(matrix(ncol = 1, nrow = (nrow(DataCC))))

for (i in 1:10){
  # i <-1
  keepVar<- c(keepNoVar, bestEntriesAUCCC[i,1])
  
  pSXA=NULL
  pSXALabels=NULL
  pVar=NULL
  pVarLabels=NULL
  pValMaskingInModel = NULL
  predRisk1=NULL
  predRisk2=NULL
  predRisk1Bin=NULL
  predRisk2Bin=NULL
  
  png(filename=paste(savePath,dateOfAnalysis,"CCAUCwBIRADSandMeasure",i,".png", sep=""))
  plot.new()
  for(j in 1:10){
    CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
    testSetCC <- DataCC[CCtestIndexes, ]
    trainSetCC <- DataCC[-CCtestIndexes, ]
    varT <- i
    
    #Plots BIRADS
    modelDataCC <- trainSetCC[keepNoVar]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    riskModel1 <- model
    nControls <- length((rownames(coef(summary(model)))))
    setwd(savePath)
    fileConn<-file("CCModelOnlyDemog.txt")
    out <- capture.output(summary(model))
    cat(out,file="CCModelOnlyDemog.txt",sep="\n",append=TRUE)
    close(fileConn)
    testPredictionsData <- testSetCC[keepNoVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    predRisk1<-c(predRisk1, fitted.results)
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    predRisk1Bin<-c(predRisk1Bin, fitted.results)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    AccuracyCC<- 1-misClasificError
    pSXA[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pSXALabels[j] <- list(testPredictionsData$Interval)
    
    #Plots the relevant things with Variable 
    modelDataCC <- trainSetCC[keepVar]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    riskModel2<-model
    
    setwd(savePath)
    fileConn<-file("CCModelAddingMasking.txt")
    out <- capture.output(summary(model))
    cat(out,file="CCModelAddingMasking.txt",sep="\n",append=TRUE)
    close(fileConn)
    
    pValMaskingInModel[j] <- (coef(summary(model))[nControls,4])
    testPredictionsData <- testSetCC[keepVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    predRisk2<-c(predRisk2,fitted.results)
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    predRisk2Bin<-c(predRisk2Bin, fitted.results)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    # print(paste('Accuracy',1-misClasificError))
    AccuracyCC<- 1-misClasificError
    pVar[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pVarLabels[j] <- list(testPredictionsData$Interval)
    

  }
  
  # data(testPredictionsData)
  cOutcome<-1

  setwd(savePath)
  fileConn<-file(paste("MAIN_CC_NRI_",bestEntriesAUCCC[i,1],".txt"))
  cutoff <- c(0,.3, .5, .7, 1)
  out <- capture.output(reclassification(data=DataCC[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_CC_NRI_",bestEntriesAUCCC[i,1],".txt"),sep="\n",append=TRUE)
  close(fileConn)
  fileConn<-file(paste("MAIN_CC_NRI_BINARY_",bestEntriesAUCCC[i,1],".txt"))
  cutoff <- c(0, .5,  1)
  out <- capture.output(reclassification(data=DataCC[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1Bin, predrisk2=predRisk2Bin, cutoff))
  cat(out,file=paste("MAIN_CC_NRI_BINARY_",bestEntriesAUCCC[i,1],".txt"),sep="\n",append=TRUE)
  close(fileConn)
  
  pr <- prediction(pSXA, pSXALabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucCCDemog <- auc@y.values
  
  pr <- prediction(pVar, pVarLabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",add=TRUE)
  axis(1)
  axis(2)
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
  
  auc <- performance(pr, measure = "auc")
  aucCCWMasking <- auc@y.values
  
  dev.off()
  
  CC_AUCs_withWithoutMasking[(i),1] <- (bestEntriesAUCCC[i,1])
  CC_AUCs_withWithoutMasking[(i),2] <- mean(unlist(aucCCDemog))
  CC_AUCs_withWithoutMasking[(i),3] <- mean(unlist(aucCCWMasking))
  CC_AUCs_withWithoutMasking[(i),4] <- mean(unlist(pValMaskingInModel))
  
}

write.csv(CC_AUCs_withWithoutMasking, file = paste(savePath,dateOfAnalysis,"MAIN_CC_Aucs_WithWihtoutMasking.csv", sep=""),row.names=TRUE)


#Calculates Average ROC Curve and Saves (MLO)#####


nCols <- ncol(allData)
MLO_AUCs_withWithoutMasking <- data.frame(matrix(ncol = 4, nrow = (10)))
colnames(MLO_AUCs_withWithoutMasking) <- c('Variable','AUCDemogsOnly','AUCWithMaskingAddedOnly', 'pValWithMaskingAdded')

for (i in 1:10){
  keepVar<- c(keepNoVar, bestEntriesAUCMLO[i,1])
  # i <-1
  pSXA=NULL
  pSXALabels=NULL
  pVar=NULL
  pVarLabels=NULL
  pValMaskingInModel = NULL
  predRisk1=NULL
  predRisk2=NULL
  predRisk1Bin=NULL
  predRisk2Bin=NULL
  
  png(filename=paste(savePath,dateOfAnalysis,"MLOAUCwBIRADSandMeasure",i,".png", sep=""))
  plot.new()
  for(j in 1:10){
    MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
    testSetMLO <- DataMLO[MLOtestIndexes, ]
    trainSetMLO <- DataMLO[-MLOtestIndexes, ]
    varT <- i
    
    #Plots BIRADS
    modelDataMLO <- trainSetMLO[keepNoVar]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    riskModel1 <- model
    nControls <- length((rownames(coef(summary(model)))))
    setwd(savePath)
    fileConn<-file("MLOModelOnlyDemog.txt")
    out <- capture.output(summary(model))
    cat(out,file="MLOModelOnlyDemog.txt",sep="\n",append=TRUE)
    close(fileConn)
    
    testPredictionsData <- testSetMLO[keepNoVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    predRisk1<-c(predRisk1, fitted.results)
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    predRisk1Bin<-c(predRisk1Bin, fitted.results)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    AccuracyMLO<- 1-misClasificError
    pSXA[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pSXALabels[j] <- list(testPredictionsData$Interval)
    
    
    #Plots the relevant things 
    modelDataMLO <- trainSetMLO[keepVar]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    riskModel2 <- model
    nControls <- length((rownames(coef(summary(model)))))
    setwd(savePath)
    fileConn<-file("MLOModelAddingMasking.txt")
    out <- capture.output(summary(model))
    cat(out,file="MLOModelAddingMasking.txt",sep="\n",append=TRUE)
    close(fileConn)
    
    pValMaskingInModel[j] <- (coef(summary(model))[nControls,4])
    testPredictionsData <- testSetMLO[keepVar]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    predRisk2<-c(predRisk2, fitted.results)
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    predRisk2Bin<-c(predRisk2Bin, fitted.results)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    # print(paste('Accuracy',1-misClasificError))
    AccuracyMLO<- 1-misClasificError
    pVar[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pVarLabels[j] <- list(testPredictionsData$Interval)
  }
  cOutcome<-1
  
  setwd(savePath)
  fileConn<-file(paste("MAIN_MLO_NRI_",bestEntriesAUCMLO[i,1],".txt"))
  cutoff <- c(0,.3, .5, .7, 1)
  out <- capture.output(reclassification(data=DataMLO[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_MLO_NRI_",bestEntriesAUCMLO[i,1],".txt"),sep="\n",append=TRUE)
  close(fileConn)
  fileConn<-file(paste("MAIN_MLO_NRI_BINARY_",bestEntriesAUCMLO[i,1],".txt"))
  cutoff <- c(0, .5,  1)
  out <- capture.output(reclassification(data=DataMLO[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1Bin, predrisk2=predRisk2Bin, cutoff))
  cat(out,file=paste("MAIN_MLO_NRI_BINARY_",bestEntriesAUCMLO[i,1],".txt"),sep="\n",append=TRUE)
  close(fileConn)
  
  pr <- prediction(pSXA, pSXALabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucMLODemog <- auc@y.values
  
  pr <- prediction(pVar, pVarLabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",add=TRUE) #spread.estimate="stddev"
  axis(1)
  axis(2)
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
  
  auc <- performance(pr, measure = "auc")
  aucMLOMasking <- auc@y.values
  dev.off()
  
  MLO_AUCs_withWithoutMasking[(i),1] <- (bestEntriesAUCMLO[i,1])
  MLO_AUCs_withWithoutMasking[(i),2] <- mean(unlist(aucMLODemog))
  MLO_AUCs_withWithoutMasking[(i),3] <- mean(unlist(aucMLOMasking))
  MLO_AUCs_withWithoutMasking[(i),4] <- mean(unlist(pValMaskingInModel))
}

write.csv(MLO_AUCs_withWithoutMasking, file = paste(savePath,dateOfAnalysis,"MAIN_MLO_Aucs_WithWihtoutMasking.csv", sep=""),row.names=TRUE)

#####
#Calculate Masking Properties/Predictions by  Density

# CC
testData <- cbind()


# MLO
DensityPredData <- cbind(combinedDataMLO$density,combinedDataMLO$Interval, predRisk2, predRisk2Bin)
DensityPredDataInt<- subset(DensityPredData, DensityPredData[,2]==1)
DensityPredDataScD<- subset(DensityPredData, DensityPredData[,2]==0)

boxplot(DensityPredDataInt[,3]~DensityPredDataInt[,1], ylim=c(0.4,0.6))
boxplot(DensityPredDataScD[,3]~DensityPredDataScD[,1], ylim=c(0.4,0.6))



