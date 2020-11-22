## Getting and Cleaning Data Course Project


## downloading data from web

webDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( webDataUrl, destfile = "webData.zip" )
unzip("webData.zip")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #V2 contains label
features <- read.table("./UCI HAR Dataset/features.txt")  

## Merges the training and the test sets to create one data set.
## merging {train, test}

## test and train data

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## final stage 

test  <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)

fullSet <- rbind(test, train)

## Extracts only the measurements on the mean and standard deviation for each measurement.
## reading table

allNames <- c("subject", "activity", as.character(features$V2))
meanStdColumns <- grep("subject|activity|[Mm]ean|std", allNames, value = FALSE)
reducedSet <- fullSet[ ,meanStdColumns]

names(activity_labels) <- c("activityNumber", "activityName")
reducedSet$V1.1 <- activity_labels$activityName[reducedSet$V1.1]

## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.

reducedNames <- allNames[meanStdColumns]
reducedNames <- gsub("mean", "Mean", reducedNames)
reducedNames <- gsub("std", "Std", reducedNames)
reducedNames <- gsub("gravity", "Gravity", reducedNames)
reducedNames <- gsub("[[:punct:]]", "", reducedNames)
reducedNames <- gsub("^t", "time", reducedNames)
reducedNames <- gsub("^f", "frequency", reducedNames)
reducedNames <- gsub("^anglet", "angleTime", reducedNames)
names(reducedSet) <- reducedNames

## Creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject.
## creating new tidy data

library(plyr)

webData2 <- aggregate(. ~subject + activity, reducedSet, mean)
webData2 <- webData2[order(webData2$subject, webData2$activity), ]
write.table(webData2, file = "tidydata.txt",row.name=FALSE)
