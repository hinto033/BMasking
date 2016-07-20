

#Inputs:
install.packages("R.matlab")

setwd("Y:\\Projects-Snap\\aaSTUDIES\\Breast Studies\\Auto Dense Study\\Reading List\\CaseControlAfter2009")
baseData <- read.csv("casecon2009.csv", header=TRUE)
baseData1 <- na.omit(baseData) #Clears any rows that have NA entries (Small number)

fullData <- baseData1
r <- dim(baseData1)
nRows <- r[1]
setwd("W:\\Breast Studies\\Masking\\BJH_MaskingMaps")

for (i in 1:nRows){
  k<-baseData1$acquisition_id_L[i]
  nameData <- paste("Case_Control_After_2009_Dicom_",k,".dcm_GeneratedStatistics.mat", sep="")
  
  
  isReal <- file.exists(nameData)
  if (isReal == "TRUE"){
  imageStats <- readMat(nameData)
  
  fullData$RowNum[i] <- i
  fullData$confirmScanNumber[i] <- k
  
  
  fullData$largeMean[i] <- imageStats$stats[,,1]$Large[,,1]$Mean[1,1]
  fullData$largeMedian[i] <- imageStats$stats[,,1]$Large[,,1]$Median[1,1]
  fullData$largeStDev[i] <- imageStats$stats[,,1]$Large[,,1]$StDev[1,1]
  fullData$largeSum[i] <- imageStats$stats[,,1]$Large[,,1]$Sum[1,1]
  fullData$largeEntropy[i] <- imageStats$stats[,,1]$Large[,,1]$Entropy[1,1]
  fullData$largeKurtosis[i] <- imageStats$stats[,,1]$Large[,,1]$Kurtosis[1,1]
  fullData$largeSkewness[i] <- imageStats$stats[,,1]$Large[,,1]$Skewness[1,1]
  fullData$largePctile10[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile10[1,1]
  fullData$largePctile25[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile25[1,1]
  fullData$largePctile75[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile75[1,1]
  fullData$largePctile90[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile90[1,1]
  fullData$largeGLCMContrast[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMContrast[1,1]
  fullData$largeGLCMCorr[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMCorr[1,1]
  fullData$largeGLCMEnergy[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMEnergy[1,1]
  fullData$largeGLCMHomog[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMHomog[1,1]
  
  fullData$mediumMean[i] <- imageStats$stats[,,1]$Medium[,,1]$Mean[1,1]
  fullData$mediumMedian[i] <- imageStats$stats[,,1]$Medium[,,1]$Median[1,1]
  fullData$mediumStDev[i] <- imageStats$stats[,,1]$Medium[,,1]$StDev[1,1]
  fullData$mediumSum[i] <- imageStats$stats[,,1]$Medium[,,1]$Sum[1,1]
  fullData$mediumEntropy[i] <- imageStats$stats[,,1]$Medium[,,1]$Entropy[1,1]
  fullData$mediumKurtosis[i] <- imageStats$stats[,,1]$Medium[,,1]$Kurtosis[1,1]
  fullData$mediumSkewness[i] <- imageStats$stats[,,1]$Medium[,,1]$Skewness[1,1]
  fullData$mediumPctile10[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile10[1,1]
  fullData$mediumPctile25[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile25[1,1]
  fullData$mediumPctile75[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile75[1,1]
  fullData$mediumPctile90[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile90[1,1]
  fullData$mediumGLCMContrast[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMContrast[1,1]
  fullData$mediumGLCMCorr[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMCorr[1,1]
  fullData$mediumGLCMEnergy[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMEnergy[1,1]
  fullData$mediumGLCMHomog[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMHomog[1,1]
  # 
  fullData$smallMean[i] <- imageStats$stats[,,1]$Small[,,1]$Mean[1,1]
  fullData$smallMedian[i] <- imageStats$stats[,,1]$Small[,,1]$Median[1,1]
  fullData$smallStDev[i] <- imageStats$stats[,,1]$Small[,,1]$StDev[1,1]
  fullData$smallSum[i] <- imageStats$stats[,,1]$Small[,,1]$Sum[1,1]
  fullData$smallEntropy[i] <- imageStats$stats[,,1]$Small[,,1]$Entropy[1,1]
  fullData$smallKurtosis[i] <- imageStats$stats[,,1]$Small[,,1]$Kurtosis[1,1]
  fullData$smallSkewness[i] <- imageStats$stats[,,1]$Small[,,1]$Skewness[1,1]
  fullData$smallPctile10[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile10[1,1]
  fullData$smallPctile25[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile25[1,1]
  fullData$smallPctile75[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile75[1,1]
  fullData$smallPctile90[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile90[1,1]
  fullData$smallGLCMContrast[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMContrast[1,1]
  fullData$smallGLCMCorr[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMCorr[1,1]
  fullData$smallGLCMEnergy[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMEnergy[1,1]
  fullData$smallGLCMHomog[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMHomog[1,1]
  # 
  # 
  fullData$fullMean[i] <- imageStats$stats[,,1]$Full[,,1]$Mean[1,1]
  fullData$fullMedian[i] <- imageStats$stats[,,1]$Full[,,1]$Median[1,1]
  fullData$fullStDev[i] <- imageStats$stats[,,1]$Full[,,1]$StDev[1,1]
  fullData$fullSum[i] <- imageStats$stats[,,1]$Full[,,1]$Sum[1,1]
  fullData$fullEntropy[i] <- imageStats$stats[,,1]$Full[,,1]$Entropy[1,1]
  fullData$fullKurtosis[i] <- imageStats$stats[,,1]$Full[,,1]$Kurtosis[1,1]
  fullData$fullSkewness[i] <- imageStats$stats[,,1]$Full[,,1]$Skewness[1,1]
  fullData$fullPctile10[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile10[1,1]
  fullData$fullPctile25[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile25[1,1]
  fullData$fullPctile75[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile75[1,1]
  fullData$fullPctile90[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile90[1,1]
  fullData$fullGLCMContrast[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMContrast[1,1]
  fullData$fullGLCMCorr[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMCorr[1,1]
  fullData$fullGLCMEnergy[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMEnergy[1,1]
  fullData$fullGLCMHomog[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMHomog[1,1]
  # 
  # 
  fullData$imgBMean[i] <- imageStats$stats[,,1]$imgB[,,1]$Mean[1,1]
  fullData$imgBMedian[i] <- imageStats$stats[,,1]$imgB[,,1]$Median[1,1]
  fullData$imgBSum[i] <- imageStats$stats[,,1]$imgB[,,1]$Sum[1,1]
  fullData$imgBPctile10[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile10[1,1]
  fullData$imgBPctile25[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile25[1,1]
  fullData$imgBPctile75[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile75[1,1]
  fullData$imgBPctile90[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile90[1,1]
  fullData$imgAMean[i] <- imageStats$stats[,,1]$imgA[,,1]$Mean[1,1]
  fullData$imgAMedian[i] <- imageStats$stats[,,1]$imgA[,,1]$Median[1,1]
  fullData$imgASum[i] <- imageStats$stats[,,1]$imgA[,,1]$Sum[1,1]
  fullData$imgAPctile10[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile10[1,1]
  fullData$imgAPctile25[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile25[1,1]
  fullData$imgAPctile75[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile75[1,1]
  fullData$imgAPctile90[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile90[1,1]
  # 
  # 

  
  
  
  print(k)
  }
  
  else if (isReal == "FALSE"){
    
    fullData$RowNum[i] <- NA
    fullData$confirmScanNumber[i] <- NA
    
    fullData$largeMean[i] <- NA
    fullData$largeMedian[i] <- NA
    fullData$largeStDev[i] <- NA
    fullData$largeSum[i] <- NA
    fullData$largeEntropy[i] <- NA
    fullData$largeKurtosis[i] <- NA
    fullData$largeSkewness[i] <- NA
    fullData$largePctile10[i] <- NA
    fullData$largePctile25[i] <- NA
    fullData$largePctile75[i] <- NA
    fullData$largePctile90[i] <- NA
    fullData$largeGLCMContrast[i] <- NA
    fullData$largeGLCMCorr[i] <- NA
    fullData$largeGLCMEnergy[i] <-NA
    fullData$largeGLCMHomog[i] <- NA
    
    fullData$mediumMean[i] <- NA
    fullData$mediumMedian[i] <- NA
    fullData$mediumStDev[i] <- NA
    fullData$mediumSum[i] <- NA
    fullData$mediumEntropy[i] <- NA
    fullData$mediumKurtosis[i] <-NA
    fullData$mediumSkewness[i] <-NA
    fullData$mediumPctile10[i] <- NA
    fullData$mediumPctile25[i] <- NA
    fullData$mediumPctile75[i] <- NA
    fullData$mediumPctile90[i] <- NA
    fullData$mediumGLCMContrast[i] <- NA
    fullData$mediumGLCMCorr[i] <- NA
    fullData$mediumGLCMEnergy[i] <- NA
    fullData$mediumGLCMHomog[i] <- NA
    # 
    fullData$smallMean[i] <- NA
    fullData$smallMedian[i] <- NA
    fullData$smallStDev[i] <-NA
    fullData$smallSum[i] <- NA
    fullData$smallEntropy[i] <- NA
    fullData$smallKurtosis[i] <- NA
    fullData$smallSkewness[i] <- NA
    fullData$smallPctile10[i] <- NA
    fullData$smallPctile25[i] <- NA
    fullData$smallPctile75[i] <- NA
    fullData$smallPctile90[i] <- NA
    fullData$smallGLCMContrast[i] <-NA
    fullData$smallGLCMCorr[i] <- NA
    fullData$smallGLCMEnergy[i] <-NA
    fullData$smallGLCMHomog[i] <- NA
    # 
    # 
    fullData$fullMean[i] <-NA
    fullData$fullMedian[i] <- NA
    fullData$fullStDev[i] <- NA
    fullData$fullSum[i] <- NA
    fullData$fullEntropy[i] <- NA
    fullData$fullKurtosis[i] <- NA
    fullData$fullSkewness[i] <- NA
    fullData$fullPctile10[i] <- NA
    fullData$fullPctile25[i] <- NA
    fullData$fullPctile75[i] <-NA
    fullData$fullPctile90[i] <- NA
    fullData$fullGLCMContrast[i] <- NA
    fullData$fullGLCMCorr[i] <- NA
    fullData$fullGLCMEnergy[i] <- NA
    fullData$fullGLCMHomog[i] <- NA
    # 
    # 
    # 
    fullData$imgAMean[i] <- NA
    fullData$imgAMedian[i] <- NA
    fullData$imgASum[i] <-NA
    fullData$imgAPctile10[i] <- NA
    fullData$imgAPctile25[i] <- NA
    fullData$imgAPctile75[i] <- NA
    fullData$imgAPctile90[i] <- NA
    # 
    # 
    fullData$imgBMean[i] <- NA
    fullData$imgBMedian[i] <- NA
    fullData$imgBSum[i] <-NA
    fullData$imgBPctile10[i] <- NA
    fullData$imgBPctile25[i] <- NA
    fullData$imgBPctile75[i] <- NA
    fullData$imgBPctile90[i] <- NA
  }
  else {}
}
print("DONE")
#####
#Save FullData sometime soon!!!!!!!!
setwd("Z:\\Breast Studies\\CBCRP Masking\\Analyzed Data")
write.table(fullData, file=sprintf("%s.CompiledData.txt","CaseControlAfter2009"))
write.table(fullData, file=sprintf("%s.CompiledData.csv","CaseControlAfter2009"))


#####
relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "mediumMean",
                                    "mediumMedian", "mediumSum", "mediumEntropy",
                                    "mediumKurtosis", "mediumSkewness", "mediumPctile10",
                                    "mediumPctile25", "mediumPctile75", "mediumPctile90",
                                    "mediumGLCMContrast", "mediumGLCMCorr", "mediumGLCMEnergy",
                                    "mediumGLCMHomog")]
medCorVals <- cor(relevantData, relevantData, use="complete")


relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "fullMean",
                            "fullMedian", "fullSum", "fullEntropy",
                            "fullKurtosis", "fullSkewness", "fullPctile10",
                            "fullPctile25", "fullPctile75", "fullPctile90",
                            "fullGLCMContrast", "fullGLCMCorr", "fullGLCMEnergy",
                            "fullGLCMHomog")]
fullCorVals <- cor(relevantData, relevantData, use="complete")

relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "smallMean",
                            "smallMedian", "smallSum", "smallEntropy",
                            "smallKurtosis", "smallSkewness", "smallPctile10",
                            "smallPctile25", "smallPctile75", "smallPctile90",
                            "smallGLCMContrast", "smallGLCMCorr", "smallGLCMEnergy",
                            "smallGLCMHomog")]
smallCorVals <- cor(relevantData, relevantData, use="complete")

relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "largeMean",
                            "largeMedian", "largeSum", "largeEntropy",
                            "largeKurtosis", "largeSkewness", "largePctile10",
                            "largePctile25", "largePctile75", "largePctile90",
                            "largeGLCMContrast", "largeGLCMCorr", "largeGLCMEnergy",
                            "largeGLCMHomog")]
LargeCorVals <- cor(relevantData, relevantData, use="complete")




relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "imgAMean",
                            "imgAMedian", "imgASum", "imgAPctile10",
                            "imgAPctile25", "imgAPctile75", "imgAPctile90")]
aMatrixCorVals <- cor(relevantData, relevantData, use="complete")


relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "imgBMean",
                            "imgBMedian", "imgBSum", "imgBPctile10",
                            "imgBPctile25", "imgBPctile75", "imgBPctile90")]
bMatrixCorVals <- cor(relevantData, relevantData, use="complete")

setwd("Z:\\Breast Studies\\CBCRP Masking\\Analyzed Data")
write.table(medCorVals, file=sprintf("%s.CorrelationData.csv","medium"))
write.table(fullCorVals, file=sprintf("%s.CorrelationData.csv","full"))
write.table(smallCorVals, file=sprintf("%s.CorrelationData.csv","small"))
write.table(LargeCorVals, file=sprintf("%s.CorrelationData.csv","Large"))
write.table(aMatrixCorVals, file=sprintf("%s.CorrelationData.csv","aMatrix"))
write.table(bMatrixCorVals, file=sprintf("%s.CorrelationData.csv","bMatrix"))

write.table(medCorVals, file=sprintf("%s.CorrelationData.txt","medium"))
write.table(fullCorVals, file=sprintf("%s.CorrelationData.txt","full"))
write.table(smallCorVals, file=sprintf("%s.CorrelationData.txt","small"))
write.table(LargeCorVals, file=sprintf("%s.CorrelationData.txt","Large"))
write.table(aMatrixCorVals, file=sprintf("%s.CorrelationData.txt","aMatrix"))
write.table(bMatrixCorVals, file=sprintf("%s.CorrelationData.txt","bMatrix"))


#####

#Plot the VBD Versus different values
#Vs Medium IQF Feature
comparison <- fullData$VPD_L
feature <-fullData$mediumMean 
plot(fullData$VPD_L, feature, main="VPD vs medium Mean IQF", xlab="Percent Density", ylab = "MediumMean IQF Value")
comparison = fullData$VPD_L
feature =fullData$mediumMean 
cor(comparison, feature, use="complete")
feature <-fullData$mediumMedian 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumStDev
plot(fullData$VPD_L, feature, main="VPD vs medium StDev IQF", xlab="Percent Density", ylab = "Medium StDev IQF Value")
feature <-fullData$mediumSum
plot(fullData$VPD_L, feature, main="VPD vs medium Sum IQF", xlab="Percent Density", ylab = "MediumSum IQF Value")
feature <-fullData$mediumEntropy
plot(fullData$VPD_L, feature, main="VPD vs medium Entropy IQF", xlab="Percent Density", ylab = "MediumEntropy IQF Value")
feature <-fullData$mediumKurtosis
plot(fullData$VPD_L, feature, main="VPD vs medium Kurtosis IQF", xlab="Percent Density", ylab = "MediumKurtosis IQF Value")
feature <-fullData$mediumSkewness 
plot(fullData$VPD_L, feature, main="VPD vs medium Skewness IQF", xlab="Percent Density", ylab = "MediumSkewness IQF Value")
feature <-fullData$mediumPctile10 
plot(fullData$VPD_L, feature, main="VPD vs medium 10th Percentile IQF", xlab="Percent Density", ylab = "Medium 10th Percentile IQF Value")
feature <-fullData$mediumPctile25 
plot(fullData$VPD_L, feature, main="VPD vs medium 25th percentile IQF", xlab="Percent Density", ylab = "Medium 25th Percentile IQF Value")
feature <-fullData$mediumPctile75 
plot(fullData$VPD_L, feature, main="VPD vs medium 75th Percentile IQF", xlab="Percent Density", ylab = "Medium 75th percentile IQF Value")
feature <-fullData$mediumPctile90 
plot(fullData$VPD_L, feature, main="VPD vs medium 90the Percentile IQF", xlab="Percent Density", ylab = "Medium 90th Percentile IQF Value")
feature <-fullData$mediumGLCMContrast 
plot(fullData$VPD_L, feature, main="VPD vs medium GLCM Contrast IQF", xlab="Percent Density", ylab = "Medium GLCM Contrast IQF Value")
feature <-fullData$mediumGLCMCorr
plot(fullData$VPD_L, feature, main="VPD vs medium GLCM Correlation IQF", xlab="Percent Density", ylab = "Medium GLCM Correlation IQF Value")
feature <-fullData$mediumGLCMEnergy
plot(fullData$VPD_L, feature, main="VPD vs medium GLCM Energy IQF", xlab="Percent Density", ylab = "Medium GLCM Energy IQF Value")
feature <-fullData$mediumGLCMHomog
plot(fullData$VPD_L, feature, main="VPD vs medium GLCM Homogeneity IQF", xlab="Percent Density", ylab = "Medium GLCM Homogeneity IQF Value")


#Vs Large IQF Feature
feature <-fullData$largeMean 
plot(fullData$VPD_L, feature, main="VPD vs large mean IQF", xlab="Percent Density", ylab = "Large mean IQF Value")
feature <-fullData$largeMedian 
plot(fullData$VPD_L, feature, main="VPD vs large median IQF", xlab="Percent Density", ylab = "Large Median IQF Value")
feature <-fullData$largeStDev
plot(fullData$VPD_L, feature, main="VPD vs large St Dev IQF", xlab="Percent Density", ylab = "Large St Dev IQF Value")
feature <-fullData$largeSum
plot(fullData$VPD_L, feature, main="VPD vs large Sum IQF", xlab="Percent Density", ylab = "Large Sum IQF Value")
feature <-fullData$largeEntropy
plot(fullData$VPD_L, feature, main="VPD vs large Entropy IQF", xlab="Percent Density", ylab = "Large Entropy IQF Value")
feature <-fullData$largeKurtosis
plot(fullData$VPD_L, feature, main="VPD vs large Kurtosis IQF", xlab="Percent Density", ylab = "Large Kurtosis IQF Value")
feature <-fullData$largeSkewness 
plot(fullData$VPD_L, feature, main="VPD vs large Skewness IQF", xlab="Percent Density", ylab = "Large Skewness IQF Value")
feature <-fullData$largePctile10 
plot(fullData$VPD_L, feature, main="VPD vs large 10th Percentile IQF", xlab="Percent Density", ylab = "Large 10th Percentile IQF Value")
feature <-fullData$largePctile25 
plot(fullData$VPD_L, feature, main="VPD vs large 25th Percentile IQF", xlab="Percent Density", ylab = "Large 25th Percentile IQF Value")
feature <-fullData$largePctile75 
plot(fullData$VPD_L, feature, main="VPD vs large 75th Percentile IQF", xlab="Percent Density", ylab = "Large 75th percentile IQF Value")
feature <-fullData$largePctile90 
plot(fullData$VPD_L, feature, main="VPD vs large 90th Percentile IQF", xlab="Percent Density", ylab = "Large 90th percentile IQF Value")
feature <-fullData$largeGLCMContrast 
plot(fullData$VPD_L, feature, main="VPD vs large GLCM Contrast IQF", xlab="Percent Density", ylab = "Large GLCM Contrast IQF Value")
feature <-fullData$largeGLCMCorr
plot(fullData$VPD_L, feature, main="VPD vs large GLCM Correlation IQF", xlab="Percent Density", ylab = "Large GLCM Correlation IQF Value")
feature <-fullData$largeGLCMEnergy
plot(fullData$VPD_L, feature, main="VPD vs large GLCM Energy IQF", xlab="Percent Density", ylab = "Large GLCM Energy IQF Value")
feature <-fullData$largeGLCMHomog
plot(fullData$VPD_L, feature, main="VPD vs large GLCM Homogeneity IQF", xlab="Percent Density", ylab = "Large GLCM Homogeneity IQF Value")


#Vs small IQF Feature
feature <-fullData$smallMean 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Mean IQF Value")
feature <-fullData$smallMedian 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Median IQF Value")
feature <-fullData$smallStDev
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small St Dev IQF Value")
feature <-fullData$smallSum
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Sum IQF Value")
feature <-fullData$smallEntropy
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Entropy IQF Value")
feature <-fullData$smallKurtosis
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Kurtosis IQF Value")
feature <-fullData$smallSkewness 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Skewness IQF Value")
feature <-fullData$smallPctile10 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small 10th percentile IQF Value")
feature <-fullData$smallPctile25 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small 25th Percentile IQF Value")
feature <-fullData$smallPctile75 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small 75th Percentile IQF Value")
feature <-fullData$smallPctile90 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small 90th Percentile IQF Value")
feature <-fullData$smallGLCMContrast 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small GLCM COntrast IQF Value")
feature <-fullData$smallGLCMCorr
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small GLCM Correlation IQF Value")
feature <-fullData$smallGLCMEnergy
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small GLCM Energy IQF Value")
feature <-fullData$smallGLCMHomog
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small GLCM Homogeneiyt IQF Value")


#Vs full IQF Feature
feature <-fullData$fullMean 
plot(fullData$VPD_L, feature, main="VPD vs full Mean IQF", xlab="Percent Density", ylab = "Full Mean IQF Value")
feature <-fullData$fullMedian 
plot(fullData$VPD_L, feature, main="VPD vs full median IQF", xlab="Percent Density", ylab = "Full Median IQF Value")
feature <-fullData$fullStDev
plot(fullData$VPD_L, feature, main="VPD vs full StDev IQF", xlab="Percent Density", ylab = "full StDev IQF Value")
feature <-fullData$fullSum
plot(fullData$VPD_L, feature, main="VPD vs full Sum IQF", xlab="Percent Density", ylab = "Full Sum IQF Value")
feature <-fullData$fullEntropy
plot(fullData$VPD_L, feature, main="VPD vs full Entropy IQF", xlab="Percent Density", ylab = "Full Entropy IQF Value")
feature <-fullData$fullKurtosis
plot(fullData$VPD_L, feature, main="VPD vs full Kurtosis IQF", xlab="Percent Density", ylab = "Full Kurtosis IQF Value")
feature <-fullData$fullSkewness 
plot(fullData$VPD_L, feature, main="VPD vs full Skewness IQF", xlab="Percent Density", ylab = "Full Skewness IQF Value")
feature <-fullData$fullPctile10 
plot(fullData$VPD_L, feature, main="VPD vs full 10th Percentile IQF", xlab="Percent Density", ylab = "Full 10th percentile IQF Value")
feature <-fullData$fullPctile25 
plot(fullData$VPD_L, feature, main="VPD vs full 25th Percentile IQF", xlab="Percent Density", ylab = "Full 25th Percentile IQF Value")
feature <-fullData$fullPctile75 
plot(fullData$VPD_L, feature, main="VPD vs full 75th Percentile IQF", xlab="Percent Density", ylab = "Full 75th percentile IQF Value")
feature <-fullData$fullPctile90 
plot(fullData$VPD_L, feature, main="VPD vs full 90th Percentile IQF", xlab="Percent Density", ylab = "Full 90th percentile IQF Value")
feature <-fullData$fullGLCMContrast 
plot(fullData$VPD_L, feature, main="VPD vs full GLCM Contrast IQF", xlab="Percent Density", ylab = "Full GLCM Contrast IQF Value")
feature <-fullData$fullGLCMCorr
plot(fullData$VPD_L, feature, main="VPD vs full GLCM Correlation IQF", xlab="Percent Density", ylab = "Full GLCM Correlation IQF Value")
feature <-fullData$fullGLCMEnergy
plot(fullData$VPD_L, feature, main="VPD vs full Full GLCM Energy IQF", xlab="Percent Density", ylab = "Full GLCM Energy IQF Value")
feature <-fullData$fullGLCMHomog
plot(fullData$VPD_L, feature, main="VPD vs full GLCM Homogeneity IQF", xlab="Percent Density", ylab = "Full GLCM Homogeneity IQF Value")



# A Value of Exp Fit of Image Stats
#Vs full IQF Feature
feature <-fullData$imgAMean
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit mean IQF", xlab="Percent Density", ylab = "A Exp Fit Mean IQF Value")
feature <-fullData$imgAMedian 
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit Median IQF", xlab="Percent Density", ylab = "A Exp Fit Median IQF Value")
feature <-fullData$imgASum
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit Sum IQF", xlab="Percent Density", ylab = "A Exp Fit Sum IQF Value")
feature <-fullData$imgAPctile10
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit 10th percentile IQF", xlab="Percent Density", ylab = "A Exp Fit 10th percentile IQF Value")
feature <-fullData$imgAPctile25
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit 25th percentile IQF", xlab="Percent Density", ylab = "A Exp Fit 25th percentile IQF Value")
feature <-fullData$imgAPctile75
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit 75th percentile IQF", xlab="Percent Density", ylab = "A Exp Fit 75th percentile IQF Value")
feature <-fullData$imgAPctile90 
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit 90th percentile IQF", xlab="Percent Density", ylab = "A Exp Fit 90th percentile IQF Value")

# A Value of Exp Fit of Image Stats
#Vs full IQF Feature
feature <-fullData$imgBMean
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit Mean", xlab="Percent Density", ylab = "B Exp Fit Mean IQF Value")
feature <-fullData$imgBMedian 
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit Median", xlab="Percent Density", ylab = "B Exp Fit Median IQF Value")
feature <-fullData$imgBSum
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit Sum", xlab="Percent Density", ylab = "B Exp Fit Sum IQF Value")
feature <-fullData$imgBPctile10
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit 10th percentile IQF", xlab="Percent Density", ylab = "B Exp Fit 10th Percentile IQF Value")
feature <-fullData$imgBPctile25
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit 25th percentile IQF", xlab="Percent Density", ylab = "B Exp Fit 25th percentile IQF Value")
feature <-fullData$imgBPctile75
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit 75th percentile IQF", xlab="Percent Density", ylab = "B Exp Fit 75th percentile IQF Value")
feature <-fullData$imgBPctile90 
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit 90th percentile IQF", xlab="Percent Density", ylab = "B Exp Fit 90th Percentile IQF Value")


#####
#Plot the Dense Breast Volume Versus different values
feature <-fullData$smallMedian
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallMean 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallMedian 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallStDev
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallSum
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallEntropy
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallKurtosis
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallSkewness 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallPctile10 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallPctile25 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallPctile75 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallPctile90 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallGLCMContrast 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallGLCMCorr
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallGLCMEnergy
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallGLCMHomog
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
#####
#Plot the Breast Volume Versus different values
feature <-fullData$mediumMedian
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMean 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumStDev
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSum
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumEntropy
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumKurtosis
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSkewness 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile10 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile25 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile75 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile90 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMContrast 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMCorr
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMEnergy
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMHomog
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
#####
#Plot the box and whisker plot of values vs birads 1, 2, 3, 4
#Medium IQF Image Stats
feature <-fullData$mediumMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Mean IQF")
feature <-fullData$mediumMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Median IQF")
feature <-fullData$mediumStDev
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium StDev IQF")
feature <-fullData$mediumSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Sum IQF")
feature <-fullData$mediumEntropy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Entropy IQF")
feature <-fullData$mediumKurtosis
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Kurtosis IQF")
feature <-fullData$mediumSkewness 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Skewness IQF")
feature <-fullData$mediumPctile10 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 10th Percentile IQF")
feature <-fullData$mediumPctile25 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 25th percentile IQF")
feature <-fullData$mediumPctile75 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 75th Percentile IQF")
feature <-fullData$mediumPctile90 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 90th Percentile IQF")
feature <-fullData$mediumGLCMContrast 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Contrast IQF")
feature <-fullData$mediumGLCMCorr
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Corr IQF")
feature <-fullData$mediumGLCMEnergy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Energy IQF")
feature <-fullData$mediumGLCMHomog
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Homogeneity IQF")
# Large IQF Image Stats
feature <-fullData$largeMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Mean IQF")
feature <-fullData$largeMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Median IQF")
feature <-fullData$largeStDev
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large StDev IQF")
feature <-fullData$largeSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Sum IQF")
feature <-fullData$largeEntropy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Entropy IQF")
feature <-fullData$largeKurtosis
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Kurtosis IQF")
feature <-fullData$largeSkewness 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Skewness IQF")
feature <-fullData$largePctile10 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 10th Percentile IQF")
feature <-fullData$largePctile25 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 25th percentile IQF")
feature <-fullData$largePctile75 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 75th Percentile IQF")
feature <-fullData$largePctile90 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 90th Percentile IQF")
feature <-fullData$largeGLCMContrast 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Contrast IQF")
feature <-fullData$largeGLCMCorr
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Corr IQF")
feature <-fullData$largeGLCMEnergy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Energy IQF")
feature <-fullData$largeGLCMHomog
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Homogeneity IQF")
# Small IQF Image Stats
feature <-fullData$smallMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Mean IQF")
feature <-fullData$smallMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Median IQF")
feature <-fullData$smallStDev
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small StDev IQF")
feature <-fullData$smallSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Sum IQF")
feature <-fullData$smallEntropy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Entropy IQF")
feature <-fullData$smallKurtosis
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Kurtosis IQF")
feature <-fullData$smallSkewness 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Skewness IQF")
feature <-fullData$smallPctile10 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 10th Percentile IQF")
feature <-fullData$smallPctile25 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 25th percentile IQF")
feature <-fullData$smallPctile75 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 75th Percentile IQF")
feature <-fullData$smallPctile90 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 90th Percentile IQF")
feature <-fullData$smallGLCMContrast 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Contrast IQF")
feature <-fullData$smallGLCMCorr
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Corr IQF")
feature <-fullData$smallGLCMEnergy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Energy IQF")
feature <-fullData$smallGLCMHomog
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Homogeneity IQF")
# Full IQF Image Stats
feature <-fullData$fullMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Mean IQF")
feature <-fullData$fullMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Median IQF")
feature <-fullData$fullStDev
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full StDev IQF")
feature <-fullData$fullSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Sum IQF")
feature <-fullData$fullEntropy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Entropy IQF")
feature <-fullData$fullKurtosis
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Kurtosis IQF")
feature <-fullData$fullSkewness 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Skewness IQF")
feature <-fullData$fullPctile10 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 10th Percentile IQF")
feature <-fullData$fullPctile25 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$fullPctile75 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$fullPctile90 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$fullGLCMContrast 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$fullGLCMCorr
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$fullGLCMEnergy
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$fullGLCMHomog
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")
# A Value of Exp Fit of Image Stats
feature <-fullData$imgAMean
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value Mean IQF")
feature <-fullData$imgAMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value Median IQF")
feature <-fullData$imgASum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value Sum IQF")
feature <-fullData$imgAPctile10
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value 10th percentile IQF")
feature <-fullData$imgAPctile25
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value 25th percentile IQF")
feature <-fullData$imgAPctile75
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value 75th percentile IQF")
feature <-fullData$imgAPctile90
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit A Value 90th percentile IQF")
# B Value of Exp Fit of Image Stats
feature <-fullData$imgBMean
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value Mean IQF")
feature <-fullData$imgBMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value Median IQF")
feature <-fullData$imgBSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value Sum IQF")
feature <-fullData$imgBPctile10
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value 10th percentile IQF")
feature <-fullData$imgBPctile25
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value 25th percentile IQF")
feature <-fullData$imgBPctile75
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value 75th percentile IQF")
feature <-fullData$imgBPctile90
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Exp Fit B Value 90th percentile IQF")
#####
#Plot the box and whisker plot of values vs Cancer case
#Medium IQF Image Stats
feature <-fullData$mediumMean 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Mean IQF")
feature <-fullData$mediumMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Median IQF")
feature <-fullData$mediumStDev
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium StDev IQF")
feature <-fullData$mediumSum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Sum IQF")
feature <-fullData$mediumEntropy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Entropy IQF")
feature <-fullData$mediumKurtosis
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Kurtosis IQF")
feature <-fullData$mediumSkewness 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Skewness IQF")
feature <-fullData$mediumPctile10 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 10th Percentile IQF")
feature <-fullData$mediumPctile25 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 25th percentile IQF")
feature <-fullData$mediumPctile75 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 75th Percentile IQF")
feature <-fullData$mediumPctile90 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium 90th Percentile IQF")
feature <-fullData$mediumGLCMContrast 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Contrast IQF")
feature <-fullData$mediumGLCMCorr
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Corr IQF")
feature <-fullData$mediumGLCMEnergy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Energy IQF")
feature <-fullData$mediumGLCMHomog
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium GLCM Homogeneity IQF")
#Large IQF Image Stats
feature <-fullData$largeMean 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Mean IQF")
feature <-fullData$largeMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Median IQF")
feature <-fullData$largeStDev
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large StDev IQF")
feature <-fullData$largeSum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Sum IQF")
feature <-fullData$largeEntropy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Entropy IQF")
feature <-fullData$largeKurtosis
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Kurtosis IQF")
feature <-fullData$largeSkewness 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Skewness IQF")
feature <-fullData$largePctile10 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 10th Percentile IQF")
feature <-fullData$largePctile25 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 25th percentile IQF")
feature <-fullData$largePctile75 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 75th Percentile IQF")
feature <-fullData$largePctile90 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large 90th Percentile IQF")
feature <-fullData$largeGLCMContrast 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Contrast IQF")
feature <-fullData$largeGLCMCorr
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Corr IQF")
feature <-fullData$largeGLCMEnergy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Energy IQF")
feature <-fullData$largeGLCMHomog
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large GLCM Homogeneity IQF")
#Small IQF Image Stats
feature <-fullData$smallMean 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Mean IQF")
feature <-fullData$smallMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Median IQF")
feature <-fullData$smallStDev
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small StDev IQF")
feature <-fullData$smallSum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Sum IQF")
feature <-fullData$smallEntropy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Entropy IQF")
feature <-fullData$smallKurtosis
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Kurtosis IQF")
feature <-fullData$smallSkewness 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small Skewness IQF")
feature <-fullData$smallPctile10 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 10th Percentile IQF")
feature <-fullData$smallPctile25 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 25th percentile IQF")
feature <-fullData$smallPctile75 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 75th Percentile IQF")
feature <-fullData$smallPctile90 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small 90th Percentile IQF")
feature <-fullData$smallGLCMContrast 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Contrast IQF")
feature <-fullData$smallGLCMCorr
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Corr IQF")
feature <-fullData$smallGLCMEnergy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Energy IQF")
feature <-fullData$smallGLCMHomog
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Small GLCM Homogeneity IQF")
#Full IQF Image Stats
feature <-fullData$fullMean 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Mean IQF")
feature <-fullData$fullMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Median IQF")
feature <-fullData$fullStDev
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full StDev IQF")
feature <-fullData$fullSum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Sum IQF")
feature <-fullData$fullEntropy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Entropy IQF")
feature <-fullData$fullKurtosis
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Kurtosis IQF")
feature <-fullData$fullSkewness 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full Skewness IQF")
feature <-fullData$fullPctile10 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 10th Percentile IQF")
feature <-fullData$fullPctile25 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$fullPctile75 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$fullPctile90 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$fullGLCMContrast 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$fullGLCMCorr
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$fullGLCMEnergy
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$fullGLCMHomog
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")
#A of Exp Fit of IQF Image Stats
feature <-fullData$imgAMean
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$imgAMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$imgASum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$imgAPctile10
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$imgAPctile25
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$imgAPctile75
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$imgAPctile90
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")
#B of Exp Fit of IQF Image Stats
feature <-fullData$imgBMean
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$imgBMedian 
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$imgBSum
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$imgBPctile10
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$imgBPctile25
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$imgBPctile75
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$imgBPctile90
boxplot(feature~fullData$bc_case, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")

# 
# bc_case
# bc <- factor(fullData$bc_case)
# mylogit<- glm(bc~fullData$mediumMedian + fullData$mediumPctile10, family="binomial")
# summary(mylogit)