
##  JHU on Coursera : Getting and Cleaning Data R project with the following requirements
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## DATA SOURCE: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 



library(data.table)

# 0.1 download and unzip the the file
# if MAC add method="CURL"

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
unzip("Dataset.zip")


# read the subject files
dtsubject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
dtsubject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))

#read the label/activity files
dty_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
dty_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))

# read the features file
features <- read.table("./UCI HAR Dataset/features.txt")

# 1.Merges the training and the test sets to create one data set.

dtX_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
dtX_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X <- rbind(dtX_test, dtX_train)


# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
tmpFeatures <- features[grep("(mean|std)\\(", features[,2]),]
tmpMeanSTD <- X[,tmpFeatures[,1]]


# 3.Uses descriptive activity names to name the activities in the data set
y <- rbind(dty_test, dty_train)

labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
for (i in 1:nrow(labels)) {
  code <- as.numeric(labels[i, 1])
  name <- as.character(labels[i, 2])
  y[y$activity == code, ] <- name
}


# 4.Appropriately labels the data set with descriptive variable names. 
tmp_X_labels <- cbind(y, X)
tmpMeanSTD_labels <- cbind(y, tmpMeanSTD)


# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
print("Creating tidy dataset as tidydt.txt...")

DSsubject <- rbind(dtsubject_test, dtsubject_train)
DSaverages <- aggregate(X, by = list(activity = y[,1], DSsubject = DSsubject[,1]), mean)

write.table(averages,file="tidydt.txt",sep=",",row.names = FALSE)

print("Done.")


