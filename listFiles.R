#####

install.packages("R.matlab")
require("R.matlab")

#####

# wdDemog = "D:\\LabData\\BreastMasking\\"
wdDemog = "W:\\Breast Studies\\Masking\\"
fileName<-'masking_output.csv'
demogData <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

#
fileName<-'cancer_images_masking.csv'
maskingKey <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')


maskingData<- merge(maskingKey,demogData, by='acquisition_id')

table(maskingData$study_record)
length(unique(maskingData$linkage_id))
table(maskingData$age)

table(maskingData$race2)

table(maskingData$bmi)



##### 
# Masking_Diag_Last Folder

wdCPMC <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\CPMC\\Old_files\\"
wdMGH <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\MGH\\"
wdUCSF <- "W:\\Breast Studies\\Masking\\Masking_diag_last\\UCSF\\"

fileNamesCPMC <- list.files(wdCPMC, ".mat")
fileNamesMGH <- list.files(wdMGH, ".mat")
fileNamesUCSF <- list.files(wdUCSF, ".mat")

tmpCPMC <- data.frame(t(data.frame(strsplit(fileNamesCPMC, '[.]'))))
tmpCPMC$Center <- "CPMC"
tmpCPMC$Type <- "Uncertain"
tmpCPMC <- cbind(tmpCPMC, fileNamesCPMC)
colnames(tmpCPMC) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpMGH <- data.frame(t(data.frame(strsplit(fileNamesMGH, '[.]'))))
tmpMGH$Center <- "MGH"
tmpMGH$Type <- "Uncertain"
tmpMGH <- cbind(tmpMGH, fileNamesMGH)
colnames(tmpMGH) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpUCSF <- data.frame(t(data.frame(strsplit(fileNamesUCSF, '[.]'))))
tmpUCSF$Center <- "UCSF"
tmpUCSF$Type <- "Uncertain"
tmpUCSF <- cbind(tmpUCSF, fileNamesUCSF)
colnames(tmpUCSF) <- c("baseFileName", "mat", "Center", "Type", "FileNames")



possMaskingSet <- rbind(tmpCPMC, tmpMGH, tmpUCSF)

nImages <- nrow(possMaskingSet)

for (i in 1:nImages){
  
  if (possMaskingSet$Center[i]=="CPMC"){
    setwd(wdCPMC)
  }else if (possMaskingSet$Center[i]=="MGH"){
    setwd(wdMGH)
  }else if (possMaskingSet$Center[i]=="UCSF"){
    setwd(wdUCSF)
  }
    
  
  # setwd(paste(wdBase,possMaskingSet$Center[i],'\\',possMaskingSet$Type[i],'\\', sep=""))
  test <- readMat(possMaskingSet$FileNames[i],'.mat', sep="")
  
  #Accession Number
  if (length(test$info.dicom.blinded[,,1]$AccessionNumber[,1])>0){
    possMaskingSet$acquisition_id[i] <- test$info.dicom.blinded[,,1]$AccessionNumber[,1]
  }else {possMaskingSet$acquisition_id[i] <- "NA"}
  
  #Implant Status
  if (length(test$info.dicom.blinded[,,1]$ImplantPresent[,1])>0){
    possMaskingSet$implantPresent[i] <- test$info.dicom.blinded[,,1]$ImplantPresent[,1]
  }else {possMaskingSet$implantPresent[i] <- "NA"}
  
  #If Pixel Intensity relationship right
  if (length(test$info.dicom.blinded[,,1]$PixelIntensityRelationship[,1])>0){
    possMaskingSet$pixelRelationship[i] <- test$info.dicom.blinded[,,1]$PixelIntensityRelationship[,1]
  }else {possMaskingSet$pixelRelationship[i] <- "NA"}
  
  #If the Image is Inverted Color
  if (length(test$info.dicom.blinded[,,1]$PixelIntensityRelationshipSign[,1])>0){
    possMaskingSet$pixelSign[i] <- test$info.dicom.blinded[,,1]$PixelIntensityRelationshipSign[,1]
  }else {possMaskingSet$pixelSign[i]  <- "NA"}
  
  #If it has Spot mammo or anything else.
  if (length(test$info.dicom.blinded[,,1]$ViewCodeSequence[,,1]$Item.1[,,1]$ViewModifierCodeSequence)>0){
    possMaskingSet$mammoType[i] <- test$info.dicom.blinded[,,1]$ViewCodeSequence[,,1]$Item.1[,,1]$ViewModifierCodeSequence[,,1]$Item.1[,,1]$CodeMeaning[,1]
  }else {possMaskingSet$mammoType[i] <- "NA"}
  
}

#Analyze to see how many are in the masking set
possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))
length(unique(possMaskingSetwDemog$linkage_new))
#Check with Masking_diag_last.csv
#####
# W:\Breast Studies\Masking\txt_excels
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last.csv'
possMaskingSet <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))

#Check with Masking_diag_last_all.csv
#####
# W:\Breast Studies\Masking\txt_excels
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last_all.txt'
possMaskingSet <- read.table(file=paste(wdDemog,fileName, sep=''))
colnames(possMaskingSet) <- "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))


#Check with cpmc_masking+ucsf_masking+mgh_masking (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'cpmc_masking.csv'
possMaskingSet1 <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'ucsf_masking.csv'
possMaskingSet2 <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'mgh_masking.csv'
possMaskingSet3 <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

possMaskingSet <- rbind(possMaskingSet1,possMaskingSet2,possMaskingSet3 )


possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id.x))


#Check with Acq_ALL_List.csv
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'Acq_ALL_List.csv'
possMaskingSet <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

possMaskingSet <- rbind(possMaskingSet1,possMaskingSet2,possMaskingSet3 )


possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id.x))


#Check with Copy of masking_diag.csv
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'Copy of masking_diag.csv'
possMaskingSet <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_new.x))


#Check with mgh_priors.txt (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'mgh_priors.txt'
possMaskingSet <- read.table(file=paste(wdDemog,fileName, sep=''))
colnames(possMaskingSet)= "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))

#Check with mgh_priors.txt (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'mgh_priors_test.txt'
possMaskingSet <- read.table(file=paste(wdDemog,fileName, sep=''))
colnames(possMaskingSet)= "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))


#Check with all UCSF .txt ones .txt (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_UCSF_list_notprecessed.txt'
possMaskingSet1 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing7.txt'
possMaskingSet2 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing6_pres.txt'
possMaskingSet3 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing5.txt'
possMaskingSet4 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing4.txt'
possMaskingSet5 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing3.txt'
possMaskingSet6 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing2.txt'
possMaskingSet7 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing.txt'
possMaskingSet8 <- read.table(file=paste(wdDemog,fileName, sep=''))

possMaskingSet<- rbind(possMaskingSet1, possMaskingSet2, possMaskingSet3, 
                       possMaskingSet4, possMaskingSet5, possMaskingSet6,
                       possMaskingSet7, possMaskingSet8)

colnames(possMaskingSet)= "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))


#Check with mgh_priors.txt (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'cpmc_masking_rest.txt'
possMaskingSet <- read.table(file=paste(wdDemog,fileName, sep=''))
colnames(possMaskingSet)= "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))


#Check with masking_diag_last_ucsf+cpmc+mgh (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last_ucsf.txt'
possMaskingSet1 <- read.table(file=paste(wdDemog,fileName, sep=''))

wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last_mgh.txt'
possMaskingSet2 <- read.table(file=paste(wdDemog,fileName, sep=''))

wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last_cpmc.txt'
possMaskingSet3 <- read.table(file=paste(wdDemog,fileName, sep=''))

possMaskingSet <- rbind(possMaskingSet1,possMaskingSet2,possMaskingSet3 )
colnames(possMaskingSet) <- "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))



#Check with masking_diag_last_all (all .csvs)
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_diag_last_all.txt'
possMaskingSet <- read.table(file=paste(wdDemog,fileName, sep=''))
colnames(possMaskingSet) <- "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))

#Check with Copy of masking_diag.csv
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'MGH_BeforeCurrentDateAcq.csv'
possMaskingSet <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_new.x))


#Test all
#####
wdDemog = "W:\\Breast Studies\\Masking\\txt_excels\\"
fileName<-'masking_UCSF_list_notprecessed.txt'
possMaskingSet1 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing7.txt'
possMaskingSet2 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing6_pres.txt'
possMaskingSet3 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing5.txt'
possMaskingSet4 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing4.txt'
possMaskingSet5 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing3.txt'
possMaskingSet6 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing2.txt'
possMaskingSet7 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_UCSF_list_missing.txt'
possMaskingSet8 <- read.table(file=paste(wdDemog,fileName, sep=''))

fileName<-'mgh_priors.txt'
possMaskingSet9 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'mgh_priors_test.txt'
possMaskingSet10 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'cpmc_masking_rest.txt'
possMaskingSet11 <- read.table(file=paste(wdDemog,fileName, sep=''))

fileName<-'masking_diag_last_all.txt'
possMaskingSet12 <- read.table(file=paste(wdDemog,fileName, sep=''))

fileName<-'masking_diag_last_ucsf.txt'
possMaskingSet13 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_diag_last_cpmc.txt'
possMaskingSet14 <- read.table(file=paste(wdDemog,fileName, sep=''))
fileName<-'masking_diag_last_mgh.txt'
possMaskingSet15 <- read.table(file=paste(wdDemog,fileName, sep=''))

possMaskingSet<- rbind(possMaskingSet1, possMaskingSet2, possMaskingSet3, 
                       possMaskingSet4, possMaskingSet5, possMaskingSet6,
                       possMaskingSet7, possMaskingSet8, possMaskingSet9,
                       possMaskingSet10, possMaskingSet11, possMaskingSet12, 
                       possMaskingSet13, possMaskingSet14, possMaskingSet15)

colnames(possMaskingSet)= "acquisition_id"

possMaskingSetwDemog <- merge(possMaskingSet, maskingData, by='acquisition_id')
length(unique(possMaskingSetwDemog$linkage_id))



#All Junk below this.
#####







table(possMaskingSet$Type)

#Now Merge with the overall demographic Info
allInDatabaseM <- merge(demogData, allImagesM, by="acquisition_id")

#Now get summaries of each 'Problem Case'

#Number of each mammo
table(allInDatabaseM$mammoType)

#Number in each center
table(allInDatabaseM$Center)

#Number with Implant
table(allInDatabaseM$implantPresent)

#Checking pixel relationships
table(allInDatabaseM$pixelRelationship)

#Checking Pixel Signs
table(allInDatabaseM$pixelSign)

#Checking the interval/noninterval amounts
table(allInDatabaseM$Type)


## Adding label to say which directory these ones came from.
allInDatabaseM$Directory <- "MaskingDiagLast"

##### 
# Prelim Analysis Folder


wdCPMCInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\CPMC\\Interval\\"
wdCPMCScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\CPMC\\ScreenDetected\\"
wdMGHInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\MGH\\Interval\\"
wdMGHScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\MGH\\ScreenDetected\\"
wdUCSFInt <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\UCSF\\Interval\\"
wdUCSFScD <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\UCSF\\ScreenDetected\\"
wdBase <- "W:\\Breast Studies\\Masking\\PrelimAnalysis\\"

fileNamesCPMCInt <- list.files(wdCPMCInt, ".mat")
fileNamesCPMCScD <- list.files(wdCPMCScD, ".mat")
fileNamesMGHInt <- list.files(wdMGHInt, ".mat")
fileNamesMGHScD <- list.files(wdMGHScD, ".mat")
fileNamesUCSFInt <- list.files(wdUCSFInt, ".mat")
fileNamesUCSFScD <- list.files(wdUCSFScD, ".mat")


tmpCPMCInt <- data.frame(t(data.frame(strsplit(fileNamesCPMCInt, '[.]'))))
tmpCPMCInt$Center <- "CPMC"
tmpCPMCInt$Type <- "Interval"
tmpCPMCInt <- cbind(tmpCPMCInt, fileNamesCPMCInt)
colnames(tmpCPMCInt) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpCPMCScD <- data.frame(t(data.frame(strsplit(fileNamesCPMCScD, '[.]'))))
tmpCPMCScD$Center <- "CPMC"
tmpCPMCScD$Type <- "ScreenDetected"
tmpCPMCScD <- cbind(tmpCPMCScD, fileNamesCPMCScD)
colnames(tmpCPMCScD) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpMGHInt <- data.frame(t(data.frame(strsplit(fileNamesMGHInt, '[.]'))))
tmpMGHInt$Center <- "MGH"
tmpMGHInt$Type <- "Interval"
tmpMGHInt <- cbind(tmpMGHInt, fileNamesMGHInt)
colnames(tmpMGHInt) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpMGHScD <- data.frame(t(data.frame(strsplit(fileNamesMGHScD, '[.]'))))
tmpMGHScD$Center <- "MGH"
tmpMGHScD$Type <- "ScreenDetected"
tmpMGHScD <- cbind(tmpMGHScD, fileNamesMGHScD)
colnames(tmpMGHScD) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpUCSFInt <- data.frame(t(data.frame(strsplit(fileNamesUCSFInt, '[.]'))))
tmpUCSFInt$Center <- "UCSF"
tmpUCSFInt$Type <- "Interval"
tmpUCSFInt <- cbind(tmpUCSFInt, fileNamesUCSFInt)
colnames(tmpUCSFInt) <- c("baseFileName", "mat", "Center", "Type", "FileNames")

tmpUCSFScD <- data.frame(t(data.frame(strsplit(fileNamesUCSFScD, '[.]'))))
tmpUCSFScD$Center <- "UCSF"
tmpUCSFScD$Type <- "ScreenDetected"
tmpUCSFScD <- cbind(tmpUCSFScD, fileNamesUCSFScD)
colnames(tmpUCSFScD) <- c("baseFileName", "mat", "Center", "Type", "FileNames")


allImages <- rbind(tmpCPMCInt, tmpCPMCScD, tmpMGHInt, 
                   tmpMGHScD, tmpUCSFInt, tmpUCSFScD)

nImages <- nrow(allImages)

for (i in 1:nImages){
  
  
  setwd(paste(wdBase,allImages$Center[i],'\\',allImages$Type[i],'\\', sep=""))
  test <- readMat(paste(allImages$baseFileName[i],'.mat', sep=""))
  
  #Accession Number
  if (length(test$info.dicom.blinded[,,1]$AccessionNumber[,1])>0){
  allImages$acquisition_id[i] <- test$info.dicom.blinded[,,1]$AccessionNumber[,1]
  }else {allImages$acquisition_id[i] <- "NA"}
  
  #Implant Status
  if (length(test$info.dicom.blinded[,,1]$ImplantPresent[,1])>0){
  allImages$implantPresent[i] <- test$info.dicom.blinded[,,1]$ImplantPresent[,1]
  }else {allImages$implantPresent[i] <- "NA"}
  
  #If Pixel Intensity relationship right
  if (length(test$info.dicom.blinded[,,1]$PixelIntensityRelationship[,1])>0){
  allImages$pixelRelationship[i] <- test$info.dicom.blinded[,,1]$PixelIntensityRelationship[,1]
  }else {allImages$pixelRelationship[i] <- "NA"}
  
  #If the Image is Inverted Color
  if (length(test$info.dicom.blinded[,,1]$PixelIntensityRelationshipSign[,1])>0){
  allImages$pixelSign[i] <- test$info.dicom.blinded[,,1]$PixelIntensityRelationshipSign[,1]
  }else {allImages$pixelSign[i]  <- "NA"}
  
  #If it has Spot mammo or anything else.
  if (length(test$info.dicom.blinded[,,1]$ViewCodeSequence[,,1]$Item.1[,,1]$ViewModifierCodeSequence)>0){
  allImages$mammoType[i] <- test$info.dicom.blinded[,,1]$ViewCodeSequence[,,1]$Item.1[,,1]$ViewModifierCodeSequence[,,1]$Item.1[,,1]$CodeMeaning[,1]
  }else {allImages$mammoType[i] <- "NA"}
  
}

table(allImages$Type)

keep<- c('acquisition_id', 'bmi')
bmiData <- demogData[keep]

allImages<-merge(allImages, bmiData, by='acquisition_id')



#Now Merge with the overall demographic Info
allInDatabase <- merge(demogData, allImages, by="acquisition_id")

#Now get summaries of each 'Problem Case'

#Number of each mammo
table(allInDatabase$mammoType)

#Number in each center
table(allInDatabase$Center)

#Number with Implant
table(allInDatabase$implantPresent)

#Checking pixel relationships
table(allInDatabase$pixelRelationship)

#Checking Pixel Signs
table(allInDatabase$pixelSign)

#Checking the interval/noninterval amounts
table(allInDatabase$Type)


## Adding label to say which directory these ones came from.
allInDatabase$Directory <- "PrelimAnalysis"



ttest <- merge(allInDatabaseM, allInDatabase, by="acquisition_id")




newdataInt <- subset(allInDatabase, Type=="Interval")
length(unique(newdataInt$bmi.y))
table(newdataInt$Type)
#####

