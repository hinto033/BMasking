#####

#DemogData
wdDemog = "W:\\Breast Studies\\Masking\\"
fileName<-'masking_output.csv'
demogData <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')


#The key
fileName<-'cancer_images_masking.csv'
maskingKey <- read.csv(file=paste(wdDemog,fileName, sep=''),header=TRUE, sep=',')

#Interval Cancer Database
wdInt = "W:\\Breast Studies\\Masking\\txt_excels\\"
setwd(wdInt)
fileName <- 'ucsf_masking.csv'
ucsfInt <- read.csv(file=paste(wdInt,fileName, sep=''),header=TRUE, sep=',')
ucsfInt$cancerType <- 'interval'
fileName <- 'mgh_masking.csv'
mghInt <- read.csv(file=paste(wdInt,fileName, sep=''),header=TRUE, sep=',')
mghInt$cancerType <- 'interval'
fileName <- 'cpmc_masking.csv'
cpmcInt <- read.csv(file=paste(wdInt,fileName, sep=''),header=TRUE, sep=',')
cpmcInt$cancerType <- 'interval'
keep = c('acquisition_id','center','cancerType')


#Interval Cancer Database
setwd(wdInt)
fileName <- 'masking_diag_last_ucsf.txt'
ucsfScD <- read.table(file=paste(wdInt,fileName, sep=''))
ucsfScD$center <- 'UCSF'
ucsfScD$cancerType <- 'screenDetected'
colnames(ucsfScD) <- c("acquisition_id", "center", 'cancerType')
fileName <- 'masking_diag_last_mgh.txt'
mghScD <- read.table(file=paste(wdInt,fileName, sep=''))
mghScD$center <- 'MGH'
mghScD$cancerType <- 'screenDetected'
colnames(mghScD) <- c("acquisition_id", "center", 'cancerType')
fileName <- 'masking_diag_last_cpmc.txt'
cpmcScD <- read.table(file=paste(wdInt,fileName, sep=''))
cpmcScD$center <- 'CPMC'
cpmcScD$cancerType <- 'screenDetected'
colnames(cpmcScD) <- c("acquisition_id", "center", 'cancerType')

alltxts <- rbind(cpmcInt[keep], cpmcScD, mghInt[keep], mghScD, ucsfInt[keep], ucsfScD)

txtsScD <- rbind(cpmcScD,  mghScD,  ucsfScD)
txtsInt <- rbind(cpmcInt[keep],  mghInt[keep],  ucsfInt[keep])

testNums <- merge(alltxts, demogData, by='acquisition_id')

table(testNums$cancerType)




allIntervals<- merge(maskingKey, txtsInt, by='acquisition_id')

allScreens <- merge(maskingKey, txtsScD, by='acquisition_id')