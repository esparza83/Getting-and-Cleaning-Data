rm(list = ls())
getwd()

setwd("...\\UCI HAR Dataset")  

library(data.table)
#Load labels and features
y <- fread(paste0(getwd(),"/test/y_test.txt"))
y <- rbind( y, fread(paste0(getwd(),"/train/y_train.txt")))
acti <- fread("activity_labels.txt")
acti$V2 <- gsub('WALKING_UPSTAIRS', 'Walking_up', acti$V2)
acti$V2 <- gsub('WALKING_DOWNSTAIRS', 'Walking_down', acti$V2)
acti$V2 <- gsub('SITTING', 'Sit_down', acti$V2)
acti$V2 <- gsub('STANDING', 'Stand_up', acti$V2)
acti$V2 <- gsub('WALKING', 'Walk', acti$V2)
acti$V2 <- gsub('LAYING', 'Lay_down', acti$V2)
activity <- merge(x = acti,y = y, by = "V1")
activity <- activity$V2


#load data and combine
subject1 <- read.table(paste0(getwd(),"/test/subject_test.txt"))
subject2 <- read.table(paste0(getwd(),"/train/subject_train.txt"))
subject <- rbind(subject1, subject2)
x <- read.table(paste0(getwd(),"/test/X_test.txt"))
x1 <- read.table(paste0(getwd(),"/train/X_train.txt"))
x3 <- rbind(x,x1)
feact <- fread("features.txt")
feact  <- feact$V2
colnames(x3) <- feact

#Merge labels with data 
activity <- cbind(activity, subject)
colnames(activity)  <- sub("V1","subject",names(activity))
final <- cbind(activity,x3)
#Columns std and mean
final <- final[c(grep("subject|activity*|*mean()-*|*std()-*",colnames(final)))]
final <- final[!grepl("*meanFr*",colnames(final))]
#Std col names
colnames(final) <- sub("\\()","",names(final))
colnames(final) <- gsub("-",".",names(final))
colnames(final) <- sub("tB","time.B",names(final))
colnames(final) <- sub("fB","frequency.B",names(final))
colnames(final) <- sub("tG","time.G",names(final))
colnames(final) <- sub("fG","frequency.G",names(final))
colnames(final) <- sub("BodyBody","Body",names(final))
colnames(final) <- gsub("Body","body",names(final))
colnames(final) <- sub("Mag",".magnitude",names(final))
colnames(final) <- sub("Jerk",".jerk",names(final))
colnames(final) <- sub("Acc",".accelerometer",names(final))
colnames(final) <- sub("Gravity","gravity",names(final))
colnames(final) <- sub("Gyro",".gyroscope",names(final))

library(dplyr)
tidy_data <- final %>% group_by(activity,subject) %>% summarise_each(funs(mean))
write.table(tidy_data,file = '.../tidy_data.txt', row.name=FALSE)

#Remove temp variables
rm(list = c('final','x','x1','x3','acti','activity','feact','y','subject','subject1','subject2'))
