# Getting-and-Cleaning-Data-Course-Project
My submission for the "Getting and Cleaning Data" course project for the Data Science Specialization course offered by John Hopkins University.

## Background
This assignment was presented to students of the Data Science Specialization course as a challenge to work with large, messy plain text (.txt) files from accelerometers from Samsung Galaxy S smartphones recording physical activity movements (similar to devices like Fitbit or other types of "wearable computing"). Broadly speaking, the main goal of the assignment is for students to demonstrate their ability to retrieve, transform, and clean data into a tidy and workable format for downstream analysis. 

## The Data
The dataset and tables used have been sourced from the following publication:

> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

As per the source:
> "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

Additionally, for each record/row, we are provided with:
- An identifier of the subject who carried out the experiment
- The activity label
- Triaxial acceleration from the accelerometer and the estimated body acceleration
- Triaxial angular velocity from the gyroscope
- A 561-feature vector with time and frequency domain variables

## Instructions / Assignment Steps
To adequately complete the assignment, there are 5 main steps that students must complete.

As per the directions:

> "You should create one R script called run_analysis.R that does the following: 
> 1) Merges the training and the test sets to create one data set.
> 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3) Uses descriptive activity names to name the activities in the data set
> 4) Appropriately labels the data set with descriptive variable names. 
> 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

Furthermore, a repository containing the run_analysis.R script, this README file, and a code book is to be uploaded and submitted. 

Please refer to the code book for a more comprehensive look into the cleaning and transformation process of the data, along with descriptions of the variable names.
