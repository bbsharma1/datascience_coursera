##################################################################################################################
## Install packages
install.packages("filesstrings")
##################################################################################################################

##################################################################################################################
## Load Packages
library(dplyr)
library(tidyverse)
library(reshape2)
library(filesstrings)
##################################################################################################################

##################################################################################################################
## Downloading the data, unzipping, and archiving
setwd("./3.GettingandCleanindData/Project/")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("Galaxy.zip") | !file.exists("./archive/Galaxy.zip"))
{
  download.file(fileUrl, destfile = "./Galaxy.zip",  method = "curl")
  unzip(zipfile = "Galaxy.zip")
  file.move("./Galaxy.zip", "./archive/")
  Galaxy_dw_time <- date()
} else {
  print("file found, not downloading")
}
##################################################################################################################

##################################################################################################################
## Read the Data 
    ## Info about each variables:
    ## Xtest: Test Set
    ## YTest: Test  lables

print("Reading Data")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE )
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE )
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE )

    ## XTrain: Training set
    ## Ytrain: Training Lables
    ## subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE )
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE )
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE )

    ## Links the class labels with their activity name
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE )

    ## 'features.txt': List of all features. (Where $V2 lists the names)
names_features <- read.table("UCI HAR Dataset/features.txt", head = FALSE, stringsAsFactors = FALSE )

print("Reading Data--DONE")
##################################################################################################################

##################################################################################################################
## Merges the training and the test sets to create one data set.

print("Merging Data")

    ## combine datasets into 1 column tables
    subjects <- rbind(subject_train, subject_test)
    activities  <- rbind(y_train, y_test)
    features <- rbind(x_train, x_test)

    names(subjects)  <- "subject"
    names(activities) <- "activities"
    names(features) <- names_features$V2
    
    ## Now we want to combine each of those 3 datasets into 1 data set
    all_data <- cbind(subjects, activities, features)
    
print("Merging Data--DONE")
    
#all_data
##################################################################################################################

##################################################################################################################
## Extracts only the measurements on the mean and standard deviation for each measurement.

print("Extracting Data")

    ## from features list (V2), we want to only find which names include: mean() or std()
    meanstd_data <- all_data
    #str(meanstd_data)

    ## Error is occuring becuase there are multiple columns with the same exact name. 
    ## This is an error with the dataset that wasnt checked,.
    tibble::enframe(names(meanstd_data)) %>% count(value) %>% filter(n > 1)
    
    extrmeansd <- grep("mean\\(\\)|std\\(\\)", names(meanstd_data))
    meanstd_data <- meanstd_data[, c(1,2,extrmeansd)]

print("Extracting Data--DONE")
##################################################################################################################

##################################################################################################################
## Uses descriptive activity names to name the activities in the data set

print("Editing Activity Names")

    ## Using activity_labels,'mutate' the values
    activity_names <- activity_labels$V2
    meanstd_data <- mutate(meanstd_data,activities = activity_names[activities])

print("Editing Activity Names--DONE")
##################################################################################################################

##################################################################################################################
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
print("Outputting New Data")

    final_by_group <- group_by(meanstd_data, subject, activities)
    final_by_group
    
    finale <- summarise_each(final_by_group, funs(mean), contains('mean()'),contains('std()'))
    
print("Outputfile is available!")
write.table(finale, "./FINAL_average_subjects.txt", row.names=FALSE)
##################################################################################################################