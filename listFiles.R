
# Similar By Statistics
wdInt <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\6.12.17_GenStats_Simulated\\Interval\\Comp\\"
wdScreen <- "W:\\Breast Studies\\Masking\\BJH_MaskingMaps\\6.12.17_GenStats_Simulated\\ScreenDetected\\Comp\\"


# wdDemog = "D:\\LabData\\BreastMasking\\"
wdDemog = "W:\\Breast Studies\\Masking\\"
fileName<-'masking_output.csv'
demogData <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')


##### 
# Masking_Diag_Last Folder

wdCPMC <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\CPMC\\Old_files\\"
wdMGH <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\MGH\\"
wdUCSF <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\UCSF\\"


fileNamesCPMC <- list.files(wdCPMC, ".mat")
fileNamesMGH <- list.files(wdMGH, ".mat")
fileNamesUCSF <- list.files(wdUCSF, ".mat")

install.packages("R.matlab")
require("R.matlab")



tmpCPMC <- data.frame(t(data.frame(strsplit(fileNamesCPMC, '[.]'))))
colnames(tmpCPMC) <- c("PlaceHold", "acquistion_id")

tmpMGH <- data.frame(t(data.frame(strsplit(fileNamesMGH, '[.]'))))
colnames(tmpCPMC) <- c("PlaceHold", "acquistion_id")

tmpUCSF <- data.frame(t(data.frame(strsplit(fileNamesUCSF, '[.]'))))
colnames(tmpMGH) <- c("PlaceHold", "acquistion_id")


nImages <- nrow(tmpCPMC)
for (i in 1:nImages){
  setwd(wdCPMC)
  test <- readMat(fileNamesCPMC[[i]])
  tmpCPMC$acquisition_id[i] <- test$info.dicom.blinded[,,1]$AccessionNumber[,1]
}
 
nImages <- nrow(tmpMGH)
for (i in 1:nImages){
  setwd(wdMGH)
  test <- readMat(fileNamesMGH[[i]])
  tmpMGH$acquisition_id[i] <- test$info.dicom.blinded[,,1]$AccessionNumber[,1]
}

nImages <- nrow(tmpUCSF)
for (i in 1:nImages){
  setwd(wdUCSF)
  test <- readMat(fileNamesUCSF[[i]])
  tmpUCSF$acquisition_id[i] <- test$info.dicom.blinded[,,1]$AccessionNumber[,1]
}


MatchCPMC <- merge(tmpCPMC, demogData, by="acquisition_id")
MatchMGH <- merge(tmpMGH, demogData, by="acquisition_id")
MatchUCSF <- merge(tmpUCSF, demogData, by="acquisition_id")


nMatchCPMC <- nrow(MatchCPMC)
nMatchMGH <- nrow(MatchMGH)
nMatchUCSF <- nrow(MatchUCSF)

setwd("W:\\Breast Studies\\Masking\\AnalysisImages\\")

##### 
# Prelim Analysis Folder


wdCPMCInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\CPMC\\Interval\\"
wdCPMCScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\CPMC\\ScreenDetected\\"
wdMGHInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\MGH\\Interval\\"
wdMGHScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\MGH\\ScreenDetected\\"
wdUCSFInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\UCSF\\Interval\\"
wdUCSFScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\UCSF\\ScreenDetected\\"


fileNamesCPMCInt <- list.files(wdCPMCInt, ".mat")
fileNamesCPMCScD <- list.files(wdCPMCScD, ".mat")
fileNamesMGHInt <- list.files(wdMGHInt, ".mat")
fileNamesMGHScD <- list.files(wdMGHScD, ".mat")
fileNamesUCSFInt <- list.files(wdUCSFInt, ".mat")
fileNamesUCSFScD <- list.files(wdUCSFScD, ".mat")


tmpCPMCInt <- data.frame(t(data.frame(strsplit(fileNamesCPMCInt, '[.]'))))
colnames(tmpCPMCInt) <- c("acquisition_id", "mat")

tmpCPMCScD <- data.frame(t(data.frame(strsplit(fileNamesCPMCScD, '[.]'))))
colnames(tmpCPMCScD) <- c("acquisition_id", "mat")

tmpMGHInt <- data.frame(t(data.frame(strsplit(fileNamesMGHInt, '[.]'))))
colnames(tmpMGHInt) <- c("acquisition_id", "mat")

tmpMGHScD <- data.frame(t(data.frame(strsplit(fileNamesMGHScD, '[.]'))))
colnames(tmpMGHScD) <- c("acquisition_id", "mat")

tmpUCSFInt <- data.frame(t(data.frame(strsplit(fileNamesUCSFInt, '[.]'))))
colnames(tmpUCSFInt) <- c("acquisition_id", "mat")

tmpUCSFScD <- data.frame(t(data.frame(strsplit(fileNamesUCSFScD, '[.]'))))
colnames(tmpUCSFScD) <- c("acquisition_id", "mat")

MatchCPMCInt <- merge(tmpCPMCInt, demogData, by="acquisition_id")
MatchCPMCScD <- merge(tmpCPMCScD, demogData, by="acquisition_id")
MatchMGHInt <- merge(tmpMGHInt, demogData, by="acquisition_id")
MatchMGHScD <- merge(tmpMGHScD, demogData, by="acquisition_id")
MatchUCSFInt <- merge(tmpUCSFInt, demogData, by="acquisition_id")
MatchUCSFScD <- merge(tmpUCSFScD, demogData, by="acquisition_id")



nMatchCPMCInt <- nrow(MatchCPMCInt)
nMatchCPMCScD <- nrow(MatchCPMCScD)
nMatchMGHInt <- nrow(MatchMGHInt)
nMatchMGHScD <- nrow(MatchMGHScD)
nMatchUCSFInt <- nrow(MatchUCSFInt)
nMatchUCSFScD <- nrow(MatchUCSFScD)

