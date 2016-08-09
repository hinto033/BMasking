

#Inputs:
install.packages("R.matlab")

setwd("Y:\\Projects-Snap\\aaSTUDIES\\Breast Studies\\Auto Dense Study\\Reading List\\CaseControlAfter2009")
baseData <- read.csv("casecon2009.csv", header=TRUE)
baseData1 <- na.omit(baseData) #Clears any rows that have NA entries (Small number)

fullData <- baseData1
r <- dim(baseData1)
nRows <- r[1]
setwd("W:\\Breast Studies\\Masking\\BJH_MaskingMaps")

thresh <- 5

for (i in 1:nRows){
  k<-baseData1$acquisition_id_L[i]
  print(k)
  nameData <- paste("Case_Control_After_2009_Dicom_",k,".dcm_IQFFullDisks.mat", sep="")
  isReal <- file.exists(nameData)
  if (isReal == "TRUE"){
  imageStats <- readMat(nameData)
#   
#   fullData$RowNum[i] <- i
#   fullData$confirmScanNumber[i] <- k
#   
  rowNum <- nrow(imageStats$IQFFull)
  colNum <- ncol(imageStats$IQFFull)
  totalPixels <- rowNum*colNum - length(which(imageStats$IQFFull==0 ))
#   
  fullData$AmountAboveThresh[i] <- length(which(imageStats$IQFFull<thresh & imageStats$IQFFull!=0))
  fullData$pctBelow[i] <- fullData$AmountAboveThresh[i]/totalPixels
#   
  print(totalPixels)
  print(fullData$AmountAboveThresh[i])
  print(fullData$pctBelow[i])
  if (totalPixels == 0 | fullData$AmountAboveThresh[i]==0){
    fullData$pctBelow[i] <- NA
  }
  
  
  }
  else if (isReal == "FALSE"){
    fullData$AmountAboveThresh[i] <- NA
    fullData$pctBelow[i] <- NA
  }
  else {}
}
print("DONE")
#####
#Save FullData sometime soon!!!!!!!!
setwd("Z:\\Breast Studies\\CBCRP Masking\\Analyzed Data")
write.table(fullData, file=sprintf("%s.pctBelowThresh5.txt","CaseControlAfter2009"))
write.table(fullData, file=sprintf("%s.pctBelowThresh5.csv","CaseControlAfter2009"))


#####
relevantData <- fullData[,c("density","bc_case","VPD_L", "BrstVol_V_L", "DenVol_V_L", "fullData$AmountAboveThresh",
                                    "fullData$pctBelow")]
CorVals <- cor(relevantData, relevantData, use="complete")


setwd("Z:\\Breast Studies\\CBCRP Masking\\Analyzed Data")
write.table(medCorVals, file=sprintf("%s.CorrelationData.csv","medium"))
write.table(medCorVals, file=sprintf("%s.CorrelationData.txt","medium"))



#####

setwd("Z:\\Breast Studies\\CBCRP Masking")
baseData <- read.csv("CaseControlAfter2009.CompiledData8.7.16.csv", header=TRUE, sep=" ")
baseData1 <- na.omit(baseData) #Clears any rows that have NA entries (Small number)

fullData <- baseData1



#Plot the VBD Versus different values
#Vs Medium IQF Feature
comparison <- fullData$VPD_L
feature <-fullData$pctBelow 
plot(fullData$VPD_L, feature, main="VPD vs PCT Below", xlab="Percent Below Threshold", ylab = "MediumMean IQF Value")
comparison = fullData$VPD_L
feature =fullData$AmountAboveThresh 
plot(fullData$VPD_L, feature, main="VPD vs Amount below", xlab="Amount Below Threshold", ylab = "MediumMedian IQF Value")


feature <-fullData$density 
boxplot(feature~fullData$pctBelow, main = "PctBelow vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Mean IQF")
feature <-fullData$density 
boxplot(feature~fullData$AmountAboveThresh , main = "Amnt Below Thresh vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Median IQF")




#Vs Large IQF Feature
feature <-fullData$largeMean 
plot(fullData$VPD_L, feature, main="VPD vs large mean IQF", xlab="Percent Density", ylab = "Large mean IQF Value")
feature <-fullData$largeMedian 
plot(fullData$VPD_L, feature, main="VPD vs large median IQF", xlab="Percent Density", ylab = "Large Median IQF Value")


#Vs small IQF Feature
feature <-fullData$smallMean 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Mean IQF Value")
feature <-fullData$smallMedian 
plot(fullData$VPD_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "Small Median IQF Value")


#Vs full IQF Feature
feature <-fullData$fullMean 
plot(fullData$VPD_L, feature, main="VPD vs full Mean IQF", xlab="Percent Density", ylab = "Full Mean IQF Value")
feature <-fullData$fullMedian 
plot(fullData$VPD_L, feature, main="VPD vs full median IQF", xlab="Percent Density", ylab = "Full Median IQF Value")


# A Value of Exp Fit of Image Stats
#Vs full IQF Feature
feature <-fullData$imgAMean
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit mean IQF", xlab="Percent Density", ylab = "A Exp Fit Mean IQF Value")
feature <-fullData$imgAMedian 
plot(fullData$VPD_L, feature, main="VPD vs A Exp Fit Median IQF", xlab="Percent Density", ylab = "A Exp Fit Median IQF Value")

# A Value of Exp Fit of Image Stats
#Vs full IQF Feature
feature <-fullData$imgBMean
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit Mean", xlab="Percent Density", ylab = "B Exp Fit Mean IQF Value")
feature <-fullData$imgBMedian 
plot(fullData$VPD_L, feature, main="VPD vs B Exp Fit Median", xlab="Percent Density", ylab = "B Exp Fit Median IQF Value")



#####
#Plot the Dense Breast Volume Versus different values
feature <-fullData$smallMedian
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")
feature <-fullData$smallMean 
plot(fullData$DenVol_V_L, feature, main="VPD vs small median IQF", xlab="Percent Density", ylab = "smallMedian IQF Value")

#####
#Plot the Breast Volume Versus different values
feature <-fullData$mediumMedian
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")
feature <-fullData$mediumMean 
plot(fullData$BrstVol_V_L, feature, main="VPD vs medium median IQF", xlab="Percent Density", ylab = "MediumMedian IQF Value")

#####
#Plot the box and whisker plot of values vs birads 1, 2, 3, 4
#Medium IQF Image Stats
feature <-fullData$mediumMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Mean IQF")
feature <-fullData$mediumMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Medium Median IQF")

# Large IQF Image Stats
feature <-fullData$largeMean 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Mean IQF")
feature <-fullData$largeMedian 
boxplot(feature~fullData$density, main = "Feature vs. BI-RADS Category", xlab ="BIRADS Category", ylab="Large Median IQF")

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