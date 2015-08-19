# Hugo Rebolledo
# Getting and Cleaning Data
# Course Project

# Working Directory must be set to the "UCI HAR Dataset" folder before running this script

require(reshape2) 
require(plyr)       

# Check the existence of all files required. 
CheckFiles <- function() {
    filesOK <- TRUE
    if (!file.exists("./train/X_train.txt")) {
        print ("File train/X_train.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./train/y_train.txt")) {
        print ("File train/y_train.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./train/subject_train.txt")) {
        print ("File train/subject_train.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./test/X_test.txt")) {
        print ("File test/X_test.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./test/y_test.txt")) {
        print ("File test/y_test.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./test/subject_test.txt")) {
        print ("File test/subject_test.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("features.txt")) {
        print ("File features.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("./train/X_train.txt")) {
        print ("File train/X_train.txt doesn´t exists"); filesOK <- FALSE
    }
    if (!file.exists("activity_labels.txt")) {
        print ("File activity_labels.txt doesn´t exists"); filesOK <- FALSE
    }
    filesOK
}

# This function does the actual reading, merging and selecting columns from the dataset
MergeData <- function() {
    # Loading TRAIN data: measurements(X_train) + activity labels (y_train) + subject (subject_train)
    trainData<-read.table("./train/X_train.txt")
    trainData<-cbind(trainData,read.table("./train/y_train.txt"))
    trainData<-cbind(trainData,read.table("./train/subject_train.txt"))

    # loading TEST data: same as TRAIN
    testData<-read.table("./test/X_test.txt")
    testData<-cbind(testData,read.table("./test/y_test.txt"))
    testData<-cbind(testData,read.table("./test/subject_test.txt"))
    
    # Merging both sets
    fullData <- rbind(trainData, testData)

    # Reading "features.txt" to set the column names of the data set
    features = read.table("features.txt", colClasses = c("character"))
    columnNames <- c(features$V2, "ActivityLabel", "Subject")
    colnames(fullData) <- columnNames
    
    # Adding Activity column based on the Activity Label (human readable)
    actNames = read.table("activity_labels.txt")
    fullData$Activity <- actNames[fullData$ActivityLabel,]$V2
    
    # Filter mean and std columns + activity and subject
    # It will not select angle(...)
    filteredCols <- grep("mean|std|^Activity$|^Subject$",names(fullData))
    fullData <- fullData[, filteredCols]
}

# This function produce "clean" column names, and corrects a typo (fBodyBody...)
tidyNames <- function(dt) {
    newNames <- names(dt)
    newNames <- gsub("fBodyBody", "fBody", newNames)    # The typo
    newNames <- gsub("^f", "freq.", newNames)
    newNames <- gsub("^t", "time.", newNames)
    newNames <- gsub("\\(\\)", "", newNames)
    newNames <- gsub("-", ".", newNames)
    newNames <- gsub("std", "StdDev", newNames)
    newNames <- gsub("mean", "Mean", newNames)
    newNames <- gsub("Acc", ".Acceleration", newNames)
    newNames <- gsub("Mag", ".Magnitude", newNames)
    newNames <- gsub("Gyro", ".AngularAccel", newNames)
    newNames <- gsub("Jerk", ".Jerk", newNames)
    newNames
}

# This function reshapes the data, either by using melt->dcast (library reshape2 required)
# or by using ddply (library plyr required)
Reshape <- function(x, method = "melt") {
    indx <- c("Subject", "Activity")
    if (method=="melt") {
        # I plan to use "melt", so I need index and variables vectors
        # Tricky: next line will retrieve all column names EXCEPT those in the index
        vars <- colnames(x[, !names(x) %in% indx] )
    
        # Now we can melt and dcast to reshape the data
        tidy <- dcast(melt(x, id=indx, measure.vars=vars), Subject + Activity ~ variable, mean)
    } else if (method=="plyr") {
        tidy <- ddply(x, indx, numcolwise(mean))
    } else { 
        tidy <- x   # do nothing
    } 
    tidy
}

#####################################################################################
#
#  Main Program
#
#####################################################################################
# Check the files
if (!CheckFiles()) {
    stop("Some files are missing. Maybe the working directory is not set to the \"UCI HAR Dataset\" folder.")
}

# Read, merge and select useful columns into myData
myData <- MergeData()

# Add meaningfulness to names
names(myData) <- tidyNames(myData)

# Reshape data
tidyData <- Reshape(myData, method="plyr")

# Finally, we write the results. To read them back use standard read.csv o read.table
write.csv(tidyData, "tidyData2.csv", row.names = FALSE)      # for Excel users like me
write.table(tidyData, "tidyData2.txt", row.names = FALSE)

