packages <- c("data.table", "reshape2", "dplyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

#Set working directory
path <- getwd()
projectdata <- file.path(path, "project_data")

#Read Data
#Subject Data
TrainingSubjects <- fread(file.path(projectdata, "train", "subject_train.txt"))
TestSubjects  <- fread(file.path(projectdata, "test" , "subject_test.txt" ))

#Activity Data
TrainingActivity <- fread(file.path(projectdata, "train", "Y_train.txt"))
TestActivity  <- fread(file.path(projectdata, "test" , "Y_test.txt" ))

#Measurement Data
TrainingMeasures <- data.table(read.table(file.path(projectdata, "train", "X_train.txt")))
TestMeasures  <- data.table(read.table(file.path(projectdata, "test" , "X_test.txt")))

#Merge Training & Test Subjects
Subjects <- rbind(TrainingSubjects, TestSubjects)
setnames(Subjects, "V1", "subject")

#Merge Training & Test Activities
Activities <- rbind(TrainingActivity, TestActivity)
setnames(Activities, "V1", "activityNumber")

#Merge Training & Test Measurements
Measures <- rbind(TrainingMeasures, TestMeasures)

#Merge Subjects to Activities
SubjectActivities <- cbind(Subjects, Activities)
SubjectActivitiesWithMeasures <- cbind(SubjectActivities, Measures)

#Rearrage by Subject & Activity
setkey(SubjectActivitiesWithMeasures, subject, activityNumber)

#Define Columns in data.table
AllFeatures <- fread(file.path(projectdata, "features.txt"))
setnames(AllFeatures, c("V1", "V2"), c("measureNumber", "measureName"))

#Get Measures Related To mean & std
MeanStd <- AllFeatures[grepl("(mean|std)\\(\\)", measureName)]
MeanStd$Code <- MeanStd[, paste0("V", measureNumber)]
columns <- c(key(dtSubjectAtvitiesWithMeasures), MeanStd$Code)
#Extract information related to mean and std
SubjectActivitesWithMeasuresMeanStd <- subset(SubjectActivitiesWithMeasures, 
                                                select = columns)

#Rename Activity Names
ActivityNames <- fread(file.path(projectdata, "activity_labels.txt"))
setnames(ActivityNames, c("V1", "V2"), c("activityNumber", "activityName"))
SubjectActivitesWithMeasuresMeanStd <- merge(SubjectActivitesWithMeasuresMeanStd, 
                                               ActivityNames, by = "activityNumber", 
                                               all.x = TRUE)

#Sort data.table
setkey(SubjectActivitesWithMeasuresMeanStd, subject, activityNumber, activityName)
SubjectActivitesWithMeasuresMeanStd <- data.table(melt(SubjectActivitesWithMeasuresMeanStd, 
                                                         id=c("subject", "activityName"), 
                                                         measure.vars = c(3:68), 
                                                         variable.name = "measureCode", 
                                                         value.name="measureValue"))

SubjectActivitesWithMeasuresMeanStd <- merge(SubjectActivitesWithMeasuresMeanStd, 
                                               MeanStd[, list(measureNumber, measureCode, measureName)], 
                                               by="measureCode", all.x=TRUE)

SubjectActivitesWithMeasuresMeanStd$activityName <- 
  factor(SubjectActivitesWithMeasuresMeanStd$activityName)
SubjectActivitesWithMeasuresMeanStd$measureName <- 
  factor(SubjectActivitesWithMeasuresMeanStd$measureName)

#Get Averages
Averages <- dcast(SubjectActivitesWithMeasuresMeanStd, 
                          subject + activityName ~ measureName, 
                          mean, 
                          value.var="measureValue")

#Create Tidy Data Set
write.table(Averages, file="tidyData.txt", row.name=FALSE, sep = "\t")