
#Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

#Installation
    install.packages("data.table")  # from CRAN
    install.packages("dplyr")  # from CRAN
    library(data.table)
    library(dplyr)
#Download and set current workspace
    Download files from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    setwd("...\\UCI HAR Dataset")  # Change to your own directory
#Load labels, features and subjects
    #features
    feact <- fread("features.txt")
    feact  <- feact$V2
    #Labels
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
    #Subject data
    subject1 <- read.table(paste0(getwd(),"/test/subject_test.txt"))
    subject2 <- read.table(paste0(getwd(),"/train/subject_train.txt"))
    subject <- rbind(subject1, subject2)
    #Combine activity and subject data
    activity <- cbind(activity, subject)
    colnames(activity)  <- sub("V1","subject",names(activity))
#Load sensors data and combine
    #Combine data with feactures
    x <- read.table(paste0(getwd(),"/test/X_test.txt"))
    x1 <- read.table(paste0(getwd(),"/train/X_train.txt"))
    x3 <- rbind(x,x1)
    colnames(x3) <- feact
#Merge labels with sensors data 
    final <- cbind(activity,x3)
# Subset mean and std columns
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
#Create tidydata and write to txt  
    tidy_data <- final %>% group_by(activity,subject) %>% summarise_each(funs(mean))
    write.table(tidy_data,file = '.../tidy_data.txt', row.name=FALSE)
#Units
   The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in      fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#Remove temp variables
    rm(list = c('final','x','x1','x3','acti','activity','feact','y','subject','subject1','subject2'))
