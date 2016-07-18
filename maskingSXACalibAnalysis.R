

#Inputs:
# install.packages("R.matlab")

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
#Save FullData sometime soon!!!!!!!!
setwd("Z:\\Breast Studies\\CBCRP Masking\\Analyzed Data")
write.table(fullData, file=sprintf("%s.CompiledData.txt","CaseControlAfter2009"))
write.table(fullData, file=sprintf("%s.CompiledData.csv","CaseControlAfter2009"))


#Plot the VBD Versus different values
feature <-fullData$mediumMedian
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")



feature <-fullData$mediumMedian
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMean 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMedian 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumStDev
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSum
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumEntropy
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumKurtosis
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSkewness 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile10 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile25 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile75 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile90 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMContrast 
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMCorr
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMEnergy
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMHomog
plot(fullData$VPD_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")


# abline(lm(fullData$mediumMedian~fullData$VPD_L), col="red") # regression line (y~x) 





#Plot the Dense Breast Volume Versus different values
plot()
DenVol_V_L

feature <-fullData$mediumMedian
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMean 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMedian 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumStDev
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSum
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumEntropy
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumKurtosis
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumSkewness 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile10 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile25 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile75 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumPctile90 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMContrast 
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMCorr
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMEnergy
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumGLCMHomog
plot(fullData$DenVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")



#Plot the Breast Volume Versus different values
plot()
BrstVol_V_L

feature <-fullData$mediumMedian
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMean 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMedian 
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



#Plot the box and whisker plot of values vs birads 1, 2, 3, 4

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




fullData$imgAMean[i] <- imageStats$stats[,,1]$imgA[,,1]$Mean[1,1]
fullData$imgAMedian[i] <- imageStats$stats[,,1]$imgA[,,1]$Median[1,1]
fullData$imgASum[i] <- imageStats$stats[,,1]$imgA[,,1]$Sum[1,1]
fullData$imgAPctile10[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile10[1,1]
fullData$imgAPctile25[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile25[1,1]
fullData$imgAPctile75[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile75[1,1]
fullData$imgAPctile90[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile90[1,1]


feature <-fullData$imgAMean
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$imgAMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$imgASum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$imgAPctile10
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$imgAPctile25
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$imgAPctile75
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$imgAPctile90
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")




feature <-fullData$imgBMean
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 25th percentile IQF")
feature <-fullData$imgBMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 75th Percentile IQF")
feature <-fullData$imgBSum
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full 90th Percentile IQF")
feature <-fullData$imgBPctile10
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Contrast IQF")
feature <-fullData$imgBPctile25
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Corr IQF")
feature <-fullData$imgBPctile75
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Energy IQF")
feature <-fullData$imgBPctile90
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Full GLCM Homogeneity IQF")


#Do predictive case of logistic test of cancer vs my values.
bc_case
bc <- factor(fullData$bc_case)
mylogit<- glm(bc~fullData$mediumMedian + fullData$mediumPctile10, family="binomial")
summary(mylogit)