

#Inputs:
install.packages("R.matlab")
install.packages("ROCR")
# file:///W:/Breast Studies/Masking/txt_excels/cpmc_masking.txt
# file:///W:/Breast Studies/Masking/txt_excels/cpmc_masking_rest.txt
# file:///W:/Breast Studies/Masking/txt_excels/masking_diag_last_cpmc.txt


setwd("W:\\Breast Studies\\Masking\\PrelimAnalysis\\12.13.16_CompiledData\\Interval")
fileNames <- list.files("W:\\Breast Studies\\Masking\\PrelimAnalysis\\12.13.16_CompiledData\\Interval")
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



setwd("W:\\Breast Studies\\Masking\\PrelimAnalysis\\12.13.16_CompiledData\\ScreenDetected")

fileNames <- list.files("W:\\Breast Studies\\Masking\\PrelimAnalysis\\12.13.16_CompiledData\\ScreenDetected")
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

#Splits up data by CC and MLO


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

corDataCC <- cor(combinedDataCC[keep])
corDataMLO <- cor(combinedDataMLO[keep])



#Checking various features via boxplots



#Testing the MLO Set
#Without Controlling for BIRADS Density
keep = c('Interval', 'largeMean', 'largeMedian', 'largeStDev', 'largeSum','largeEntropy','largeKurtosis',
         'largeSkewness','largePctile10','largePctile25', 'largePctile75', 'largePctile90', 'largePctBelow2', 'largePctBelow3', 'largePctBelow4',
         'largeGLCMContrast', 'largeGLCMEnergy', 'largeGLCMCorr',  'largeGLCMHomog')
keep = c('Interval', 'mediumMean', 'mediumMedian', 'mediumStDev', 'mediumSum','mediumEntropy','mediumKurtosis',
         'mediumSkewness','mediumPctile10','mediumPctile25', 'mediumPctile75', 'mediumPctile90', 'mediumPctBelow2', 'mediumPctBelow3', 'mediumPctBelow4',
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')
keep = c('Interval', 'smallMean', 'smallMedian', 'smallStDev', 'smallSum','smallEntropy','smallKurtosis',
         'smallSkewness','smallPctile10','smallPctile25', 'smallPctile75', 'smallPctile90', 'smallPctBelow2', 'smallPctBelow3', 'smallPctBelow4',
         'smallGLCMContrast', 'smallGLCMEnergy', 'smallGLCMCorr',  'smallGLCMHomog')
keep = c('Interval', 'fullMean', 'fullMedian', 'fullStDev', 'fullSum','fullEntropy','fullKurtosis',
         'fullSkewness','fullPctile10','fullPctile25', 'fullPctile75', 'fullPctile90', 'fullPctBelow2', 'fullPctBelow3', 'fullPctBelow4',
         'fullGLCMContrast', 'fullGLCMEnergy', 'fullGLCMCorr',  'fullGLCMHomog')
keep = c('Interval','imgAMean','imgAMedian','imgASum','imgAPctile10','imgAPctile25','imgAPctile75','imgAPctile90')
keep = c('Interval','imgBMean','imgBMedian','imgBSum','imgBPctile10','imgBPctile25','imgBPctile75','imgBPctile90')

keep = c('Interval', 'mediumMedian', 'mediumEntropy', 'mediumSkewness','mediumPctile10', 'mediumPctBelow2', 
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')

keep = c('Interval','mediumMedian','mediumStDev','mediumPctile25','mediumPctBelow4', 'mediumEntropy','imgBSum', 'imgBPctile25')
varT <- 120
# modelData <- trainSet[,c(3,varT)]
# trainSet$Interval <- factor(trainSet$Interval)

modelData<-trainSetMLO[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)
# confint(model)

# anova(model, test="Chisq")

# testSet$Interval <- factor(testSet$Interval)
testPredictionsData <- testSetMLO[keep]
# testPredictionsData <- testSet[,c(3,varT)]
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
auc <- auc@y.values[1]
auc


with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))








#Testing the CC Set
#Without Controlling for BIRADS Density
keep = c('Interval', 'largeMean', 'largeMedian', 'largeStDev', 'largeSum','largeEntropy','largeKurtosis',
         'largeSkewness','largePctile10','largePctile25', 'largePctile75', 'largePctile90', 'largePctBelow2', 'largePctBelow3', 'largePctBelow4',
         'largeGLCMContrast', 'largeGLCMEnergy', 'largeGLCMCorr',  'largeGLCMHomog')
keep = c('Interval', 'mediumMean', 'mediumMedian', 'mediumStDev', 'mediumSum','mediumEntropy','mediumKurtosis',
         'mediumSkewness','mediumPctile10','mediumPctile25', 'mediumPctile75', 'mediumPctile90', 'mediumPctBelow2', 'mediumPctBelow3', 'mediumPctBelow4',
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')
keep = c('Interval','imgAMean','imgAMedian','imgASum','imgAPctile10','imgAPctile25','imgAPctile75','imgAPctile90')
keep = c('Interval','imgBMean','imgBMedian','imgBSum','imgBPctile10','imgBPctile25','imgBPctile75','imgBPctile90')

keep = c('Interval', 'mediumMedian', 'mediumEntropy', 'mediumSkewness','mediumPctile10', 'mediumPctBelow2', 
         'mediumGLCMContrast', 'mediumGLCMEnergy', 'mediumGLCMCorr',  'mediumGLCMHomog')


keep = c('Interval','largeMedian','largeSum','largeKurtosis', 'largeSkewness','largePctile10','largePctBelow2', 'largeGLCMEnergy','largeGLCMCorr',
         'imgAPctile90', 'imgASum')

varT <- 120
# modelData <- trainSet[,c(3,varT)]
# trainSet$Interval <- factor(trainSet$Interval)


# keep = c('Interval','mediumMedian')
modelData<-trainSetCC[keep]
model <- glm(modelData$Interval~., family=binomial(logit), data=modelData)
summary(model)
confint(model)

anova(model, test="Chisq")

# testSet$Interval <- factor(testSet$Interval)
testPredictionsData <- testSetCC[keep]
# testPredictionsData <- testSet[,c(3,varT)]
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
auc <- auc@y.values[1]
auc


with(model, pchisq(null.deviance - deviance, df.null - df.residual, lower.tail = FALSE))



#Testing the overall method to see if it works.
#It does. which means the problem is my data.
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


#####

relevantData <- combinedData[,c("Interval","fullMean",
                            "fullMedian", "fullSum", "fullEntropy",
                            "fullKurtosis", "fullSkewness", "fullPctile10",
                            "fullPctile25", "fullPctile75", "fullPctile90",
                            "fullGLCMContrast", "fullGLCMCorr", "fullGLCMEnergy",
                            "fullGLCMHomog",
                            "fullPctBelow2","fullPctBelow3","fullPctBelow4"
                            ,"fullPctBelow5","fullPctBelow7","fullPctBelow10"
                            ,"fullPctBelow12","fullPctBelow14","fullPctBelow16"
                            ,"fullPctBelow18","fullPctBelow20")]
fullCorVals <- cor(relevantData, relevantData, use="complete")

cor(combinedData[keep])



##### BoxPLots


feature <-combinedData$fullMean 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Medium Mean IQF")


# Full IQF Image Stats
feature <-combinedData$fullMean 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Mean IQF")
feature <-combinedData$fullMedian 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Median IQF")
feature <-combinedData$fullStDev
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full StDev IQF")
feature <-combinedData$fullSum
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Sum IQF")
feature <-combinedData$fullEntropy
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Entropy IQF")
feature <-combinedData$fullKurtosis
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Kurtosis IQF")
feature <-combinedData$fullSkewness 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full Skewness IQF")
feature <-combinedData$fullPctile10 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 10th Percentile IQF")
feature <-combinedData$fullPctile25 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 25th percentile IQF")
feature <-combinedData$fullPctile75 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 75th Percentile IQF")
feature <-combinedData$fullPctile90 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full 90th Percentile IQF")
feature <-combinedData$fullPctBelow2 
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 2", xlab="Percent Interval", ylab = "Percent below IQF 2")
feature <-combinedData$fullPctBelow3
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 3", xlab="Percent Interval", ylab = "Percent below IQF 3")
feature <-combinedData$fullPctBelow4
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 4", xlab="Percent Interval", ylab = "Percent below IQF 4")
feature <-combinedData$fullPctBelow5
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 5", xlab="Percent Interval", ylab = "Percent below IQF 5")
feature <-combinedData$fullPctBelow7
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 7", xlab="Percent Interval", ylab = "Percent below IQF 7")
feature <-combinedData$fullPctBelow10
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 10", xlab="Percent Interval", ylab = "Percent below IQF 10")
feature <-combinedData$fullPctBelow12
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 12", xlab="Percent Interval", ylab = "Percent below IQF 12")
feature <-combinedData$fullPctBelow14
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 14", xlab="Percent Interval", ylab = "Percent below IQF 14")
feature <-combinedData$fullPctBelow16
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 16", xlab="Percent Interval", ylab = "Percent below IQF 16")
feature <-combinedData$fullPctBelow18
boxplot( feature~combinedData$Interval, main="VPD vs Percent below IQF 18", xlab="Percent Interval", ylab = "Percent below IQF 18")
feature <-combinedData$fullPctBelow20
boxplot(feature~combinedData$Interval, main="VPD vs Percent below IQF 20", xlab="Percent Interval", ylab = "Percent below IQF 20")
feature <-combinedData$fullGLCMContrast 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Contrast IQF")
feature <-combinedData$fullGLCMCorr
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Corr IQF")
feature <-combinedData$fullGLCMEnergy
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Energy IQF")
feature <-combinedData$fullGLCMHomog
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Full GLCM Homogeneity IQF")
# A Value of Exp Fit of Image Stats
feature <-combinedData$imgAMean
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Mean IQF")
feature <-combinedData$imgAMedian 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Median IQF")
feature <-combinedData$imgASum
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value Sum IQF")
feature <-combinedData$imgAPctile10
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 10th percentile IQF")
feature <-combinedData$imgAPctile25
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 25th percentile IQF")
feature <-combinedData$imgAPctile75
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 75th percentile IQF")
feature <-combinedData$imgAPctile90
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit A Value 90th percentile IQF")
# B Value of Exp Fit of Image Stats
feature <-combinedData$imgBMean
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Mean IQF")
feature <-combinedData$imgBMedian 
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Median IQF")
feature <-combinedData$imgBSum
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value Sum IQF")
feature <-combinedData$imgBPctile10
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 10th percentile IQF")
feature <-combinedData$imgBPctile25
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 25th percentile IQF")
feature <-combinedData$imgBPctile75
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 75th percentile IQF")
feature <-combinedData$imgBPctile90
boxplot(feature~combinedData$Interval, main = "Feature vs. Interval", xlab ="Interval (Yes=1)", ylab="Exp Fit B Value 90th percentile IQF")
