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
install.packages("survival")
require("R.matlab")
require("ROCR")
require("dplyr")
require("e1071")
require("ICC")
require("lattice")
require("psych")
require("gdata")
require("PredictABEL")
require("survival")
#####
#Defines the dataset that I'll analyze
#Similar patches by mean/stdev

dateOfAnalysis = "8.3.17"
# savePath = "D:\\LabData\\BreastMasking\\FinalAnalysisImages\\"
# savePath = "W:\\Breast Studies\\Masking\\AnalysisImages\\8.3_Simulated\\"
savePath = "W:\\Breast Studies\\Masking\\AnalysisImages\\8.3_Simulated_DiscShape\\"

#Similar By Statistics
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_Simulated\\"
# wdAll <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\6.20.17_CompiledData_Simulated\\"
wdAll <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\7.31.17_CompiledData_Simulated_DiscShape\\"
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_SimilarStat\\"
# wdAll <- "D:\\LabData\\BreastMasking\\6.20.17_CompiledData_SimilarLoc\\"

keepNoVar <- c('Interval',  'density', 'age', 'bmi', 'race','X_menopause_', 'X_firstdeg_','biop_hist', 'cancer_id')
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

#Splits Int/ScD#####
mergedData$Interval[mergedData$group=="FN"] <- 1
mergedData$ScreenDetected[mergedData$group=="FN"] <- 0
mergedData$Interval[mergedData$group=="TP"] <- 0
mergedData$ScreenDetected[mergedData$group=="TP"] <- 1

#Splits up data by CC and MLO #####
splitData<-split(mergedData, mergedData$view)
DataMLO <- splitData$MLO
DataCC <- splitData$CC


#Generate Data of all relevant information #####
setwd(savePath)


splitData<-split(mergedData, mergedData$group)
dataInt <- splitData$FN
dataScreen <- splitData$TP

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




#Conditional Logistic Regression of each masking variable (No Controls)#####

#Done with K-Folds regression
#For Both CC and MLO

nCols <- ncol(allData)
regResultsUnivariate <- data.frame(matrix(ncol = 9, nrow = nCols))
colnames(regResultsUnivariate) <- c('Variable','pValCCTrain', 'ORCC', 'AUCCC', 'estCC', 'pValMLOTrain',  'ORMLO', 'AUCMLO', 'estMLO')

for (i in 8:nCols){
    # varT <- i
    varName <-colnames(DataCC[i])
    
    keep<-c('Interval',colnames(DataCC[i]),'cancer_id')
    modelDataCC <- DataCC[keep]
    modelCC <- clogit(Interval~modelDataCC[,2]+strata(cancer_id), method="exact", data=modelDataCC)
    
    p<-modelCC$linear.predictors
    p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
    pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
    prf <- performance(pr, measure = "tpr", x.measure = "fpr")
    plot(prf)
    auc <- performance(pr, measure = "auc")
    aucCC <- auc@y.values[1]
    print(unlist(aucCC))
    print(colnames(allData[i]))
    
    #Relevant Parameters to extract
    CoeffCC<-modelCC$coefficients[[1]]
    # zScore<-coef(summary(modelCC))[1,4]
    pValCC<-coef(summary(modelCC))[1,5]
    ORPerIncCC<-coef(summary(modelCC))[1,2]
    #*************************#************************#*************************#*********************
    keep<-c('Interval',colnames(DataMLO[i]),'cancer_id')
    modelDataMLO <- DataMLO[keep]
    modelMLO <- clogit(Interval~modelDataMLO[,2]+strata(cancer_id), method="exact", data=modelDataMLO)
    
    p<-modelMLO$linear.predictors
    p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
    pr <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
    auc <- performance(pr, measure = "auc")
    aucMLO <- auc@y.values[1]
    print(colnames(allData[i]))
    
    #Relevant Parameters to extract
    CoeffMLO<-modelCC$coefficients[[1]]
    # zScore<-coef(summary(modelCC))[1,4]
    pValMLO<-coef(summary(modelMLO))[1,5]
    ORPerIncMLO<-coef(summary(modelMLO))[1,2]
    #*************************#************************#*************************#*********************
    regResultsUnivariate[i,] <- c(colnames(allData[i]), pValCC, ORPerIncCC, unlist(aucCC[[1]]), 
                          CoeffCC,pValMLO, ORPerIncMLO, unlist(aucMLO[[1]]), CoeffMLO)
}  
#Saves the regression results
write.csv(regResultsUnivariate, file = paste(savePath,dateOfAnalysis,"regResultsUnivariate.csv", sep=""),row.names=TRUE)


#**************#***********GOODUPTHROUGHHERE#*********************#**********************#*
#Conditional Logistic Regression with ONLY BIRADS/Demographic Information WITHOUT K-Folds (To Determine Model/AUC)#####
nCols <- ncol(allData)
regResultsBIRADDensityOnly <- data.frame(matrix(ncol = 9, nrow = 1))
colnames(regResultsBIRADDensityOnly) <- c('Variable','pValCCTrain', 'ORCC', 'AUCCC', 'estCC',
                              'pValMLOTrain',  'ORMLO', 'AUCMLO', 'estMLO')
                              
modelDataCC <- DataCC[keepNoVar]
modelCC <- clogit(Interval~density+age+bmi+race+X_menopause_+X_firstdeg_+biop_hist+
                                           strata(cancer_id), method="exact", data=modelDataCC)

p<-modelCC$linear.predictors
p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
auc <- performance(pr, measure = "auc")
aucCC <- auc@y.values[1]
print(unlist(aucCC))

#Relevant Parameters to extract
CoeffCC<-modelCC$coefficients[[1]]
# zScore<-coef(summary(modelCC))[1,4]
pValCC<-coef(summary(modelCC))[1,5]
ORPerIncCC<-coef(summary(modelCC))[1,2]
#*************************#************************#*************************#*********************
modelDataMLO <- DataMLO[keepNoVar]
modelMLO <- clogit(Interval~density+age+bmi+race+X_menopause_+X_firstdeg_+biop_hist+
                    strata(cancer_id), method="exact", data=modelDataMLO)

p<-modelMLO$linear.predictors
p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
pr <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
auc <- performance(pr, measure = "auc")
aucMLO <- auc@y.values[1]
print(colnames(allData[i]))

#Relevant Parameters to extract
CoeffMLO<-modelCC$coefficients[[1]]
# zScore<-coef(summary(modelCC))[1,4]
pValMLO<-coef(summary(modelMLO))[1,5]
ORPerIncMLO<-coef(summary(modelMLO))[1,2]
#*************************#************************#*************************#*********************
regResultsBIRADDensityOnly[1,] <- c('Density and BIRADS', pValCC, ORPerIncCC, unlist(aucCC[[1]]), 
                    CoeffCC,pValMLO, ORPerIncMLO, unlist(aucMLO[[1]]), CoeffMLO)

#Saves the regression results
write.csv(regResultsBIRADDensityOnly, file = paste(savePath,dateOfAnalysis,"regResultsBIRADDensityOnly.csv", sep=""),row.names=TRUE)


fileConn<-file("regResultsONLYBIRADSDensity.txt")
out <- capture.output(summary(modelCC))
cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
out <- unlist(aucCC)
cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
out <- capture.output(summary(modelMLO))
cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
out <- unlist(aucMLO)
cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
close(fileConn)



#Conditional Logistic Regression after controlling for BIRADS/Demographic Information WITHOUT K-Folds (To Determine Model)#####

nCols <- ncol(allData)
regResultsDensityPlusMasking <- data.frame(matrix(ncol = 9, nrow = 1))
colnames(regResultsDensityPlusMasking) <- c('Variable','pValCCTrain', 'ORCC', 'AUCCC', 'estCC',
                                            'pValMLOTrain',  'ORMLO', 'AUCMLO', 'estMLO')


fileConn<-file("regResultsDensityPlusMasking.txt")
for (i in 8:nCols){
  keepVar<- c(keepNoVar, colnames(DataMLO[i]))
  
  varT <- i
  
  modelDataCC <- DataCC[keepVar]
  modelCC <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataCC)
  
  p<-modelCC$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  plot(prf)
  auc <- performance(pr, measure = "auc")
  aucCC <- auc@y.values[1]
  print(unlist(aucCC))
  
  #Relevant Parameters to extract
  CoeffCC<-modelCC$coefficients[[17]]
  pValCC<-coef(summary(modelCC))[17,5]
  ORPerIncCC<-coef(summary(modelCC))[17,2]
  #*************************#************************#*************************#*********************
  modelDataMLO <- DataMLO[keepVar]
  modelMLO <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataMLO)
  
  p<-modelMLO$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
  auc <- performance(pr, measure = "auc")
  aucMLO <- auc@y.values[1]
  print(colnames(allData[i]))
  
  #Relevant Parameters to extract
  CoeffMLO<-modelCC$coefficients[[17]]
  pValMLO<-coef(summary(modelMLO))[17,5]
  ORPerIncMLO<-coef(summary(modelMLO))[17,2]
  #*************************#************************#*************************#*********************
  regResultsDensityPlusMasking[i,] <- c(colnames(allData[i]), pValCC, ORPerIncCC, unlist(aucCC[[1]]), 
                                        CoeffCC,pValMLO, ORPerIncMLO, unlist(aucMLO[[1]]), CoeffMLO)
  #*************************#************************#*************************#*********************
  out <- capture.output(summary(modelCC))
  cat(out,file="regResultsDensityPlusMasking.txt",sep="\n",append=TRUE)
  out <- unlist(aucCC)
  cat(out,file="regResultsDensityPlusMasking.txt",sep="\n",append=TRUE)
  out <- capture.output(summary(modelMLO))
  cat(out,file="regResultsDensityPlusMasking.txt",sep="\n",append=TRUE)
  out <- unlist(aucMLO)
  cat(out,file="regResultsDensityPlusMasking.txt",sep="\n",append=TRUE)
}
close(fileConn)

write.csv(regResultsDensityPlusMasking, file = paste(savePath,dateOfAnalysis,"regResultsDensityPlusMasking.csv", sep=""),row.names=TRUE)


regResultsBestCC <- regResultsDensityPlusMasking
sortedAUCCC <- regResultsBestCC[order(regResultsBestCC$AUCCC, regResultsBestCC$Variable, decreasing = TRUE) , ] 
bestEntriesAUCCC<- subset(sortedAUCCC, pValCCTrain<0.05)

regResultsBestMLO <- regResultsDensityPlusMasking
sortedAUCMLO <- regResultsBestMLO[order(regResultsBestMLO$AUCMLO, regResultsBestMLO$Variable, decreasing = TRUE) , ] 
bestEntriesAUCMLO<-subset(sortedAUCMLO, pValMLOTrain<0.05)

write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"BESTregResultsDensityPlusMaskingAUCCCControls.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCMLO, file = paste(savePath,dateOfAnalysis,"BESTregResultsDensityPlusMaskingMLOControls.csv", sep=""),row.names=TRUE)


#Calculates Average ROC Curve and NRI and Saves (CC)#####

nCols <- ncol(allData)
CC_AUCs_withWithoutMasking <- data.frame(matrix(ncol = 4, nrow = (nrow(bestEntriesAUCCC))))
colnames(CC_AUCs_withWithoutMasking) <- c('Variable','AUCDemogsOnly','AUCWithMaskingAdded', 'pValWithMaskingAdded')
setwd(savePath)

fileNRI<-file(paste("MAIN_CC_NRI_BINARY_.txt", sep=""))
fileNRISepSections<-file(paste("MAIN_CC_NRI_4Cats_.txt", sep=""))
for (i in 1:nrow(bestEntriesAUCCC)){
  keepVar<- c(keepNoVar, bestEntriesAUCCC[i,1])

  png(filename=paste(savePath,dateOfAnalysis,"CCAUCwBIRADSandMeasure_",bestEntriesAUCCC[i,1],".png", sep=""))
  plot.new()
  
  #Doing Just the Density Model
  modelDataCC <- DataCC[keepNoVar]
  modelCCNoMasking <- clogit(Interval~density+age+bmi+race+X_menopause_+X_firstdeg_+biop_hist+
                                            strata(cancer_id), method="exact", data=modelDataCC)
  
  
  p<-modelCCNoMasking$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr1 <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
  prf <- performance(pr1, measure = "tpr", x.measure = "fpr")
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucCCDemog <- auc@y.values[1]
  
  predRisk1<-p
  cOutcome<-1
  
  
  #Doing the Density Model + Masking
  modelDataCC <- DataCC[keepVar]
  modelCCMasking <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataCC)
  
  p<-modelCCMasking$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr2 <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
  prf <- performance(pr2, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",add=TRUE)
  axis(1)
  axis(2)
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
  dev.off()
  
  auc <- performance(pr, measure = "auc")
  aucCCWMasking <- auc@y.values[1]
  pValMaskingInModel<-coef(summary(modelCCMasking))[17,5]
  
  predRisk2<-p
  cOutcome<-1
  
  
  fileConn<-file("CCModelOnlyDemogandWithMasking.txt")
  out <- " "
  cat(out,file="CCModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  out <- capture.output(summary(modelCCNoMasking))
  cat(out,file="CCModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  out <- capture.output(summary(modelCCMasking))
  cat(out,file="CCModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  close(fileConn)
  
  
  
  cutoff <- c(0, .5,  1)
  out <- print(bestEntriesAUCCC[i,1])
  cat(out,file=paste("MAIN_CC_NRI_BINARY_.txt"),sep="\n",append=TRUE)
  out <- capture.output(reclassification(data=DataCC[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_CC_NRI_BINARY_.txt"),sep="\n",append=TRUE)
  
  
  cutoff <- c(0, 0.2,.5, 0.8,  1)
  out <- print(bestEntriesAUCCC[i,1])
  cat(out,file=paste("MAIN_CC_NRI_4Cats_.txt"),sep="\n",append=TRUE)
  out <- capture.output(reclassification(data=DataCC[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_CC_NRI_4Cats_.txt"),sep="\n",append=TRUE)
  
  
  CC_AUCs_withWithoutMasking[(i),] <- c((bestEntriesAUCCC[i,1]),mean(unlist(aucCCDemog)),mean(unlist(aucCCWMasking)),
                                        mean(unlist(pValMaskingInModel)))

  
  save(pr2, file=paste(savePath,dateOfAnalysis,"predictionWithMaskingCC_",bestEntriesAUCCC[i,1],".RDATA", sep=""))
  
  
}
close(fileNRI)
close(fileNRISepSections)
save(pr1, file=paste(savePath,dateOfAnalysis,"predictionNoMaskingCC.RDATA", sep=""))
write.csv(CC_AUCs_withWithoutMasking, file = paste(savePath,dateOfAnalysis,"MAIN_CC_Aucs_WithWithoutMasking.csv", sep=""),row.names=TRUE)



#Calculate average ROC curve and NRI and saves (MLO) #####

nCols <- ncol(allData)
MLO_AUCs_withWithoutMasking <- data.frame(matrix(ncol = 4, nrow = (nrow(bestEntriesAUCMLO))))
colnames(MLO_AUCs_withWithoutMasking) <- c('Variable','AUCDemogsOnly','AUCWithMaskingAdded', 'pValWithMaskingAdded')
setwd(savePath)

fileNRI<-file(paste("MAIN_MLO_NRI_BINARY_.txt", sep=""))
fileNRISepSections<-file(paste("MAIN_MLO_NRI_4Cats_.txt", sep=""))
for (i in 1:nrow(bestEntriesAUCMLO)){
  keepVar<- c(keepNoVar, bestEntriesAUCMLO[i,1])
  
  png(filename=paste(savePath,dateOfAnalysis,"MLOAUCwBIRADSandMeasure_",bestEntriesAUCMLO[i,1],".png", sep=""))
  plot.new()
  
  #Doing Just the Density Model
  modelDataMLO <- DataMLO[keepNoVar]
  modelMLONoMasking <- clogit(Interval~density+age+bmi+race+X_menopause_+X_firstdeg_+biop_hist+
                               strata(cancer_id), method="exact", data=modelDataMLO)
  
  
  p<-modelMLONoMasking$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr1 <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
  prf <- performance(pr1, measure = "tpr", x.measure = "fpr")
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucMLODemog <- auc@y.values[1]
  
  predRisk1<-p
  cOutcome<-1
  
  
  #Doing the Density Model + Masking
  modelDataMLO <- DataMLO[keepVar]
  modelMLOMasking <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataMLO)
  
  p<-modelMLOMasking$linear.predictors
  p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
  pr2 <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
  prf <- performance(pr2, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",add=TRUE)
  axis(1)
  axis(2)
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCMLO[i,1]))
  dev.off()
  
  auc <- performance(pr, measure = "auc")
  aucMLOWMasking <- auc@y.values[1]
  pValMaskingInModel<-coef(summary(modelMLOMasking))[17,5]
  
  predRisk2<-p
  cOutcome<-1
  
  
  fileConn<-file("MLOModelOnlyDemogandWithMasking.txt")
  out <- " "
  cat(out,file="MLOModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  out <- capture.output(summary(modelMLONoMasking))
  cat(out,file="MLOModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  out <- capture.output(summary(modelMLOMasking))
  cat(out,file="MLOModelOnlyDemogandWithMasking.txt",sep="\n",append=TRUE)
  close(fileConn)
  
  
  
  cutoff <- c(0, .5,  1)
  out <- print(bestEntriesAUCMLO[i,1])
  cat(out,file=paste("MAIN_MLO_NRI_BINARY_.txt"),sep="\n",append=TRUE)
  out <- capture.output(reclassification(data=DataMLO[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_MLO_NRI_BINARY_.txt"),sep="\n",append=TRUE)
  
  
  cutoff <- c(0, 0.2,.5, 0.8,  1)
  out <- print(bestEntriesAUCCC[i,1])
  cat(out,file=paste("MAIN_MLO_NRI_4Cats_.txt"),sep="\n",append=TRUE)
  out <- capture.output(reclassification(data=DataMLO[keepVar], cOutcome=cOutcome,
                                         predrisk1=predRisk1, predrisk2=predRisk2, cutoff))
  cat(out,file=paste("MAIN_MLO_NRI_4Cats_.txt"),sep="\n",append=TRUE)
  
  
  
  MLO_AUCs_withWithoutMasking[(i),] <- c((bestEntriesAUCMLO[i,1]),mean(unlist(aucMLODemog)),mean(unlist(aucMLOWMasking)),
                                        mean(unlist(pValMaskingInModel)))
  
  
  save(pr2, file=paste(savePath,dateOfAnalysis,"predictionWithMaskingMLO_",bestEntriesAUCMLO[i,1],".RDATA", sep=""))
  
  
}
close(fileNRI)
close(fileNRISepSections)
save(pr1, file=paste(savePath,dateOfAnalysis,"predictionNoMaskingMLO.RDATA", sep=""))
write.csv(MLO_AUCs_withWithoutMasking, file = paste(savePath,dateOfAnalysis,"MAIN_MLO_Aucs_WithWithoutMasking.csv", sep=""),row.names=TRUE)







#Generates K Folds for analysis#####
#Create 10 equally size folds (CC)
CCfolds <- cut(seq(1,nrow(DataCC)),breaks=10,labels=FALSE)
#Create 10 equally size folds (MLO)
MLOfolds <- cut(seq(1,nrow(DataMLO)),breaks=10,labels=FALSE)


# #****** Make sure saving of the filenames works. #####
# 
# #Conditional Logistic Regression with ONLY BIRADS/Demographic Information WITH K-Folds (To Determine if Overfit)#####
# 
# 
# nCols <- ncol(allData)
# regResultsBIRADDensitykFolds <- data.frame(matrix(ncol = 9, nrow = 1))
# colnames(regResultsBIRADDensitykFolds) <- c('Variable','pValCCTrain', 'ORCC', 'AUCCC', 'estCC',
#                                           'pValMLOTrain',  'ORMLO', 'AUCMLO', 'estMLO')
# 
# pValCCSXA = NULL
# pValCCVar = NULL
# pValMLOSXA = NULL
# pValMLOVar = NULL
# AccuracyCC = NULL
# AccuracyMLO = NULL
# aucCC = NULL
# aucMLO = NULL
# estimateSXACC = NULL
# estimateVarCC = NULL
# estimateSXAMLO = NULL
# estimateVarMLO = NULL
# 
# 
# strata <- DataCC$cancer_id
# predictors<-DataCC[keepNoVar]
# predictors<-predictors[,2:8]
# Y<- DataCC$Interval
# X<-predictors
# clObj = clogitL1(y=Y, x=X, CCfolds)
# plot(clObj, logX=TRUE)
# 
# clcvObj = cv.clogitL1(modelCC)
# # plot(clcvObj)
# 
# 
# 
# 
# # data parameters
# K = 10 # number of strata
# n = 5 # number in strata
# m = 2 # cases per stratum
# p = 20 # predictors
# 
# # generate data
# y = rep(c(rep(1, m), rep(0, n-m)), K)
# X = matrix (rnorm(K*n*p, 0, 1), ncol = p) # pure noise
# strata = sort(rep(1:K, n))
# 
# par(mfrow = c(1,2))
# # fit the conditional logistic model
# clObj = clogitL1(y=y, x=X, strata)
# plot(clObj, logX=TRUE)
# 
# # cross validation
# clcvObj = cv.clogitL1(clObj)
# plot(clcvObj)
# 
# 
# 
# for(j in 1:10){
#   CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
#   testSetCC <- DataCC[CCtestIndexes, ]
#   trainSetCC <- DataCC[-CCtestIndexes, ]
#   
#   MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
#   testSetMLO <- DataMLO[MLOtestIndexes, ]
#   trainSetMLO <- DataMLO[-MLOtestIndexes, ]
#   # i<-9
#   
#   
#   
#   
#   modelDataCC <- trainSetCC[keepNoVar]
#   modelCC <- clogit(Interval~density+age+bmi+race+X_menopause_+X_firstdeg_+biop_hist+
#                       strata(cancer_id), method="exact", data=modelDataCC)
#   
#   testDataCC <- testSetCC[keepNoVar]
#   fitted.results <- predict(modelCC,newdata=testDataCC, type="lp", na.action=na.exclude)
#   print(fitted.results)
#   
#   
#   lung1<-lung[1:114,]
#   lung2<-lung[115:228,]
#   
#   options(na.action=na.exclude) # retain NA in predictions
#   fit <- coxph(Surv(time, status) ~ age + ph.ecog + strata(inst), lung1)
#   #lung data set has status coded as 1/2
#   # mresid <- (lung1$status-1) - predict(fit, type='expected') #Martingale resid 
#   predict(fit,newdata = lung2,type="lp")
#   predict(fit,type="expected")
#   predict(fit,type="risk",se.fit=TRUE)
#   predict(fit,type="terms",se.fit=TRUE)
#   
#   
#   
#   
#   
# } 
#   
#   fitted.results <- ifelse(fitted.results > 0.5,1,0)
#   misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#   print(paste('Accuracy',1-misClasificError))
#   AccuracyMLO[j] <- 1-misClasificError
#   p <- predict(model, newdata=testPredictionsData, type="response")
#   pr <- prediction(p, testPredictionsData$Interval)
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   
#   
#   p<-modelCC$linear.predictors
#   p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
#   pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   plot(prf)
#   auc <- performance(pr, measure = "auc")
#   aucCC <- auc@y.values[1]
#   print(unlist(aucCC))
#   
#   #Relevant Parameters to extract
#   CoeffCC<-modelCC$coefficients[[1]]
#   # zScore<-coef(summary(modelCC))[1,4]
#   pValCC<-coef(summary(modelCC))[1,5]
#   ORPerIncCC<-coef(summary(modelCC))[1,2]
#   #*************************#************************#*************************#*********************
#   modelDataMLO <- DataMLO[keepNoVar]
#   modelMLO <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataMLO)
#   
#   p<-modelMLO$linear.predictors
#   p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
#   pr <- prediction(p, modelDataMLO$Interval) #Does this need to be on a scale of 0-1?
#   auc <- performance(pr, measure = "auc")
#   aucMLO <- auc@y.values[1]
#   print(colnames(allData[i]))
#   
#   #Relevant Parameters to extract
#   CoeffMLO<-modelCC$coefficients[[1]]
#   # zScore<-coef(summary(modelCC))[1,4]
#   pValMLO<-coef(summary(modelMLO))[1,5]
#   ORPerIncMLO<-coef(summary(modelMLO))[1,2]
#   
#   
#   
#   
#   
#   
#   
#   
#   #*********************#*************************#*&********************
#   
#   
#   
#   
#   
#   
#   
#   varT <- i
#   modelDataCC <- trainSetCC[keepVar]
#   modelCC <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataCC)
#   
#   p<-modelCC$linear.predictors
#   p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
#   pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   plot(prf)
#   auc <- performance(pr, measure = "auc")
#   aucCC <- auc@y.values[1]
#   print(unlist(aucCC))
#   
#   #Relevant Parameters to extract
#   CoeffCC<-modelCC$coefficients[[1]]
#   # zScore<-coef(summary(modelCC))[1,4]
#   pValCC<-coef(summary(modelCC))[1,5]
#   ORPerIncCC<-coef(summary(modelCC))[1,2]
#   
#   
#   
#   modelDataCC <- testSetCC[keepVar]
#   modelCC <- clogit(Interval~.+strata(cancer_id), method="exact", data=modelDataCC)
#   
#   p<-modelCC$linear.predictors
#   p<- (p-min(p))/(max(p)-min(p)) #Shift the scale from 0 to 1
#   pr <- prediction(p, modelDataCC$Interval) #Does this need to be on a scale of 0-1?
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   plot(prf)
#   auc <- performance(pr, measure = "auc")
#   aucCC <- auc@y.values[1]
#   print(unlist(aucCC))
#   
#   #Relevant Parameters to extract
#   CoeffCC<-modelCC$coefficients[[1]]
#   # zScore<-coef(summary(modelCC))[1,4]
#   pValCC<-coef(summary(modelCC))[1,5]
#   ORPerIncCC<-coef(summary(modelCC))[1,2]
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   
#   model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
#   nControls <- length((rownames(coef(summary(model)))))
#   # print(summary(model))
#   pValCCSXA[j] <- (coef(summary(model))[2,4])
#   pValCCVar[j] <- (coef(summary(model))[nControls,4])
#   estimateSXACC[j] <- (coef(summary(model))[2,1])
#   estimateVarCC[j] <- (coef(summary(model))[nControls,1])
#   
#   
#   testPredictionsData <- testSetCC[keepVar]
#   fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#   fitted.results <- ifelse(fitted.results > 0.5,1,0)
#   misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#   print(paste('Accuracy',1-misClasificError))
#   AccuracyCC[j]<- 1-misClasificError
#   p <- predict(model, newdata=testPredictionsData, type="response")
#   pr <- prediction(p, testPredictionsData$Interval)
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   # plot(prf)
#   auc <- performance(pr, measure = "auc")
#   aucCC[j] <- auc@y.values[1]
#   print(colnames(allData[i]))
#   auc
#   
#   modelDataMLO <- trainSetMLO[keepVar]
#   model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
#   nControls <- length((rownames(coef(summary(model)))))
#   # summary(model)
#   pValMLOSXA[j] <- (coef(summary(model))[2,4])
#   pValMLOVar[j] <- (coef(summary(model))[nControls,4])
#   estimateSXAMLO[j] <- (coef(summary(model))[2,1])
#   estimateVarMLO[j] <- (coef(summary(model))[nControls,1])
#   
#   testPredictionsData <- testSetMLO[keepVar]
#   fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#   fitted.results <- ifelse(fitted.results > 0.5,1,0)
#   misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#   print(paste('Accuracy',1-misClasificError))
#   AccuracyMLO[j]<- 1-misClasificError
#   p <- predict(model, newdata=testPredictionsData, type="response")
#   pr <- prediction(p, testPredictionsData$Interval)
#   prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#   # plot(prf)
#   auc <- performance(pr, measure = "auc")
#   aucMLO[j] <- auc@y.values[1]
#   print(colnames(allData[i]))
#   auc
# 
#   regResults[j,] <- c(j, pValCC, ORPerIncCC, unlist(aucCC[[1]]), 
#                       CoeffCC,pValMLO, ORPerIncMLO, unlist(aucMLO[[1]]), CoeffMLO)
#   
# 
# 
# 
# fileConn<-file("regResultsONLYBIRADSDensity.txt")
# out <- capture.output(summary(modelCC))
# cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
# out <- unlist(aucCC)
# cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
# out <- capture.output(summary(modelMLO))
# cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
# out <- unlist(aucMLO)
# cat(out,file="regResultsONLYBIRADSDensity.txt",sep="\n",append=TRUE)
# close(fileConn)
# 
# 
# 
# 
# 
# 
# 
# 
# write.csv(regResultsCtrl, file = paste(savePath,dateOfAnalysis,"regResultsCtrl.csv", sep=""),row.names=TRUE)
# 
# regResultsBestCC <- regResultsCtrl
# sortedAUCCC <- regResultsBestCC[order(regResultsBestCC$AUCCC, regResultsBestCC$Variable, decreasing = TRUE) , ] 
# bestEntriesAUCCC<- subset(sortedAUCCC, pValCCTrainVar<0.05)
# 
# regResultsBestMLO <- regResultsCtrl
# sortedAUCMLO <- regResultsBestMLO[order(regResultsBestMLO$AUCMLO, regResultsBestMLO$Variable, decreasing = TRUE) , ] 
# bestEntriesAUCMLO<-subset(sortedAUCMLO, pValMLOTrainVar<0.05)
# 
# nCharts <- min(nrow(bestEntriesAUCCC), nrow(bestEntriesAUCMLO))
# 
# write.csv(regResultsBestCC, file = paste(savePath,dateOfAnalysis,"regResultsAUCCCControls.csv", sep=""),row.names=TRUE)
# write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCCCControls.csv", sep=""),row.names=TRUE)
# write.csv(regResultsBestMLO, file = paste(savePath,dateOfAnalysis,"regResultsAUCMLOControls.csv", sep=""),row.names=TRUE)
# write.csv(bestEntriesAUCMLO, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCMLOControls.csv", sep=""),row.names=TRUE)
# 
# #Conditional Logistic Regression after controlling for BIRADS/Demographic Information WITH K-Folds (To Determine if Overfit)#####
# 
# nCols <- ncol(allData)
# regResultsCtrl <- data.frame(matrix(ncol = 13, nrow = (nCols-5)))
# colnames(regResultsCtrl) <- c('Variable','pValCCTrainSXA','pValCCTrainVar', 'pValMLOTrainSXA', 
#                               'pValMLOTrainVar','pctCorrTestCC', 'pctCorrTestMLO', 'AUCCC', 'AUCMLO',
#                               'estimateSXACC','estimateVarCC','estimateSXAMLO','estimateVarMLO')
# 
# pValCCSXA = NULL
# pValCCVar = NULL
# pValMLOSXA = NULL
# pValMLOVar = NULL
# AccuracyCC = NULL
# AccuracyMLO = NULL
# aucCC = NULL
# aucMLO = NULL
# estimateSXACC = NULL
# estimateVarCC = NULL
# estimateSXAMLO = NULL
# estimateVarMLO = NULL
# 
# 
# for (i in 8:nCols){
#   keepVar<- c(keepNoVar, colnames(DataMLO[i]))
#   for(j in 1:10){
#     CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
#     testSetCC <- DataCC[CCtestIndexes, ]
#     trainSetCC <- DataCC[-CCtestIndexes, ]
#     
#     MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
#     testSetMLO <- DataMLO[MLOtestIndexes, ]
#     trainSetMLO <- DataMLO[-MLOtestIndexes, ]
#     # i<-9
#     varT <- i
#     modelDataCC <- trainSetCC[keepVar]
#     
#     model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
#     nControls <- length((rownames(coef(summary(model)))))
#     # print(summary(model))
#     pValCCSXA[j] <- (coef(summary(model))[2,4])
#     pValCCVar[j] <- (coef(summary(model))[nControls,4])
#     estimateSXACC[j] <- (coef(summary(model))[2,1])
#     estimateVarCC[j] <- (coef(summary(model))[nControls,1])
#     
#     
#     testPredictionsData <- testSetCC[keepVar]
#     fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#     fitted.results <- ifelse(fitted.results > 0.5,1,0)
#     misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#     print(paste('Accuracy',1-misClasificError))
#     AccuracyCC[j]<- 1-misClasificError
#     p <- predict(model, newdata=testPredictionsData, type="response")
#     pr <- prediction(p, testPredictionsData$Interval)
#     prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#     # plot(prf)
#     auc <- performance(pr, measure = "auc")
#     aucCC[j] <- auc@y.values[1]
#     print(colnames(allData[i]))
#     auc
#     
#     modelDataMLO <- trainSetMLO[keepVar]
#     model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
#     nControls <- length((rownames(coef(summary(model)))))
#     # summary(model)
#     pValMLOSXA[j] <- (coef(summary(model))[2,4])
#     pValMLOVar[j] <- (coef(summary(model))[nControls,4])
#     estimateSXAMLO[j] <- (coef(summary(model))[2,1])
#     estimateVarMLO[j] <- (coef(summary(model))[nControls,1])
#     
#     testPredictionsData <- testSetMLO[keepVar]
#     fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#     fitted.results <- ifelse(fitted.results > 0.5,1,0)
#     misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#     print(paste('Accuracy',1-misClasificError))
#     AccuracyMLO[j]<- 1-misClasificError
#     p <- predict(model, newdata=testPredictionsData, type="response")
#     pr <- prediction(p, testPredictionsData$Interval)
#     prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#     # plot(prf)
#     auc <- performance(pr, measure = "auc")
#     aucMLO[j] <- auc@y.values[1]
#     print(colnames(allData[i]))
#     auc
#   }
#   regResultsCtrl[(i-5),1] <- colnames(allData[i])
#   regResultsCtrl[(i-5),2] <- mean(pValCCSXA)
#   regResultsCtrl[(i-5),3] <- mean(pValCCVar)
#   regResultsCtrl[(i-5),4] <- mean(pValMLOSXA)
#   regResultsCtrl[(i-5),5] <- mean(pValMLOVar)
#   regResultsCtrl[(i-5),6] <- mean(AccuracyCC, na.rm = TRUE)
#   regResultsCtrl[(i-5),7] <- mean(AccuracyMLO, na.rm = TRUE)
#   regResultsCtrl[(i-5),8] <- mean(unlist(aucCC))
#   regResultsCtrl[(i-5),9] <- mean(unlist(aucMLO))
#   regResultsCtrl[(i-5),10] <- mean(estimateSXACC)
#   regResultsCtrl[(i-5),11] <- mean(estimateVarCC)
#   regResultsCtrl[(i-5),12] <- mean(estimateSXAMLO)
#   regResultsCtrl[(i-5),13] <- mean(estimateVarMLO)
# }
# 
# 
# write.csv(regResultsCtrl, file = paste(savePath,dateOfAnalysis,"regResultsCtrl.csv", sep=""),row.names=TRUE)
# 
# regResultsBestCC <- regResultsCtrl
# sortedAUCCC <- regResultsBestCC[order(regResultsBestCC$AUCCC, regResultsBestCC$Variable, decreasing = TRUE) , ] 
# bestEntriesAUCCC<- subset(sortedAUCCC, pValCCTrainVar<0.05)
# 
# regResultsBestMLO <- regResultsCtrl
# sortedAUCMLO <- regResultsBestMLO[order(regResultsBestMLO$AUCMLO, regResultsBestMLO$Variable, decreasing = TRUE) , ] 
# bestEntriesAUCMLO<-subset(sortedAUCMLO, pValMLOTrainVar<0.05)
# 
# nCharts <- min(nrow(bestEntriesAUCCC), nrow(bestEntriesAUCMLO))
# 
# write.csv(regResultsBestCC, file = paste(savePath,dateOfAnalysis,"regResultsAUCCCControls.csv", sep=""),row.names=TRUE)
# write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCCCControls.csv", sep=""),row.names=TRUE)
# write.csv(regResultsBestMLO, file = paste(savePath,dateOfAnalysis,"regResultsAUCMLOControls.csv", sep=""),row.names=TRUE)
# write.csv(bestEntriesAUCMLO, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCMLOControls.csv", sep=""),row.names=TRUE)
# 
# #******Make sure I calculate NRI #####
# #****** Change the variable names to be better/more descriptive #####
