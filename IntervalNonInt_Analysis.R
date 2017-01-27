

#Inputs:
install.packages("R.matlab")
install.packages("ROCR")
# file:///W:/Breast Studies/Masking/txt_excels/cpmc_masking.txt
# file:///W:/Breast Studies/Masking/txt_excels/cpmc_masking_rest.txt
# file:///W:/Breast Studies/Masking/txt_excels/masking_diag_last_cpmc.txt

# Importing the data
#####

setwd("W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\12.21.16_CompiledData2\\Interval")
fileNames <- list.files("W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\12.21.16_CompiledData2\\Interval")
nRows <- length(fileNames)
intData <- data.frame(num=1:nRows)
for (i in 1:nRows){
  imageStats <- readMat(fileNames[i])
  
  intData$fileName[i] <- fileNames[i]
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


setwd("W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\12.21.16_CompiledData2\\ScreenDetected")
fileNames <- list.files("W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\12.21.16_CompiledData2\\ScreenDetected")


nRows <- length(fileNames)
screenData <- data.frame(num=1:nRows)
for (i in 1:nRows){
  imageStats <- readMat(fileNames[i])
  
  screenData$fileName[i] <- fileNames[i]
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

combinedData <- rbind(intData, screenData)

#Determine the image sets that are connected.



testData <- combinedData
testData$new <- testData$fileName#[,8]

testVector <- data.frame(testData$fileName)#[,8]

#Need dplyr
s1 <- data.frame(unlist(strsplit(testVector, split='_', fixed = TRUE))[2])


df <- mutate(testData, col2=sapply(strsplit(testData$new, split='_', fixed=TRUE), function(x)(x[2])))

df2 <- mutate(df, col141=sapply(strsplit(df[,141], split='.', fixed=TRUE), function(x)(x[1])))
#converted to numeric.
df2[,c(142)] <- sapply(df2[,c(142)], as.numeric)

imageSet <- 1
nRows = nrow(df2)
for (i in 2:nRows){
  if (abs(df2[i,142] - df2[(i-1),142])<=9){
    print('same')
    df2$imgSet[i] <- imageSet
  }
  else{
    print('diff')
    imageSet <- imageSet+1
    df2$imgSet[i] <- imageSet
  }
}
df2$imgSet[1] <-1
allData <- df2

#Split the MLO and CC Images
nBreasts <- max(allData$imgSet)

splitData <- split(allData, allData$view)
allDataMLO <- splitData$MLO
allDataCC <- splitData$CC

screenDataMLO <- subset(allDataMLO, Interval==0)
intDataMLO <- subset(allDataMLO, Interval==1)

screenDataCC <- subset(allDataCC, Interval==0)
intDataCC <- subset(allDataCC, Interval==1)


##### Do Correlations




#MLO

#CC

keep = c('Interval', 'largeMean', 'largeMedian', 'largeStDev', 'largeSum','largeEntropy','largeKurtosis', 'largeSkewness',
         'largePctile10','largePctile25', 'largePctile75', 'largePctile90',
         'largePctBelowPnt5', 'largePctBelow1', 'largePctBelow1Pnt25', 'largePctBelow1Pnt5',  'largePctBelow2', 'largePctBelow3',
         'largePctBelow4', 'largePctBelow5', 'largePctBelow7', 'largePctBelow10',  'largePctBelow12', 'largePctBelow14',
         'largePctBelow16', 'largePctBelow18', 'largePctBelow20',
         'largeGLCMContrast', 'largeGLCMEnergy', 'largeGLCMCorr',  'largeGLCMHomog')

corLargeDataCC <- data.frame(cor(allDataCC[keep]))
corLargeDataMLO <- data.frame(cor(allDataMLO[keep]))
corLargeDataAll <- data.frame(cor(allData[keep]))


keep = c('Interval', 'mediumMean', 'mediumMedian', 'mediumStDev', 'mediumSum','mediumEntropy','mediumKurtosis', 'mediumSkewness',
         'mediumPctile10','mediumPctile25', 'mediumPctile75', 'mediumPctile90',
         'mediumPctBelowPnt5', 'mediumPctBelow1', 'mediumPctBelow1Pnt25', 'mediumPctBelow1Pnt5',  'mediumPctBelow2', 'mediumPctBelow3',
         'mediumPctBelow4', 'mediumPctBelow5', 'mediumPctBelow7', 'mediumPctBelow10',  'mediumPctBelow12', 'mediumPctBelow14',
         'mediumPctBelow16', 'mediumPctBelow18', 'mediumPctBelow20',
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')

corMediumDataCC <- data.frame(cor(allDataCC[keep]))
corMediumDataMLO <- data.frame(cor(allDataMLO[keep]))
corMediumDataAll <- data.frame(cor(allData[keep]))

keep = c('Interval', 'smallMean', 'smallMedian', 'smallStDev', 'smallSum','smallEntropy','smallKurtosis', 'smallSkewness',
         'smallPctile10','smallPctile25', 'smallPctile75', 'smallPctile90',
         'smallPctBelowPnt5', 'smallPctBelow1', 'smallPctBelow1Pnt25', 'smallPctBelow1Pnt5',  'smallPctBelow2', 'smallPctBelow3',
         'smallPctBelow4', 'smallPctBelow5', 'smallPctBelow7', 'smallPctBelow10',  'smallPctBelow12', 'smallPctBelow14',
         'smallPctBelow16', 'smallPctBelow18', 'smallPctBelow20',
         'smallGLCMContrast', 'smallGLCMEnergy', 'smallGLCMCorr',  'smallGLCMHomog')

corSmallDataCC <- data.frame(cor(allDataCC[keep]))
corSmallDataMLO <- data.frame(cor(allDataMLO[keep]))
corSmallDataAll <- data.frame(cor(allData[keep]))

keep = c('Interval', 'fullMean', 'fullMedian', 'fullStDev', 'fullSum','fullEntropy','fullKurtosis', 'fullSkewness',
         'fullPctile10','fullPctile25', 'fullPctile75', 'fullPctile90',
         'fullPctBelowPnt5', 'fullPctBelow1', 'fullPctBelow1Pnt25', 'fullPctBelow1Pnt5',  'fullPctBelow2', 'fullPctBelow3',
         'fullPctBelow4', 'fullPctBelow5', 'fullPctBelow7', 'fullPctBelow10',  'fullPctBelow12', 'fullPctBelow14',
         'fullPctBelow16', 'fullPctBelow18', 'fullPctBelow20',
         'fullGLCMContrast', 'fullGLCMEnergy', 'fullGLCMCorr',  'fullGLCMHomog')

corFullDataCC <- data.frame(cor(allDataCC[keep]))
corFullDataMLO <- data.frame(cor(allDataMLO[keep]))
corFullDataAll <- data.frame(cor(allData[keep]))

keep = c('Interval', 'imgBMean', 'imgAMean', 'imgBMedian', 'imgAMedian','imgBSum','imgASum', 
         'imgBPctile10', 'imgBPctile25','imgBPctile75', 'imgBPctile90',
         'imgAPctile10', 'imgAPctile25','imgAPctile75', 'imgAPctile90')

corABMatDataCC <- data.frame(cor(combinedDataCC[keep]))
corABMatDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corABMatDataAll <- data.frame(cor(combinedData[keep]))


#####




#Choose test/train set by going random set 1-682 or whatever.
nTrainBreasts <- round(0.8* nBreasts)
nTestBreasts <- nBreasts - nTrainBreasts


##****************##*************##**********DOESNT HAVE 50/50 SPLIT***********##*****************#*******#******#******#****
allNumbers <- sample(1:nBreasts)
trainNumbers <- allNumbers[1:nTrainBreasts]
testNumbers <- allNumbers[(nTrainBreasts+1):nBreasts]

#split into the test and train set to make sure test and train have separate imageSets

screenMLOTrain <- screenDataMLO[screenDataMLO$imgSet %in%  c(trainNumbers),] #subset(screenDataMLO, imgSet=c(trainNumbers))
intMLOTrain <- intDataMLO[intDataMLO$imgSet %in%  c(trainNumbers),] 
trainSetMLO <- rbind(screenMLOTrain, intMLOTrain)
  
screenMLOTest <- screenDataMLO[screenDataMLO$imgSet %in%  c(testNumbers),]
intMLOTest <- intDataMLO[intDataMLO$imgSet %in%  c(testNumbers),]
testSetMLO <- rbind(screenMLOTest, intMLOTest)

screenCCTrain <- screenDataCC[screenDataCC$imgSet %in%  c(trainNumbers),]
intCCTrain <- intDataCC[intDataCC$imgSet %in%  c(trainNumbers),]
trainSetCC <- rbind(screenCCTrain, intCCTrain)

screenCCTest <- screenDataCC[screenDataCC$imgSet %in%  c(testNumbers),]
intCCTest <- intDataCC[intDataCC$imgSet %in%  c(testNumbers),]
testSetCC <- rbind(screenCCTest, intCCTest)


#do predictions based on top one for CC and MLO


#Checking for best individual identifiers in CC and MLO
#####
#MLO

nCols <- ncol(intData)
mloIndRegResult <- data.frame(matrix(ncol = 3, nrow = (nCols-5)))
colnames(mloIndRegResult) <- c('Variable','AUC','pVal')
for (i in 6:nCols){
  varT <- i
  modelData <- trainSetMLO[,c(4,varT)]
  model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
  summary(model)
  # confint(model)
  # anova(model, test="Chisq")
  
  testPredictionsData <- testSetMLO[,c(4,varT)]
  fitted.results <- predict(model,newdata=testPredictionsData,type='response')
  fitted.results <- ifelse(fitted.results > 0.5,1,0)
  misClasificError <- mean(fitted.results != testPredictionsData$Interval)
  # print(paste('Accuracy',1-misClasificError))
  
  p <- predict(model, newdata=testPredictionsData, type="response")
  pr <- prediction(p, testPredictionsData$Interval)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  # plot(prf)
  
  auc <- performance(pr, measure = "auc")
  auc <- auc@y.values[1]
  # print(colnames(testSetMLO[i]))
  # auc
  mloIndRegResult[(i-5),3] <- coef(summary(model))[2,4]
  mloIndRegResult[(i-5),2] <- auc
  mloIndRegResult[(i-5),1] <- colnames(testSetMLO[i])
  
  # with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
}

mloIndRegResult <- data.frame(mloIndRegResult)
sortedMLORegResult <- mloIndRegResult[order(mloIndRegResult$AUC, mloIndRegResult$Variable) , ] 

bestEntriesMLO<-sortedMLORegResult[(nCols-7):(nCols-5),]

nCols <- ncol(intData)
ccIndRegResult <- data.frame(matrix(ncol = 3, nrow = (nCols-5)))
colnames(ccIndRegResult) <- c('Variable','AUC')
for (i in 6:nCols){
  
  varT <- i
  modelData <- trainSetCC[,c(4,varT)]
  model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
  # summary(model)
  # confint(model)
  # anova(model, test="Chisq")
  
  testPredictionsData <- testSetCC[,c(4,varT)]
  fitted.results <- predict(model,newdata=testPredictionsData,type='response')
  fitted.results <- ifelse(fitted.results > 0.5,1,0)
  misClasificError <- mean(fitted.results != testPredictionsData$Interval)
  print(paste('Accuracy',1-misClasificError))
  
  library(ROCR)
  p <- predict(model, newdata=testPredictionsData, type="response")
  pr <- prediction(p, testPredictionsData$Interval)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  #plot(prf)
  
  auc <- performance(pr, measure = "auc")
  auc <- auc@y.values[1]
  print(colnames(testSetMLO[i]))
  auc
  ccIndRegResult[(i-5),3] <- coef(summary(model))[2,4]
  ccIndRegResult[(i-5),2] <- auc
  ccIndRegResult[(i-5),1] <- colnames(testSetMLO[i])
  
  # with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
}

ccIndRegResult <- data.frame(ccIndRegResult)
sortedCCRegResult <- ccIndRegResult[order(ccIndRegResult$AUC, ccIndRegResult$Variable) , ] 

bestEntriesCC<-sortedCCRegResult[(nCols-7):(nCols-5),]


# Add the prediciotns from the CC and the MLO image and see if that is the more accurate.

keep = c('Interval','largeGLCMContrast')#(, 'mediumGLCMHomog')
keep = c('Interval','largeMedian','largeEntropy', 'largeSum', 'mediumGLCMCorr', 'mediumGLCMContrast',
         'fullPctBelow2','fullPctile25','imgBSum','imgBPctile90','imgAPctile75')
keep = c('Interval','smallEntropy')#,'mediumPctBelow3', 'largeKurtosis', 'mediumSkewness')
modelData<-trainSetMLO[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)

testPredictionsData <- testSetMLO[keep]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
plot(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)
plot(fitted.results)
plot(testPredictionsData$Interval)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))

p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
auc


keep = c('Interval','mediumPctBelow12')
keep = c('Interval','largeGLCMContrast','imgBMedian')
modelData <- trainSetCC[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)

testPredictionsData <- testSetCC[keep]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
plot(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)
plot(fitted.results)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))

p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
auc




############################################################################################################



#Splits up data by CC and MLO

#Arranging the data (MLO and CC Separately)
#####

splitScreen <- split(screenData, screenData$view)
screenDataMLO <- splitScreen$MLO
screenDataCC <- splitScreen$CC
splitInt <- split(intData, intData$view)
intDataMLO <- splitInt$MLO
intDataCC <- splitInt$CC


# ### This section forces MLO data to have same number of INT as Screen Detected
nIntMLO <- nrow(intDataMLO)
nScreenMLO <- nrow(screenDataMLO)
sampleSizeMLO <- min(nIntMLO,nScreenMLO)

intDataMLO<-intDataMLO[sample(1:sampleSizeMLO),]
screenDataMLO<- screenDataMLO[sample(1:sampleSizeMLO),]
# ###

combinedDataMLO <-rbind(intDataMLO,screenDataMLO)

trainIntSizeMLO = round(0.8* nrow(intDataMLO))
testIntSizeMLO = nrow(intDataMLO) - trainIntSizeMLO
trainScreenSizeMLO = round(0.8*nrow(screenDataMLO))
testScreenSizeMLO = nrow(screenDataMLO) - trainScreenSizeMLO

randSetIntMLO <- intDataMLO[sample(1:nrow(intDataMLO)),]
trainSetIntMLO <- randSetIntMLO[1:trainIntSizeMLO,] #Do 90 from here
testSetIntMLO <- randSetIntMLO[(trainIntSizeMLO+1):nrow(randSetIntMLO),]

randSetScreenMLO <- screenDataMLO[sample(1:nrow(screenDataMLO)),] 
trainSetScreenMLO <- randSetScreenMLO[1:trainScreenSizeMLO,]#Do 88 from here
testSetScreenMLO <- randSetScreenMLO[(trainScreenSizeMLO+1):nrow(randSetScreenMLO),]

trainSetMLO <- rbind(trainSetIntMLO,trainSetScreenMLO)
testSetMLO <- rbind(testSetIntMLO,testSetScreenMLO)


# ### This section forces CC data to have same number of INT as Screen Detected
nIntCC <- nrow(intDataCC)
nScreenCC <- nrow(screenDataCC)
sampleSizeCC <- min(nIntCC,nScreenCC)

intDataCC<-intDataCC[sample(1:sampleSizeCC),]
screenDataCC<- screenDataCC[sample(1:sampleSizeCC),]
# ###

combinedDataCC <-rbind(intDataCC,screenDataCC)

trainIntSizeCC = round(0.8* nrow(intDataCC))
testIntSizeCC = nrow(intDataCC) - trainIntSizeCC
trainScreenSizeCC = round(0.8*nrow(screenDataCC))
testScreenSizeCC = nrow(screenDataCC) - trainScreenSizeCC

randSetIntCC <- intDataCC[sample(1:nrow(intDataCC)),]
trainSetIntCC <- randSetIntCC[1:trainIntSizeCC,] #Do 90 from here
testSetIntCC <- randSetIntCC[(trainIntSizeCC+1):nrow(randSetIntCC),]

randSetScreenCC <- screenDataCC[sample(1:nrow(screenDataCC)),] 
trainSetScreenCC <- randSetScreenCC[1:trainScreenSizeCC,]#Do 88 from here
testSetScreenCC <- randSetScreenCC[(trainScreenSizeCC+1):nrow(randSetScreenCC),]

trainSetCC <- rbind(trainSetIntCC,trainSetScreenCC)
testSetCC <- rbind(testSetIntCC,testSetScreenCC)






#Checking correlations
#####

keep = c('Interval', 'largeMean', 'largeMedian', 'largeStDev', 'largeSum','largeEntropy','largeKurtosis', 'largeSkewness',
         'largePctile10','largePctile25', 'largePctile75', 'largePctile90',
        'largePctBelowPnt5', 'largePctBelow1', 'largePctBelow1Pnt25', 'largePctBelow1Pnt5',  'largePctBelow2', 'largePctBelow3',
        'largePctBelow4', 'largePctBelow5', 'largePctBelow7', 'largePctBelow10',  'largePctBelow12', 'largePctBelow14',
        'largePctBelow16', 'largePctBelow18', 'largePctBelow20',
         'largeGLCMContrast', 'largeGLCMEnergy', 'largeGLCMCorr',  'largeGLCMHomog')

corLargeDataCC <- data.frame(cor(combinedDataCC[keep]))
corLargeDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corLargeDataAll <- data.frame(cor(combinedData[keep]))


keep = c('Interval', 'mediumMean', 'mediumMedian', 'mediumStDev', 'mediumSum','mediumEntropy','mediumKurtosis', 'mediumSkewness',
         'mediumPctile10','mediumPctile25', 'mediumPctile75', 'mediumPctile90',
         'mediumPctBelowPnt5', 'mediumPctBelow1', 'mediumPctBelow1Pnt25', 'mediumPctBelow1Pnt5',  'mediumPctBelow2', 'mediumPctBelow3',
         'mediumPctBelow4', 'mediumPctBelow5', 'mediumPctBelow7', 'mediumPctBelow10',  'mediumPctBelow12', 'mediumPctBelow14',
         'mediumPctBelow16', 'mediumPctBelow18', 'mediumPctBelow20',
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')

corMediumDataCC <- data.frame(cor(combinedDataCC[keep]))
corMediumDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corMediumDataAll <- data.frame(cor(combinedData[keep]))

keep = c('Interval', 'smallMean', 'smallMedian', 'smallStDev', 'smallSum','smallEntropy','smallKurtosis', 'smallSkewness',
         'smallPctile10','smallPctile25', 'smallPctile75', 'smallPctile90',
         'smallPctBelowPnt5', 'smallPctBelow1', 'smallPctBelow1Pnt25', 'smallPctBelow1Pnt5',  'smallPctBelow2', 'smallPctBelow3',
         'smallPctBelow4', 'smallPctBelow5', 'smallPctBelow7', 'smallPctBelow10',  'smallPctBelow12', 'smallPctBelow14',
         'smallPctBelow16', 'smallPctBelow18', 'smallPctBelow20',
         'smallGLCMContrast', 'smallGLCMEnergy', 'smallGLCMCorr',  'smallGLCMHomog')

corSmallDataCC <- data.frame(cor(combinedDataCC[keep]))
corSmallDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corSmallDataAll <- data.frame(cor(combinedData[keep]))

keep = c('Interval', 'fullMean', 'fullMedian', 'fullStDev', 'fullSum','fullEntropy','fullKurtosis', 'fullSkewness',
         'fullPctile10','fullPctile25', 'fullPctile75', 'fullPctile90',
         'fullPctBelowPnt5', 'fullPctBelow1', 'fullPctBelow1Pnt25', 'fullPctBelow1Pnt5',  'fullPctBelow2', 'fullPctBelow3',
         'fullPctBelow4', 'fullPctBelow5', 'fullPctBelow7', 'fullPctBelow10',  'fullPctBelow12', 'fullPctBelow14',
         'fullPctBelow16', 'fullPctBelow18', 'fullPctBelow20',
         'fullGLCMContrast', 'fullGLCMEnergy', 'fullGLCMCorr',  'fullGLCMHomog')

corFullDataCC <- data.frame(cor(combinedDataCC[keep]))
corFullDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corFullDataAll <- data.frame(cor(combinedData[keep]))

keep = c('Interval', 'imgBMean', 'imgAMean', 'imgBMedian', 'imgAMedian','imgBSum','imgASum', 
         'imgBPctile10', 'imgBPctile25','imgBPctile75', 'imgBPctile90',
         'imgAPctile10', 'imgAPctile25','imgAPctile75', 'imgAPctile90')

corABMatDataCC <- data.frame(cor(combinedDataCC[keep]))
corABMatDataMLO <- data.frame(cor(combinedDataMLO[keep]))
corABMatDataAll <- data.frame(cor(combinedData[keep]))


#Checking various features via boxplots
#Not Done
#####


#Checking for best individual identifiers in CC and MLO
#####
#MLO

nCols <- ncol(intData)
mloIndRegResult <- data.frame(matrix(ncol = 2, nrow = (nCols-5)))
colnames(mloIndRegResult) <- c('Variable','AUC')
for (i in 6:nCols){

varT <- i
modelData <- trainSetMLO[,c(4,varT)]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
# summary(model)
# confint(model)
# anova(model, test="Chisq")

testPredictionsData <- testSetMLO[,c(4,varT)]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))


p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
# plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
print(colnames(testSetMLO[i]))
auc

mloIndRegResult[(i-5),2] <- auc
mloIndRegResult[(i-5),1] <- colnames(testSetMLO[i])
# with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
}

mloIndRegResult <- data.frame(mloIndRegResult)
sortedMLORegResult <- mloIndRegResult[order(mloIndRegResult$AUC, mloIndRegResult$Variable) , ] 

bestEntriesMLO<-sortedMLORegResult[(nCols-7):(nCols-5),]

nCols <- ncol(intData)
ccIndRegResult <- data.frame(matrix(ncol = 2, nrow = (nCols-5)))
colnames(ccIndRegResult) <- c('Variable','AUC')
for (i in 6:nCols){
  
  varT <- i
  modelData <- trainSetCC[,c(4,varT)]
  model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
  # summary(model)
  # confint(model)
  # anova(model, test="Chisq")
  
  testPredictionsData <- testSetCC[,c(4,varT)]
  fitted.results <- predict(model,newdata=testPredictionsData,type='response')
  fitted.results <- ifelse(fitted.results > 0.5,1,0)
  misClasificError <- mean(fitted.results != testPredictionsData$Interval)
  print(paste('Accuracy',1-misClasificError))
  
  library(ROCR)
  p <- predict(model, newdata=testPredictionsData, type="response")
  pr <- prediction(p, testPredictionsData$Interval)
  prf <- performance(pr, measure = "tpr", x.measure = "fpr")
  #plot(prf)
  
  auc <- performance(pr, measure = "auc")
  auc <- auc@y.values[1]
  print(colnames(testSetMLO[i]))
  auc
  
  ccIndRegResult[(i-5),2] <- auc
  ccIndRegResult[(i-5),1] <- colnames(testSetMLO[i])
  
  # with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))
}


ccIndRegResult <- data.frame(ccIndRegResult)
sortedCCRegResult <- ccIndRegResult[order(ccIndRegResult$AUC, ccIndRegResult$Variable) , ] 

bestEntriesCC<-sortedCCRegResult[(nCols-7):(nCols-5),]

#####
#Testing the MLO/CC Set separately
#Without Controlling for BIRADS Density
#Doing regressions based on those best individual Identifiers
#####


#MLO

#Based on good individual performers
keep = c('Interval','largeStDev','mediumGLCMCorr','imgBPctile90','fullEntropy', 'largeGLCMContrast','imgAPctile75')

#Based on top 3 individual Performers
keep = c('Interval','mediumMedian','mediumPctBelow2','mediumPctBelow3')
#Based on Boxplots
keep = c('Interval','largeMedian','largeEntropy', 'largeSum', 'mediumGLCMCorr', 'mediumGLCMContrast',
         'fullPctBelow2','fullPctile25','imgBSum','imgBPctile90','imgAPctile75')
#Based on choosing only the best boxplot performers
keep = c('Interval','fullGLCMContrast','smallEntropy', 'imgBSum')


modelData<-trainSetMLO[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)
# confint(model)
# anova(model, test="Chisq")


testPredictionsData <- testSetMLO[keep]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
plot(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)
plot(fitted.results)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
plot(testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))

library(ROCR)
p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
auc


with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))



#Testing the CC Set
#Without Controlling for BIRADS Density

#Based on individual performers in regression
keep = c('Interval','largeEntropy', 'mediumGLCMCorr','largePctile25','largePctBelow1','imgBMedian','imgBPctile25', 'imgAPctile75')


#AUC = 0.72 on cc set
#Top 3 performers in regression
keep = c('Interval', 'mediumPctile25')#,'largeEntropy' ,'mediumGLCMCorr')
#Based on BoxPlots
keep = c('Interval','largeEntropy', 'largeMedian','mediumGLCMCorr', 'mediumGLCMContrast','largePctile25','largePctBelow1','largePctBelow4',
         'imgBMedian','imgBPctile25', 'imgAPctile75','imgASum')
#Based on BoxPlots and only keeping significant
keep = c('Interval','largeEntropy', 'largeMedian','mediumGLCMCorr','largePctBelow1', 'imgASum')


modelData<-trainSetCC[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)
confint(model)

anova(model, test="Chisq")

# testSet$Interval <- factor(testSet$Interval)
testPredictionsData <- testSetCC[keep]
# testPredictionsData <- testSet[,c(3,varT)]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
plot(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)
plot(fitted.results)
plot(testPredictionsData$Interval)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))

library(ROCR)
p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
auc


with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))



#Testing the overall method to see if it works.
#It does. which means the problem is my data.

#Testing by combining info from MLO/CC into one

#####


#Controlling for BIRADS Density
#####

#With Controling for BIRADS Density (DON"T HAVE IT ON THIS DATASET.)
trainSet$rank <- factor(trainSet$rank)

keep = c('Interval', 'mediumMedian', 'mediumSum', 'mediumPctile25', 'mediumPctile90', 'mediumPctBelow5', 
         'mediumGLCMEnergy', 'mediumGLCMCorr', 'mediumGLCMContrast', 'mediumGLCMHomog')
modelData <- trainSet[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)
anova(model, test="Chisq")

testPredictionsData <- testSet[keep]
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testPredictionsData$Interval)
print(paste('Accuracy',1-misClasificError))

library(ROCR)
p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$Interval)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc






#BoxPlots for MLO Dataset
#####

# Full IQF Image Stats
feature <-combinedDataMLO$fullMean 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Mean IQF")
feature <-combinedDataMLO$fullMedian 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Median IQF")
feature <-combinedDataMLO$fullStDev
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full StDev IQF")
feature <-combinedDataMLO$fullSum
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Sum IQF")
feature <-combinedDataMLO$fullEntropy
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Entropy IQF")
feature <-combinedDataMLO$fullKurtosis
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Kurtosis IQF")
feature <-combinedDataMLO$fullSkewness 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Skewness IQF")
feature <-combinedDataMLO$fullPctile10 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 10th Percentile IQF")
feature <-combinedDataMLO$fullPctile25 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 25th percentile IQF")
feature <-combinedDataMLO$fullPctile75 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 75th Percentile IQF")
feature <-combinedDataMLO$fullPctile90 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 90th Percentile IQF")
feature <-combinedDataMLO$fullPctBelow2 
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 2", xlab="Percent Interval", ylab = "Percent below IQF 2")
feature <-combinedDataMLO$fullPctBelow3
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 3", xlab="Percent Interval", ylab = "Percent below IQF 3")
feature <-combinedDataMLO$fullPctBelow4
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 4", xlab="Percent Interval", ylab = "Percent below IQF 4")
feature <-combinedDataMLO$fullPctBelow5
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 5", xlab="Percent Interval", ylab = "Percent below IQF 5")
feature <-combinedDataMLO$fullPctBelow7
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 7", xlab="Percent Interval", ylab = "Percent below IQF 7")
feature <-combinedDataMLO$fullPctBelow10
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 10", xlab="Percent Interval", ylab = "Percent below IQF 10")
feature <-combinedDataMLO$fullPctBelow12
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 12", xlab="Percent Interval", ylab = "Percent below IQF 12")
feature <-combinedDataMLO$fullPctBelow14
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 14", xlab="Percent Interval", ylab = "Percent below IQF 14")
feature <-combinedDataMLO$fullPctBelow16
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 16", xlab="Percent Interval", ylab = "Percent below IQF 16")
feature <-combinedDataMLO$fullPctBelow18
boxplot( feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 18", xlab="Percent Interval", ylab = "Percent below IQF 18")
feature <-combinedDataMLO$fullPctBelow20
boxplot(feature~combinedDataMLO$Interval, main="VPD vs Percent below IQF 20", xlab="Percent Interval", ylab = "Percent below IQF 20")
feature <-combinedDataMLO$fullGLCMContrast 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Contrast IQF")
feature <-combinedDataMLO$fullGLCMCorr
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Corr IQF")
feature <-combinedDataMLO$fullGLCMEnergy
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Energy IQF")
feature <-combinedDataMLO$fullGLCMHomog
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Homogeneity IQF")
# A Value of Exp Fit of Image Stats
feature <-combinedDataMLO$imgAMean
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Mean IQF")
feature <-combinedDataMLO$imgAMedian 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Median IQF")
feature <-combinedDataMLO$imgASum
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Sum IQF")
feature <-combinedDataMLO$imgAPctile10
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 10th percentile IQF")
feature <-combinedDataMLO$imgAPctile25
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 25th percentile IQF")
feature <-combinedDataMLO$imgAPctile75
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 75th percentile IQF")
feature <-combinedDataMLO$imgAPctile90
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 90th percentile IQF")
# B Value of Exp Fit of Image Stats
feature <-combinedDataMLO$imgBMean
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Mean IQF")
feature <-combinedDataMLO$imgBMedian 
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Median IQF")
feature <-combinedDataMLO$imgBSum
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Sum IQF")
feature <-combinedDataMLO$imgBPctile10
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 10th percentile IQF")
feature <-combinedDataMLO$imgBPctile25
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 25th percentile IQF")
feature <-combinedDataMLO$imgBPctile75
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 75th percentile IQF")
feature <-combinedDataMLO$imgBPctile90
boxplot(feature~combinedDataMLO$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 90th percentile IQF")




#Boxplots for CC Dataset
#Boxplots fo CC Dataset
##### 
# BoxPLots



# Full IQF Image Stats
feature <-combinedDataCC$fullMean 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Mean IQF")
feature <-combinedDataCC$fullMedian 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Median IQF")
feature <-combinedDataCC$fullStDev
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full StDev IQF")
feature <-combinedDataCC$fullSum
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Sum IQF")
feature <-combinedDataCC$fullEntropy
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Entropy IQF")
feature <-combinedDataCC$fullKurtosis
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Kurtosis IQF")
feature <-combinedDataCC$fullSkewness 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Skewness IQF")
feature <-combinedDataCC$fullPctile10 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 10th Percentile IQF")
feature <-combinedDataCC$fullPctile25 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 25th percentile IQF")
feature <-combinedDataCC$fullPctile75 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 75th Percentile IQF")
feature <-combinedDataCC$fullPctile90 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 90th Percentile IQF")
feature <-combinedDataCC$fullPctBelow2 
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 2", xlab="Percent Interval", ylab = "Percent below IQF 2")
feature <-combinedDataCC$fullPctBelow3
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 3", xlab="Percent Interval", ylab = "Percent below IQF 3")
feature <-combinedDataCC$fullPctBelow4
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 4", xlab="Percent Interval", ylab = "Percent below IQF 4")
feature <-combinedDataCC$fullPctBelow5
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 5", xlab="Percent Interval", ylab = "Percent below IQF 5")
feature <-combinedDataCC$fullPctBelow7
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 7", xlab="Percent Interval", ylab = "Percent below IQF 7")
feature <-combinedDataCC$fullPctBelow10
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 10", xlab="Percent Interval", ylab = "Percent below IQF 10")
feature <-combinedDataCC$fullPctBelow12
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 12", xlab="Percent Interval", ylab = "Percent below IQF 12")
feature <-combinedDataCC$fullPctBelow14
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 14", xlab="Percent Interval", ylab = "Percent below IQF 14")
feature <-combinedDataCC$fullPctBelow16
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 16", xlab="Percent Interval", ylab = "Percent below IQF 16")
feature <-combinedDataCC$fullPctBelow18
boxplot( feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 18", xlab="Percent Interval", ylab = "Percent below IQF 18")
feature <-combinedDataCC$fullPctBelow20
boxplot(feature~combinedDataCC$Interval, main="VPD vs Percent below IQF 20", xlab="Percent Interval", ylab = "Percent below IQF 20")
feature <-combinedDataCC$fullGLCMContrast 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Contrast IQF")
feature <-combinedDataCC$fullGLCMCorr
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Corr IQF")
feature <-combinedDataCC$fullGLCMEnergy
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Energy IQF")
feature <-combinedDataCC$fullGLCMHomog
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Homogeneity IQF")
# A Value of Exp Fit of Image Stats
feature <-combinedDataCC$imgAMean
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Mean IQF")
feature <-combinedDataCC$imgAMedian 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Median IQF")
feature <-combinedDataCC$imgASum
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Sum IQF")
feature <-combinedDataCC$imgAPctile10
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 10th percentile IQF")
feature <-combinedDataCC$imgAPctile25
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 25th percentile IQF")
feature <-combinedDataCC$imgAPctile75
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 75th percentile IQF")
feature <-combinedDataCC$imgAPctile90
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 90th percentile IQF")
# B Value of Exp Fit of Image Stats
feature <-combinedDataCC$imgBMean
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Mean IQF")
feature <-combinedDataCC$imgBMedian 
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Median IQF")
feature <-combinedDataCC$imgBSum
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Sum IQF")
feature <-combinedDataCC$imgBPctile10
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 10th percentile IQF")
feature <-combinedDataCC$imgBPctile25
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 25th percentile IQF")
feature <-combinedDataCC$imgBPctile75
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 75th percentile IQF")
feature <-combinedDataCC$imgBPctile90
boxplot(feature~combinedDataCC$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 90th percentile IQF")
#Sample of doing Logistic Regression
#####

mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")

sampleSet <- mydata[sample(1:nrow(mydata)),]

trainSet <- sampleSet[1:300,]
testSet <- sampleSet[301:400,]



modelData<-trainSet
model <- glm(admit~., family=binomial(logit), data=modelData)
summary(model)



# testSet$Interval <- factor(testSet$Interval)
testPredictionsData <- testSet
fitted.results <- predict(model,newdata=testPredictionsData,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testPredictionsData$admit)
print(paste('Accuracy',1-misClasificError))

library(ROCR)
p <- predict(model, newdata=testPredictionsData, type="response")
pr <- prediction(p, testPredictionsData$admit)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[1]
auc


with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))



#Attempt at combining the MLO and CC data to see if I can leverage both pieces of data
#####
#Attempt1:
#Link the CC and MLO images. 
   #In the cases where there is a left and right side, average the two values maybe. or just choose one.
#Predict with the best CC and best MLO Classifiers
#Combine those two predictions for 'ultra' prediction


