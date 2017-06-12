
#####
# Installs necessary packages to do the analysis
install.packages("R.matlab")
install.packages("ROCR")
install.packages("dplyr")
install.packages("e1071")
install.packages("ICC")
install.packages("lattice")
install.packages("psych")
require("R.matlab")
require("ROCR")
require("dplyr")
require("e1071")
require("ICC")
require("lattice")
require("psych")
#####
#Defines the dataset that I'll analyze
#Similar patches by mean/stdev

dateOfAnalysis = "3.27.16"
savePath = "W:\\Breast Studies\\Masking\\AnalysisImages\\"

#Similar By Statistics
wdInt <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_SimilarStat\\Interval"
wdScreen <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_SimilarStat\\ScreenDetected"

#Similar Patches by location
# wdInt <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_SimilarLoc\\Interval"
# wdScreen <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_SimilarLoc\\ScreenDetected"

# #Simulated Patches
# wdInt <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_Simulated\\Interval"
# wdScreen <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\3.27.17_CompiledData_Simulated\\ScreenDetected"

##### 
# Imports the dataset of the interval and screen detected cancers and places them in two tables
setwd(wdInt)
fileNames <- list.files(wdInt)
nRows <- length(fileNames)
intData <- data.frame(num=1:nRows)
for (i in 1:nRows){
  imageStats <- readMat(fileNames[i])
  
  intData$fileName[i] <- fileNames[i]
  intData$tmp[i] <- strsplit(fileNames[i], '_')[[1]][2]
  intData$acquisition_id[i] <- strsplit(intData$tmp[i], '[.]')[[1]][1]
  intData$view[i] <- imageStats$stats[,,1]$DICOMData[,,1]$Position[1,1]
  intData$Interval <- 1
  intData$ScreenDetected <- 0
  intData$largeMean[i] <- imageStats$stats[,,1]$Large[,,1]$Mean[1,1]
  intData$largeMedian[i] <- imageStats$stats[,,1]$Large[,,1]$Median[1,1]
  intData$largeStDev[i] <- imageStats$stats[,,1]$Large[,,1]$StDev[1,1]
  intData$largeSum[i] <- imageStats$stats[,,1]$Large[,,1]$Sum[1,1]
  intData$largeEntropy[i] <- imageStats$stats[,,1]$Large[,,1]$Entropy[1,1]
  intData$largeKurtosis[i] <- imageStats$stats[,,1]$Large[,,1]$Kurtosis[1,1]
  intData$largeSkewness[i] <- imageStats$stats[,,1]$Large[,,1]$Skewness[1,1]
  intData$largePctile10[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile10[1,1]
  intData$largePctile25[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile25[1,1]
  intData$largePctile75[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile75[1,1]
  intData$largePctile90[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile90[1,1]
  intData$largePctBelowPnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelowPnt5[1,1]
  intData$largePctBelow1[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1[1,1]
  intData$largePctBelow1Pnt25[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt25[1,1]
  intData$largePctBelow1Pnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt5[1,1]
  intData$largePctBelow2[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow2[1,1]
  intData$largePctBelow3[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow3[1,1]
  intData$largePctBelow4[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow4[1,1]
  intData$largePctBelow5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow5[1,1]
  intData$largePctBelow7[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow7[1,1]
  intData$largePctBelow10[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow10[1,1]
  intData$largePctBelow12[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow12[1,1]
  intData$largePctBelow14[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow14[1,1]
  intData$largePctBelow16[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow16[1,1]
  intData$largePctBelow18[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow18[1,1]
  intData$largePctBelow20[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow20[1,1]
  intData$largeGLCMContrast[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMContrast[1,1]
  intData$largeGLCMCorr[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMCorr[1,1]
  intData$largeGLCMEnergy[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMEnergy[1,1]
  intData$largeGLCMHomog[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMHomog[1,1]
  
  intData$mediumMean[i] <- imageStats$stats[,,1]$Medium[,,1]$Mean[1,1]
  intData$mediumMedian[i] <- imageStats$stats[,,1]$Medium[,,1]$Median[1,1]
  intData$mediumStDev[i] <- imageStats$stats[,,1]$Medium[,,1]$StDev[1,1]
  intData$mediumSum[i] <- imageStats$stats[,,1]$Medium[,,1]$Sum[1,1]
  intData$mediumEntropy[i] <- imageStats$stats[,,1]$Medium[,,1]$Entropy[1,1]
  intData$mediumKurtosis[i] <- imageStats$stats[,,1]$Medium[,,1]$Kurtosis[1,1]
  intData$mediumSkewness[i] <- imageStats$stats[,,1]$Medium[,,1]$Skewness[1,1]
  intData$mediumPctile10[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile10[1,1]
  intData$mediumPctile25[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile25[1,1]
  intData$mediumPctile75[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile75[1,1]
  intData$mediumPctile90[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile90[1,1]
  intData$mediumPctBelowPnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelowPnt5[1,1]
  intData$mediumPctBelow1[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1[1,1]
  intData$mediumPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt25[1,1]
  intData$mediumPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt5[1,1]
  intData$mediumPctBelow2[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow2[1,1]
  intData$mediumPctBelow3[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow3[1,1]
  intData$mediumPctBelow4[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow4[1,1]
  intData$mediumPctBelow5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow5[1,1]
  intData$mediumPctBelow7[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow7[1,1]
  intData$mediumPctBelow10[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow10[1,1]
  intData$mediumPctBelow12[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow12[1,1]
  intData$mediumPctBelow14[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow14[1,1]
  intData$mediumPctBelow16[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow16[1,1]
  intData$mediumPctBelow18[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow18[1,1]
  intData$mediumPctBelow20[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow20[1,1]
  intData$mediumGLCMContrast[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMContrast[1,1]
  intData$mediumGLCMCorr[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMCorr[1,1]
  intData$mediumGLCMEnergy[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMEnergy[1,1]
  intData$mediumGLCMHomog[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMHomog[1,1]
  
  intData$smallMean[i] <- imageStats$stats[,,1]$Small[,,1]$Mean[1,1]
  intData$smallMedian[i] <- imageStats$stats[,,1]$Small[,,1]$Median[1,1]
  intData$smallStDev[i] <- imageStats$stats[,,1]$Small[,,1]$StDev[1,1]
  intData$smallSum[i] <- imageStats$stats[,,1]$Small[,,1]$Sum[1,1]
  intData$smallEntropy[i] <- imageStats$stats[,,1]$Small[,,1]$Entropy[1,1]
  intData$smallKurtosis[i] <- imageStats$stats[,,1]$Small[,,1]$Kurtosis[1,1]
  intData$smallSkewness[i] <- imageStats$stats[,,1]$Small[,,1]$Skewness[1,1]
  intData$smallPctile10[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile10[1,1]
  intData$smallPctile25[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile25[1,1]
  intData$smallPctile75[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile75[1,1]
  intData$smallPctile90[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile90[1,1]
  intData$smallPctBelowPnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelowPnt5[1,1]
  intData$smallPctBelow1[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1[1,1]
  intData$smallPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt25[1,1]
  intData$smallPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt5[1,1]
  intData$smallPctBelow2[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow2[1,1]
  intData$smallPctBelow3[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow3[1,1]
  intData$smallPctBelow4[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow4[1,1]
  intData$smallPctBelow5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow5[1,1]
  intData$smallPctBelow7[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow7[1,1]
  intData$smallPctBelow10[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow10[1,1]
  intData$smallPctBelow12[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow12[1,1]
  intData$smallPctBelow14[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow14[1,1]
  intData$smallPctBelow16[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow16[1,1]
  intData$smallPctBelow18[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow18[1,1]
  intData$smallPctBelow20[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow20[1,1]
  intData$smallGLCMContrast[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMContrast[1,1]
  intData$smallGLCMCorr[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMCorr[1,1]
  intData$smallGLCMEnergy[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMEnergy[1,1]
  intData$smallGLCMHomog[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMHomog[1,1]
  
  # 
  intData$fullMean[i] <- imageStats$stats[,,1]$Full[,,1]$Mean[1,1]
  intData$fullMedian[i] <- imageStats$stats[,,1]$Full[,,1]$Median[1,1]
  intData$fullStDev[i] <- imageStats$stats[,,1]$Full[,,1]$StDev[1,1]
  intData$fullSum[i] <- imageStats$stats[,,1]$Full[,,1]$Sum[1,1]
  intData$fullEntropy[i] <- imageStats$stats[,,1]$Full[,,1]$Entropy[1,1]
  intData$fullKurtosis[i] <- imageStats$stats[,,1]$Full[,,1]$Kurtosis[1,1]
  intData$fullSkewness[i] <- imageStats$stats[,,1]$Full[,,1]$Skewness[1,1]
  intData$fullPctile10[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile10[1,1]
  intData$fullPctile25[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile25[1,1]
  intData$fullPctile75[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile75[1,1]
  intData$fullPctile90[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile90[1,1]
  intData$fullPctBelowPnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelowPnt5[1,1]
  intData$fullPctBelow1[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1[1,1]
  intData$fullPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt25[1,1]
  intData$fullPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt5[1,1]
  intData$fullPctBelow2[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow2[1,1]
  intData$fullPctBelow3[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow3[1,1]
  intData$fullPctBelow4[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow4[1,1]
  intData$fullPctBelow5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow5[1,1]
  intData$fullPctBelow7[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow7[1,1]
  intData$fullPctBelow10[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow10[1,1]
  intData$fullPctBelow12[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow12[1,1]
  intData$fullPctBelow14[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow14[1,1]
  intData$fullPctBelow16[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow16[1,1]
  intData$fullPctBelow18[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow18[1,1]
  intData$fullPctBelow20[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow20[1,1]
  intData$fullGLCMContrast[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMContrast[1,1]
  intData$fullGLCMCorr[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMCorr[1,1]
  intData$fullGLCMEnergy[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMEnergy[1,1]
  intData$fullGLCMHomog[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMHomog[1,1]
  # 
  # 
  intData$imgBMean[i] <- imageStats$stats[,,1]$imgB[,,1]$Mean[1,1]
  intData$imgBMedian[i] <- imageStats$stats[,,1]$imgB[,,1]$Median[1,1]
  intData$imgBSum[i] <- imageStats$stats[,,1]$imgB[,,1]$Sum[1,1]
  intData$imgBPctile10[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile10[1,1]
  intData$imgBPctile25[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile25[1,1]
  intData$imgBPctile75[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile75[1,1]
  intData$imgBPctile90[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile90[1,1]
  intData$imgAMean[i] <- imageStats$stats[,,1]$imgA[,,1]$Mean[1,1]
  intData$imgAMedian[i] <- imageStats$stats[,,1]$imgA[,,1]$Median[1,1]
  intData$imgASum[i] <- imageStats$stats[,,1]$imgA[,,1]$Sum[1,1]
  intData$imgAPctile10[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile10[1,1]
  intData$imgAPctile25[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile25[1,1]
  intData$imgAPctile75[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile75[1,1]
  intData$imgAPctile90[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile90[1,1]
}


print("DONE")
#####
# Screen Detected Data
setwd(wdScreen)
fileNames <- list.files(wdScreen)
nRows <- length(fileNames)
screenData <- data.frame(num=1:nRows)
for (i in 1:nRows){
  imageStats <- readMat(fileNames[i])
  
  screenData$fileName[i] <- fileNames[i]
  screenData$tmp[i] <- strsplit(fileNames[i], '_')[[1]][2]
  screenData$acquisition_id[i] <- strsplit(screenData$tmp[i], '[.]')[[1]][1]
  screenData$view[i] <- imageStats$stats[,,1]$DICOMData[,,1]$Position[1,1]
  screenData$Interval <- 0
  screenData$ScreenDetected <- 1
  screenData$largeMean[i] <- imageStats$stats[,,1]$Large[,,1]$Mean[1,1]
  screenData$largeMedian[i] <- imageStats$stats[,,1]$Large[,,1]$Median[1,1]
  screenData$largeStDev[i] <- imageStats$stats[,,1]$Large[,,1]$StDev[1,1]
  screenData$largeSum[i] <- imageStats$stats[,,1]$Large[,,1]$Sum[1,1]
  screenData$largeEntropy[i] <- imageStats$stats[,,1]$Large[,,1]$Entropy[1,1]
  screenData$largeKurtosis[i] <- imageStats$stats[,,1]$Large[,,1]$Kurtosis[1,1]
  screenData$largeSkewness[i] <- imageStats$stats[,,1]$Large[,,1]$Skewness[1,1]
  screenData$largePctile10[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile10[1,1]
  screenData$largePctile25[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile25[1,1]
  screenData$largePctile75[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile75[1,1]
  screenData$largePctile90[i] <- imageStats$stats[,,1]$Large[,,1]$Pctile90[1,1]
  screenData$largePctBelowPnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelowPnt5[1,1]
  screenData$largePctBelow1[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1[1,1]
  screenData$largePctBelow1Pnt25[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt25[1,1]
  screenData$largePctBelow1Pnt5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow1Pnt5[1,1]
  screenData$largePctBelow2[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow2[1,1]
  screenData$largePctBelow3[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow3[1,1]
  screenData$largePctBelow4[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow4[1,1]
  screenData$largePctBelow5[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow5[1,1]
  screenData$largePctBelow7[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow7[1,1]
  screenData$largePctBelow10[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow10[1,1]
  screenData$largePctBelow12[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow12[1,1]
  screenData$largePctBelow14[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow14[1,1]
  screenData$largePctBelow16[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow16[1,1]
  screenData$largePctBelow18[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow18[1,1]
  screenData$largePctBelow20[i] <- imageStats$stats[,,1]$Large[,,1]$pctBelow20[1,1]
  screenData$largeGLCMContrast[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMContrast[1,1]
  screenData$largeGLCMCorr[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMCorr[1,1]
  screenData$largeGLCMEnergy[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMEnergy[1,1]
  screenData$largeGLCMHomog[i] <- imageStats$stats[,,1]$Large[,,1]$GLCMHomog[1,1]
  
  screenData$mediumMean[i] <- imageStats$stats[,,1]$Medium[,,1]$Mean[1,1]
  screenData$mediumMedian[i] <- imageStats$stats[,,1]$Medium[,,1]$Median[1,1]
  screenData$mediumStDev[i] <- imageStats$stats[,,1]$Medium[,,1]$StDev[1,1]
  screenData$mediumSum[i] <- imageStats$stats[,,1]$Medium[,,1]$Sum[1,1]
  screenData$mediumEntropy[i] <- imageStats$stats[,,1]$Medium[,,1]$Entropy[1,1]
  screenData$mediumKurtosis[i] <- imageStats$stats[,,1]$Medium[,,1]$Kurtosis[1,1]
  screenData$mediumSkewness[i] <- imageStats$stats[,,1]$Medium[,,1]$Skewness[1,1]
  screenData$mediumPctile10[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile10[1,1]
  screenData$mediumPctile25[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile25[1,1]
  screenData$mediumPctile75[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile75[1,1]
  screenData$mediumPctile90[i] <- imageStats$stats[,,1]$Medium[,,1]$Pctile90[1,1]
  screenData$mediumPctBelowPnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelowPnt5[1,1]
  screenData$mediumPctBelow1[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1[1,1]
  screenData$mediumPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt25[1,1]
  screenData$mediumPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow1Pnt5[1,1]
  screenData$mediumPctBelow2[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow2[1,1]
  screenData$mediumPctBelow3[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow3[1,1]
  screenData$mediumPctBelow4[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow4[1,1]
  screenData$mediumPctBelow5[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow5[1,1]
  screenData$mediumPctBelow7[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow7[1,1]
  screenData$mediumPctBelow10[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow10[1,1]
  screenData$mediumPctBelow12[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow12[1,1]
  screenData$mediumPctBelow14[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow14[1,1]
  screenData$mediumPctBelow16[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow16[1,1]
  screenData$mediumPctBelow18[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow18[1,1]
  screenData$mediumPctBelow20[i] <- imageStats$stats[,,1]$Medium[,,1]$pctBelow20[1,1]
  screenData$mediumGLCMContrast[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMContrast[1,1]
  screenData$mediumGLCMCorr[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMCorr[1,1]
  screenData$mediumGLCMEnergy[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMEnergy[1,1]
  screenData$mediumGLCMHomog[i] <- imageStats$stats[,,1]$Medium[,,1]$GLCMHomog[1,1]
  
  screenData$smallMean[i] <- imageStats$stats[,,1]$Small[,,1]$Mean[1,1]
  screenData$smallMedian[i] <- imageStats$stats[,,1]$Small[,,1]$Median[1,1]
  screenData$smallStDev[i] <- imageStats$stats[,,1]$Small[,,1]$StDev[1,1]
  screenData$smallSum[i] <- imageStats$stats[,,1]$Small[,,1]$Sum[1,1]
  screenData$smallEntropy[i] <- imageStats$stats[,,1]$Small[,,1]$Entropy[1,1]
  screenData$smallKurtosis[i] <- imageStats$stats[,,1]$Small[,,1]$Kurtosis[1,1]
  screenData$smallSkewness[i] <- imageStats$stats[,,1]$Small[,,1]$Skewness[1,1]
  screenData$smallPctile10[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile10[1,1]
  screenData$smallPctile25[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile25[1,1]
  screenData$smallPctile75[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile75[1,1]
  screenData$smallPctile90[i] <- imageStats$stats[,,1]$Small[,,1]$Pctile90[1,1]
  screenData$smallPctBelowPnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelowPnt5[1,1]
  screenData$smallPctBelow1[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1[1,1]
  screenData$smallPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt25[1,1]
  screenData$smallPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow1Pnt5[1,1]
  screenData$smallPctBelow2[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow2[1,1]
  screenData$smallPctBelow3[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow3[1,1]
  screenData$smallPctBelow4[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow4[1,1]
  screenData$smallPctBelow5[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow5[1,1]
  screenData$smallPctBelow7[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow7[1,1]
  screenData$smallPctBelow10[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow10[1,1]
  screenData$smallPctBelow12[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow12[1,1]
  screenData$smallPctBelow14[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow14[1,1]
  screenData$smallPctBelow16[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow16[1,1]
  screenData$smallPctBelow18[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow18[1,1]
  screenData$smallPctBelow20[i] <- imageStats$stats[,,1]$Small[,,1]$pctBelow20[1,1]
  screenData$smallGLCMContrast[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMContrast[1,1]
  screenData$smallGLCMCorr[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMCorr[1,1]
  screenData$smallGLCMEnergy[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMEnergy[1,1]
  screenData$smallGLCMHomog[i] <- imageStats$stats[,,1]$Small[,,1]$GLCMHomog[1,1]
  
  # 
  screenData$fullMean[i] <- imageStats$stats[,,1]$Full[,,1]$Mean[1,1]
  screenData$fullMedian[i] <- imageStats$stats[,,1]$Full[,,1]$Median[1,1]
  screenData$fullStDev[i] <- imageStats$stats[,,1]$Full[,,1]$StDev[1,1]
  screenData$fullSum[i] <- imageStats$stats[,,1]$Full[,,1]$Sum[1,1]
  screenData$fullEntropy[i] <- imageStats$stats[,,1]$Full[,,1]$Entropy[1,1]
  screenData$fullKurtosis[i] <- imageStats$stats[,,1]$Full[,,1]$Kurtosis[1,1]
  screenData$fullSkewness[i] <- imageStats$stats[,,1]$Full[,,1]$Skewness[1,1]
  screenData$fullPctile10[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile10[1,1]
  screenData$fullPctile25[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile25[1,1]
  screenData$fullPctile75[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile75[1,1]
  screenData$fullPctile90[i] <- imageStats$stats[,,1]$Full[,,1]$Pctile90[1,1]
  screenData$fullPctBelowPnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelowPnt5[1,1]
  screenData$fullPctBelow1[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1[1,1]
  screenData$fullPctBelow1Pnt25[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt25[1,1]
  screenData$fullPctBelow1Pnt5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow1Pnt5[1,1]
  screenData$fullPctBelow2[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow2[1,1]
  screenData$fullPctBelow3[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow3[1,1]
  screenData$fullPctBelow4[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow4[1,1]
  screenData$fullPctBelow5[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow5[1,1]
  screenData$fullPctBelow7[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow7[1,1]
  screenData$fullPctBelow10[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow10[1,1]
  screenData$fullPctBelow12[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow12[1,1]
  screenData$fullPctBelow14[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow14[1,1]
  screenData$fullPctBelow16[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow16[1,1]
  screenData$fullPctBelow18[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow18[1,1]
  screenData$fullPctBelow20[i] <- imageStats$stats[,,1]$Full[,,1]$pctBelow20[1,1]
  screenData$fullGLCMContrast[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMContrast[1,1]
  screenData$fullGLCMCorr[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMCorr[1,1]
  screenData$fullGLCMEnergy[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMEnergy[1,1]
  screenData$fullGLCMHomog[i] <- imageStats$stats[,,1]$Full[,,1]$GLCMHomog[1,1]
  # 
  # 
  screenData$imgBMean[i] <- imageStats$stats[,,1]$imgB[,,1]$Mean[1,1]
  screenData$imgBMedian[i] <- imageStats$stats[,,1]$imgB[,,1]$Median[1,1]
  screenData$imgBSum[i] <- imageStats$stats[,,1]$imgB[,,1]$Sum[1,1]
  screenData$imgBPctile10[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile10[1,1]
  screenData$imgBPctile25[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile25[1,1]
  screenData$imgBPctile75[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile75[1,1]
  screenData$imgBPctile90[i] <- imageStats$stats[,,1]$imgB[,,1]$Pctile90[1,1]
  screenData$imgAMean[i] <- imageStats$stats[,,1]$imgA[,,1]$Mean[1,1]
  screenData$imgAMedian[i] <- imageStats$stats[,,1]$imgA[,,1]$Median[1,1]
  screenData$imgASum[i] <- imageStats$stats[,,1]$imgA[,,1]$Sum[1,1]
  screenData$imgAPctile10[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile10[1,1]
  screenData$imgAPctile25[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile25[1,1]
  screenData$imgAPctile75[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile75[1,1]
  screenData$imgAPctile90[i] <- imageStats$stats[,,1]$imgA[,,1]$Pctile90[1,1]
}
print("DONE")

#####
# Combines data
allData <- rbind(intData, screenData)

#Adds the data from the SXA Analysis
wdSXA <- "W:\\Breast Studies\\Masking\\SXAAnalysisData\\"
fileName<-'SXA_Masking_01102017_APM.csv'
SXAData <- read.csv(file=paste(wdSXA,fileName, sep=''),header=TRUE, sep=',')


#merge the SXA and the Masking Datasets
mergedData <- merge(allData, SXAData, by='acquisition_id')
#Shuffles for a random result
mergedData<-mergedData[sample(nrow(mergedData)),]

#Split by int/nonInt
splitMerged <- split(mergedData, mergedData$Interval)
dataInt <- splitMerged$`1`
dataScreen <- splitMerged$`0`

#Splits up data by CC andMLO
splitInt<-split(dataInt, dataInt$view)
splitScreen<-split(dataScreen, dataScreen$view)
intDataMLO <- splitInt$MLO
intDataCC <- splitInt$CC
screenDataMLO <- splitScreen$MLO
screenDataCC <- splitScreen$CC


# ### This section forces MLO data to have same number of INT as Screen Detected
nIntMLO <- nrow(intDataMLO)
nScreenMLO <- nrow(screenDataMLO)
sampleSizeMLO <- min(nIntMLO,nScreenMLO)

intDataMLO<-intDataMLO[sample(1:sampleSizeMLO),]
screenDataMLO<- screenDataMLO[sample(1:sampleSizeMLO),]

combinedDataMLO <-rbind(intDataMLO,screenDataMLO)


# ### This section forces CC data to have same number of INT as Screen Detected
nIntCC <- nrow(intDataCC)
nScreenCC <- nrow(screenDataCC)
sampleSizeCC <- min(nIntCC,nScreenCC)

intDataCC<-intDataCC[sample(1:sampleSizeCC),]
screenDataCC<- screenDataCC[sample(1:sampleSizeCC),]

combinedDataCC <-rbind(intDataCC,screenDataCC)


#####
#Testing correlation of the SXA Density Variable with the IQF Variables.

# SXA..Breast.Density. vs all variabels from 8-147 in mergedData

SXACorVals <- cor(mergedData$SXA..Breast.Density., mergedData[,c(8:141)], use="pairwise.complete.obs")
SXACorVals <- t(SXACorVals)
write.csv(SXACorVals, file = paste(savePath,dateOfAnalysis,"CorWithSXA.csv", sep=""),row.names=TRUE)


#####
#Prep for K-Folds

#Randomly shuffle the data (CC)
combinedDataCC<-combinedDataCC[sample(nrow(combinedDataCC)),]
#Create 10 equally size folds (CC)
CCfolds <- cut(seq(1,nrow(combinedDataCC)),breaks=10,labels=FALSE)
#Randomly shuffle the data (MLO)
combinedDataMLO<-combinedDataMLO[sample(nrow(combinedDataMLO)),]
#Create 10 equally size folds (MLO)
MLOfolds <- cut(seq(1,nrow(combinedDataMLO)),breaks=10,labels=FALSE)

######
#Logistic Regression of each individual variable (Not controlled for BIRADS)
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
    testSetCC <- combinedDataCC[CCtestIndexes, ]
    trainSetCC <- combinedDataCC[-CCtestIndexes, ]
    
    MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
    testSetMLO <- combinedDataMLO[MLOtestIndexes, ]
    trainSetMLO <- combinedDataMLO[-MLOtestIndexes, ]
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



##### 
#Do Analysis after controlling for BIRADS
#Logistic Regression of each individual variable (controlled for BIRADS)
#For Both CC and MLO

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
  
  for(j in 1:10){
    CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
    testSetCC <- combinedDataCC[CCtestIndexes, ]
    trainSetCC <- combinedDataCC[-CCtestIndexes, ]
    
    MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
    testSetMLO <- combinedDataMLO[MLOtestIndexes, ]
    trainSetMLO <- combinedDataMLO[-MLOtestIndexes, ]
    # i<-9
    varT <- i
    modelDataCC <- trainSetCC[,c(6,147,varT)]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    # print(summary(model))
    if (nrow(coef(summary(model)))==3) {
      pValCCSXA[j] <- (coef(summary(model))[2,4])
      pValCCVar[j] <- (coef(summary(model))[3,4])
      estimateSXACC[j] <- (coef(summary(model))[2,1])
      estimateVarCC[j] <- (coef(summary(model))[3,1])
    }
    # else if (nrow(coef(summary(model)))==1) {pValCC <- 1}
    
    testPredictionsData <- testSetCC[,c(6,147,varT)]
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
    
    
    modelDataMLO <- trainSetMLO[,c(6,147,varT)]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    # summary(model)
    if (nrow(coef(summary(model)))==3) {
      pValMLOSXA[j] <- (coef(summary(model))[2,4])
      pValMLOVar[j] <- (coef(summary(model))[3,4])
      estimateVarMLO[j] <- (coef(summary(model))[3,1])
      estimateSXAMLO[j] <- (coef(summary(model))[2,1])
    }
    
    testPredictionsData <- testSetMLO[,c(6,147,varT)]
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
  regResultsCtrl[(i-5),7] <- mean(AccuracyMLO)
  regResultsCtrl[(i-5),8] <- mean(unlist(aucCC))
  regResultsCtrl[(i-5),9] <- mean(unlist(aucMLO))
  regResultsCtrl[(i-5),10] <- mean(estimateSXACC)
  regResultsCtrl[(i-5),11] <- mean(estimateVarCC)
  regResultsCtrl[(i-5),12] <- mean(estimateSXAMLO)
  regResultsCtrl[(i-5),13] <- mean(estimateVarMLO)
}

#***************Make code to save the regResultdsCtrl here.
write.csv(regResultsCtrl, file = paste(savePath,dateOfAnalysis,"regResultsCtrl.csv", sep=""),row.names=TRUE)

regResultsBestCC <- subset(regResultsCtrl, pValCCTrainVar<0.2)
sortedAUCCC <- regResultsBestCC[order(regResultsBestCC$AUCCC, regResultsBestCC$Variable, decreasing = TRUE) , ] 
bestEntriesAUCCC<-sortedAUCCC[(1):(10),]
keep <- bestEntriesAUCCC[,1]
nEnt <- length(keep)
keep[nEnt+1] <- 'Interval'
bestData <- allData[keep]

regResultsBestMLO <- subset(regResultsCtrl, pValMLOTrainVar<0.3)
sortedAUCMLO <- regResultsBestMLO[order(regResultsBestMLO$AUCMLO, regResultsBestMLO$Variable, decreasing = TRUE) , ] 
bestEntriesAUCMLO<-sortedAUCMLO[(1):(10),]
keep <- bestEntriesAUCMLO[,1]
nEnt <- length(keep)
keep[nEnt+1] <- 'Interval'
bestData <- allData[keep]

write.csv(regResultsBest, file = paste(savePath,dateOfAnalysis,"regResultsAUCCC.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCCC, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCCC.csv", sep=""),row.names=TRUE)

write.csv(regResultsBestMLO, file = paste(savePath,dateOfAnalysis,"regResultsAUCMLO.csv", sep=""),row.names=TRUE)
write.csv(bestEntriesAUCMLO, file = paste(savePath,dateOfAnalysis,"bestEntriesAUCMLO.csv", sep=""),row.names=TRUE)






#####

#Generate Figures here

#Box Plots of top 3 measures

#*****************************#

#AUC of top 3: BIRADS and then with added variable
#AUC of things I choose on same plot as BIRADS for the CC Images.
# 
# for (i in 1:10){
#   i <-1
#   for(j in 1:10){
#     CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
#     testSetCC <- combinedDataCC[CCtestIndexes, ]
#     trainSetCC <- combinedDataCC[-CCtestIndexes, ]
#     
#     MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
#     testSetMLO <- combinedDataMLO[MLOtestIndexes, ]
#     trainSetMLO <- combinedDataMLO[-MLOtestIndexes, ]
#     #Plots BIRADS
#     png(filename=paste(savePath,dateOfAnalysis,"CCAUCwBIRADSandMeasure",i,".png", sep=""))
#     modelDataCC <- trainSetCC[,c(6,147)]
#     model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
#     # print(summary(model))
#     
#     testPredictionsData <- testSetCC[,c(6,147)]
#     fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#     fitted.results <- ifelse(fitted.results > 0.5,1,0)
#     misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#     # print(paste('Accuracy',1-misClasificError))
#     AccuracyCC<- 1-misClasificError
#     p <- predict(model, newdata=testPredictionsData, type="response")
#     pr <- prediction(p, testPredictionsData$Interval)
#     prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#     plot(prf, col='blue', lwd=2)
#     auc <- performance(pr, measure = "auc")
#     aucCC <- auc@y.values[1]
#     print(aucCC)
#     pValCCSXA <- (coef(summary(model))[2,4])
#   #   print(pValCCSXA)
#   #   print(AccuracyCC)
#     
#     #Plots the relevant things 
#     keep <- c('Interval', 'SXA..Breast.Density.', bestEntriesAUCCC[i,1])
#     modelDataCC <- trainSetCC[keep]
#     model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
#     # print(summary(model))
#     
#     testPredictionsData <- testSetCC[keep]
#     fitted.results <- predict(model,newdata=testPredictionsData,type='response')
#     fitted.results <- ifelse(fitted.results > 0.5,1,0)
#     misClasificError <- mean(fitted.results != testPredictionsData$Interval)
#     # print(paste('Accuracy',1-misClasificError))
#     AccuracyCC<- 1-misClasificError
#     p <- predict(model, newdata=testPredictionsData, type="response")
#     pr <- prediction(p, testPredictionsData$Interval)
#     prf <- performance(pr, measure = "tpr", x.measure = "fpr")
#     lines(prf@x.values[[1]], prf@y.values[[1]], col='firebrick3', lwd=2)
#     # main = paste("AUC of BIRADS Density (Blue) and ", bestEntriesAUCCC[i,1])
#     legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
#     title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
#     auc <- performance(pr, measure = "auc")
#     aucCC <- auc@y.values[1]
#     print(aucCC)
#     dev.off()
#     pValCCSXA <- (coef(summary(model))[2,4])
#     pValCCVar <- (coef(summary(model))[3,4])
#   
#   }
# #   print(pValCCSXA)
# #   print(pValCCVar)
# #   print(AccuracyCC)
# }
# 
# 


#####
#Test to average out the ROC Curve (CC)

for (i in 1:10){
  # i <-1
  pSXA=NULL
  pSXALabels=NULL
  pVar=NULL
  pVarLabels=NULL
  
  png(filename=paste(savePath,dateOfAnalysis,"CCAUCwBIRADSandMeasure",i,".png", sep=""))
  plot.new()
  for(j in 1:10){
    CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
    testSetCC <- combinedDataCC[CCtestIndexes, ]
    trainSetCC <- combinedDataCC[-CCtestIndexes, ]

    #Plots BIRADS
    
    modelDataCC <- trainSetCC[,c(6,147)]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    
    testPredictionsData <- testSetCC[,c(6,147)]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    AccuracyCC<- 1-misClasificError
    pSXA[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pSXALabels[j] <- list(testPredictionsData$Interval)
    
    #Plots the relevant things 
    keep <- c('Interval', 'SXA..Breast.Density.', bestEntriesAUCCC[i,1])
    modelDataCC <- trainSetCC[keep]
    model <- glm(modelDataCC$Interval~., family=binomial(logit), data=modelDataCC)
    # print(summary(model))
    
    testPredictionsData <- testSetCC[keep]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    # print(paste('Accuracy',1-misClasificError))
    AccuracyCC<- 1-misClasificError
    pVar[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pVarLabels[j] <- list(testPredictionsData$Interval)
  }


  pr <- prediction(pSXA, pSXALabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",spread.estimate="stddev",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucCC <- auc@y.values[1]
  # pValCCSXA <- (coef(summary(model))[2,4])
  
  
  pr <- prediction(pVar, pVarLabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",spread.estimate="stddev",add=TRUE)
  axis(1)
  axis(2)
  # main = paste("AUC of BIRADS Density (Blue) and ", bestEntriesAUCCC[i,1])
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
  
  auc <- performance(pr, measure = "auc")
  aucCC <- auc@y.values[1]
  dev.off()
# 
}

#####
#Test to average out the ROC Curve (MLO)

for (i in 1:10){
  # i <-1
  pSXA=NULL
  pSXALabels=NULL
  pVar=NULL
  pVarLabels=NULL
  
  png(filename=paste(savePath,dateOfAnalysis,"MLOAUCwBIRADSandMeasure",i,".png", sep=""))
  plot.new()
  for(j in 1:10){
#     CCtestIndexes <- which(CCfolds==j,arr.ind=TRUE)
#     testSetCC <- combinedDataCC[CCtestIndexes, ]
#     trainSetCC <- combinedDataCC[-CCtestIndexes, ]
        MLOtestIndexes <- which(MLOfolds==j,arr.ind=TRUE)
        testSetMLO <- combinedDataMLO[MLOtestIndexes, ]
        trainSetMLO <- combinedDataMLO[-MLOtestIndexes, ]
    #Plots BIRADS
    # png(filename=paste(savePath,dateOfAnalysis,"CCAUCwBIRADSandMeasure",i,".png", sep=""))
    
    modelDataMLO <- trainSetMLO[,c(6,147)]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    
    testPredictionsData <- testSetMLO[,c(6,147)]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    AccuracyMLO<- 1-misClasificError
    pSXA[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pSXALabels[j] <- list(testPredictionsData$Interval)
    
    #Plots the relevant things 
    keep <- c('Interval', 'SXA..Breast.Density.', bestEntriesAUCMLO[i,1])
    modelDataMLO <- trainSetMLO[keep]
    model <- glm(modelDataMLO$Interval~., family=binomial(logit), data=modelDataMLO)
    # print(summary(model))
    
    testPredictionsData <- testSetMLO[keep]
    fitted.results <- predict(model,newdata=testPredictionsData,type='response')
    fitted.results <- ifelse(fitted.results > 0.5,1,0)
    misClasificError <- mean(fitted.results != testPredictionsData$Interval)
    # print(paste('Accuracy',1-misClasificError))
    AccuracyMLO<- 1-misClasificError
    pVar[j] <- list(predict(model, newdata=testPredictionsData, type="response"))
    pVarLabels[j] <- list(testPredictionsData$Interval)
  }
  
  
  pr <- prediction(pSXA, pSXALabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  
  plot(prf, col='blue', lwd=2, lty=1, avg="vertical",spread.estimate="stddev",add=TRUE)
  auc <- performance(pr, measure = "auc")
  aucMLO <- auc@y.values[1]
  # pValCCSXA <- (coef(summary(model))[2,4])
  
  
  pr <- prediction(pVar, pVarLabels)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  plot(prf, col='firebrick3', lwd=2,avg="vertical",spread.estimate="stddev",add=TRUE)
  axis(1)
  axis(2)
  # main = paste("AUC of BIRADS Density (Blue) and ", bestEntriesAUCCC[i,1])
  legend("bottomright", c("Only Percent Density", "Percent Density and Masking Measure"), lty = c(1,1),lwd=c(2.5,2.5),col=c("blue","red") )
  title(main = paste("AUC of BIRADS Density (Blue) and \n", bestEntriesAUCCC[i,1]))
  
  auc <- performance(pr, measure = "auc")
  aucCC <- auc@y.values[1]
  dev.off()
  # 
}


#####
#Working Example
data(ROCR.xval)
pred <- prediction(ROCR.xval$predictions, ROCR.xval$labels)
perf <- performance(pred,"tpr","fpr")
plot(perf,col="grey82",lty=3)
plot(perf,lwd=3,avg="vertical",spread.estimate="boxplot",add=TRUE)

#************************#


#***********************#
#Figure out the rest of the plots#
#*********************************#









