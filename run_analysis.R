# Data Science Specialization Course: Getting and Cleaning Data: Week 4 Project Assignment
#By: Kenen Corea

#Loading Packages
library(tidyverse)
library(magrittr)

#Loading in each table into their own dataframes

#Loading in test sets
setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset/test")
subject_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

#Loading in training sets
setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset/train")
subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")


################################# STEP 1 #################################

#Renaming column names for test subject and test labels variables
subject_test %<>% rename(SubjectID = V1)
y_test %<>% rename(Activity = V1)

#Renaming column names for train subject and train labels variables
subject_train %<>% rename(SubjectID = V1)
y_train %<>% rename(Activity = V1)

#Column binding all 3 test tables into one dataframe
test_df <- cbind(subject_test, y_test, x_test)

#Column binding all 3 train tables into one dataframe
train_df <- cbind(subject_train, y_train, x_train)

#Row binding the test dataframe with the train dataframe into one complete dataframe
data <- rbind(train_df, test_df)

#Clearing all other tables from the environment (optional)
rm(test_df, train_df, subject_train, subject_test, x_test, x_train, y_test, y_train)


################################# STEP 2 #################################

#Extracting only the relevant columns that have mean and standard deviation measurements
data %<>% select(SubjectID, Activity, V1:V6, V41:V46, V81:V86, V121:V126, 
                 V161:V166, V201, V202, V214, V215, V227, V228, V240, V241,
                 V253, V254, V266:V271, V345:V350, V424:V429, V503, V504, 
                 V516, V517, V529, V530, V542, V543)


################################# STEP 3 #################################

#Replacing numeric activity labels with their corresponding qualitative descriptions
data %<>% mutate(Activity = case_when(Activity == 1 ~ "Walking",
                                      Activity == 2 ~ "Walking Upstairs",
                                      Activity == 3 ~ "Walking Downstairs",
                                      Activity == 4 ~ "Sitting",
                                      Activity == 5 ~ "Standing",
                                      Activity == 6 ~ "Laying"))


################################# STEP 4 #################################

#Reading in the "features.txt" file to save all the variable names to a vector
setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset")
features <- read.table("features.txt")
variable_names <- features[c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,
                             241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543), 2]

#Cleaning and appropriately naming variable names
variable_names %<>% str_replace(pattern = "^t", replacement = "Time") %>%
                str_replace(pattern = "^f", replacement = "Freq") %>%
                str_replace(pattern = "mean\\(\\)", replacement = "Mean") %>%
                str_replace(pattern = "std\\(\\)", replacement = "Std") %>%
                str_replace_all(pattern = "\\-", replacement = "")

#Replacing default variable names with corresponding descriptive variable names
colnames(data) <- c("SubjectID", "Activity", variable_names)

#As a final step to leave the data in the tidiest format, we will sort the table by SubjectID and Activity
data %<>% arrange(SubjectID, Activity)


################################# STEP 5 #################################

#Creating a second, independent tidy data set with the average of each variable for each activity and subject
averages <- data %>% group_by(SubjectID, Activity) %>% summarise_all(mean)

