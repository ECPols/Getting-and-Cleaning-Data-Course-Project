# get the library we need
library(dplyr)

filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

# if the file doesn't exist, download and unzip it
if (!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}

# if the folder doesn't exist, create the folder by unzipping the file
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

#assigning all data frames and give name to columns
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

# Merges the training and the test sets to create one data set.
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Dataset <- cbind(Subject, Y, X)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
Tidy <- Merged_Dataset %>% select(subject, code, contains("std"), contains("mean"))

# Uses descriptive activity names to name the activities in the data set
Tidy$code <- activities[Tidy$code, 2]

# Appropriately labels the data set with descriptive variable names. 
names(Tidy)[2] = "activity"
names(Tidy)<-gsub("^t", "Time", names(Tidy))
names(Tidy)<-gsub("Acc", "Acceleration", names(Tidy))
names(Tidy)<-gsub("Mag", "Magnitude", names(Tidy))
names(Tidy)<-gsub("BodyBody", "Body", names(Tidy))
names(Tidy)<-gsub("tBody", "TimeBody", names(Tidy))
names(Tidy)<-gsub("freq", "Frequency", names(Tidy))
names(Tidy)<-gsub("^f", "Frequency", names(Tidy))
names(Tidy)<-gsub("gravity", "Gravity", names(Tidy))
names(Tidy)<-gsub("angle", "Angle", names(Tidy))
names(Tidy)<-gsub("\\.", "", names(Tidy))
names(Tidy)<-gsub("mean", "Mean.", names(Tidy))
names(Tidy)<-gsub("std", "STD.", names(Tidy))
names(Tidy)<-gsub("\\.$", "", names(Tidy))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData <- Tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(TidyData, "TidyData.txt", row.name=FALSE)

