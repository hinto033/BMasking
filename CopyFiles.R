
# wdDemog = "D:\\LabData\\BreastMasking\\"
wdKey = "W:\\Breast Studies\\Masking\\"
fileName<-'masking_matched.csv'
maskKey <- read.csv(file=paste(wdKey,fileName, sep=''),header=TRUE, sep=',')
nImages <-nrow(maskKey)



# site_id = CPMC, MGH, UCSF
# acquisition_id = acq number
# density
# group


dataDriveNum = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
dataDriveLet = c('W', 'U', 'O', 'P', 'Q', 'R', 'S', 'L', 'K', 'J')


medCenter <- maskKey$site_id
acqID <- maskKey$acquisition_id
fullFile<- as.character(maskKey$filename)

str_Data = (strsplit(fullFile, split='aaData', fixed=TRUE))
str_data = (strsplit(fullFile, split='aadata', fixed=TRUE))
str_DATA = (strsplit(fullFile, split='aaDATA', fixed=TRUE))

str_imgName = (strsplit(fullFile, split='\\', fixed=TRUE))
fileLoc<-NULL
imgName<-NULL
#Arrange all the locations in the correct way.
errCount=0
for (i in 1:nImages){
  
  if (length(str_Data[[i]])==2){
    driveNum<-as.numeric(substring(str_Data[[i]][2], 1, 1))
    strStart<-2
    if (is.na(driveNum)){ driveNum<-1
    strStart<-1 }
    driveRest<-(substring(str_Data[[i]][2], strStart, (nchar(str_Data[[i]][2])-7)))
    fileLoc[i]<-paste(dataDriveLet[driveNum],':', driveRest, sep='')
  }
  else if (length(str_data[[i]])==2){
    driveNum<-as.numeric(substring(str_data[[i]][2], 1, 1))
    strStart<-2
    if (is.na(driveNum)){ driveNum<-1
    strStart<-1 }
    driveRest<-(substring(str_data[[i]][2], strStart, (nchar(str_data[[i]][2])-7)))
    fileLoc[i]<-paste(dataDriveLet[driveNum],':', driveRest, sep='')
  }
  else if (length(str_DATA[[i]])==2){
    driveNum<-as.numeric(substring(str_DATA[[i]][2], 1, 1))
    strStart<-2
    if (is.na(driveNum)){ driveNum<-1
    strStart<-1 }
    driveRest<-(substring(str_DATA[[i]][2], strStart, (nchar(str_DATA[[i]][2])-7)))
    fileLoc[i]<-paste(dataDriveLet[driveNum],':', driveRest, sep='')
  }
  else {
    fileLoc[i]<-paste('ERROR', str_Data[[i]][1], sep='_')
    errCount<-errCount+1
  }
  nSubDirs <- length(str_imgName[[i]])
  imgName[i] <- substring(str_imgName[[i]][nSubDirs], 1, (nchar(str_imgName[[i]][nSubDirs])-7))
}


savePathBase <- 'W:\\Breast Studies\\Masking\\Correct_MaskingImages\\'


pngFilePath<- paste(fileLoc, 'raw.png', sep='')
matFilePath<- paste(fileLoc, '.mat', sep='')

copyWorked<-file.copy(pngFilePath, savePathBase)
newImgDirPng <- paste(savePathBase, imgName, 'raw.png', sep='')
filePngNewNames <- paste(savePathBase, maskKey$site_id,'_',maskKey$group,'_',maskKey$acquisition_id, '.png', sep='' )

renameWorked<-file.rename(newImgDirPng, filePngNewNames)


file.copy(matFilePath, savePathBase)
newImgDirMat <- paste(savePathBase, imgName, '.mat', sep='')
fileMatNewNames <- paste(savePathBase, maskKey$site_id,'_',maskKey$group,'_',maskKey$acquisition_id, '.mat', sep='' )

file.rename(newImgDirMat, fileMatNewNames)



write.csv(maskKeyError, file = paste(wdKey,"Masking_ErrorImageDirectories.csv", sep=""),row.names=TRUE)
write.csv(maskKeyWorked, file = paste(wdKey,"Masking_WorkingImageDirectories.csv", sep=""),row.names=TRUE)


#####
# > maskKeyWorked<-NULL
# > maskkeyWorked<- subset(maskKey, maskKey$copyWorked=="TRUE")
# > View(maskkeyWorked)
# > length(unique(maskKeyworked$linkage_id[maskKeyworked$group == 'FN']))
# Error in unique(maskKeyworked$linkage_id[maskKeyworked$group == "FN"]) : 
#   object 'maskKeyworked' not found
# > length(unique(maskKeyWorked$linkage_id[maskKeyWorked$group == 'FN']))
# [1] 0
# > maskkeyWorkedInt <- subset(maskKeyWorked, maskKey$group=="FN")
# > length(unique(maskkeyWorkedInt$linkage_id))
# [1] 0
# > maskkeyWorkedInt <- subset(maskKeyWorked, maskKeyWorked$group=="FN")
# > maskKeyWorkedInt <- subset(maskKeyWorked, maskKeyWorked$group=="FN")
# > maskKeyWorked<- subset(maskKey, maskKey$copyWorked=="TRUE")
# > maskKeyWorkedInt <- subset(maskKeyWorked, maskKeyWorked$group=="FN")
# > maskKeyWorkedScreen <- subset(maskKeyWorked, maskKeyWorked$group=="TP")
# > length(unique(maskKeyWorkedScreen$linkage_id))
# [1] 101
# > length(unique(maskKeyWorkedInt$linkage_id))
# [1] 102
# > file.copy(matFilePath, savePathBase)
# maskKeyError<-maskKey[copyWorked == 'FALSE']
# Error in `[.data.frame`(maskKey, copyWorked == "FALSE") : 
#   undefined columns selected
# > maskKeyError<-maskKey[maskKey$copyWorked == 'FALSE']
# Error in `[.data.frame`(maskKey, maskKey$copyWorked == "FALSE") : 
#   undefined columns selected
# > maskkeyError<-NULL
# > maskKeyError<-maskKey[maskKey$copyWorked == 'FALSE']
# Error in `[.data.frame`(maskKey, maskKey$copyWorked == "FALSE") : 
#   undefined columns selected
# > maskKeyError<-subset(maskKey, maskKey$copyWorked == 'FALSE')
# > View(maskKeyError)
# > View(maskKeyError)
