# Code Book
This document serves as the code book detailing the steps taken to transform and clean the datasets provided. 
Additionally, a section detailing the naming conventions and description of the variables is included as well.

---

## Transformation & Cleaning Process
### 1) Merging Training and Test Sets to Create One Data Set

First, our libraries are loaded in and the data is read into our RStudio environment using the ```read.table()``` function. Each table is loaded into its own dataframe with the same name as its corresponding 
plain-text file name. For this assignment we are only concerned with the **subject**, **x**, and **y** tables of both the _test_ and _train_ sets (6 tables total).

###### _Loading in packages + data_
```
library(tidyverse)
library(magrittr)

setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset/test")
subject_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset/train")
subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

```
Now that our tables are loaded in, we will begin to start the process of merging them all together (we are actually moreso column-binding and row-binding rather than merging). 

Before we do that, we will first standardize and rename the **subject** and **y** table column names for both sets. Since there are no column names/header for the original datasets, R will 
automatically give them placeholder names (V1, V2, V3, ...) by default. 

Since we will be column binding the tables together, there would otherwise be multiple "V1" columns between the tables, so this step 
is taken to negate any confusion from the get go.

###### _Renaming column names for the subject and labels (y) tables_
```
subject_test %<>% rename(SubjectID = V1)
y_test %<>% rename(Activity = V1)

subject_train %<>% rename(SubjectID = V1)
y_train %<>% rename(Activity = V1)
```
Now, our tables are ready to be merged. First, all of the _test_ tables get column-binded into one, aggregate _test_ dataframe (```test_df```). Likewise, the all of the _train_ tables also get column-binded into its 
own aggregated _train_ dataframe (```train_df```). Finally, ```train_df``` and ```test_df``` get row-binded, resulting in one final dataframe of all of the relevant data named ```data```. 

Additionally, I also clear the environment of every other table not in use to free up some memory.

###### _Column-binding and row-binding all tables together_
```
test_df <- cbind(subject_test, y_test, x_test)
train_df <- cbind(subject_train, y_train, x_train)
data <- rbind(train_df, test_df)
rm(test_df, train_df, subject_train, subject_test, x_test, x_train, y_test, y_train)
```

### 2) Extracting Only the Mean and Standard Deviation Measurements for Each Variable
As it currently stands, the new ```data``` table is a dataframe composed of 10299 observations and 563 variables. The first column is represented by the SubjectID, the second by the Activity, and the remaining columns
are the 561-feature vector composed of time and frequency domain variables. Of these 561 columns, only some of them show "mean()" and "std()" measurements of certain variables. This step of the assignment requires 
us to narrow down the amount of variables/columns to only those who represent a mean or standard deviation value.

By looking at the _features.txt_ file provided in the original dataset folder, we are able to see every column name of the 561-feature vector. From there, I noted which ones end in "...mean()" or "...std()" and
selected each column by column number. This now leaves us with 68 total variables in data set.

###### _Extracting only the relevant columns that have mean and standard deviation measurements_
```
data %<>% select(SubjectID, Activity, V1:V6, V41:V46, V81:V86, V121:V126, 
                 V161:V166, V201, V202, V214, V215, V227, V228, V240, V241,
                 V253, V254, V266:V271, V345:V350, V424:V429, V503, V504, 
                 V516, V517, V529, V530, V542, V543)
```

### 3) Using Descriptive Activity Names to Name the Activities in the Data Set
Up until this point, the Activities column contains numeric values ranging from 1 to 6, each describing the different activities performed by the subject. From looking at the _activity_labels.txt_ file provided
in the original dataset folder, we are able to see which numeric values correspond to each activity. From there, we can use the ```mutate()``` function along with the ```case_when()``` function to change these values in 
the data set.

###### _Replacing numeric activity labels with their corresponding qualitative descriptions_
```
data %<>% mutate(Activity = case_when(Activity == 1 ~ "Walking",
                                      Activity == 2 ~ "Walking Upstairs",
                                      Activity == 3 ~ "Walking Downstairs",
                                      Activity == 4 ~ "Sitting",
                                      Activity == 5 ~ "Standing",
                                      Activity == 6 ~ "Laying"))
```

### 4) Appropriately Labeling the Data Set with Descriptive Variable Names
Since the column names of the 561-feature vector are still default at this point (V1, V2, V3, etc.), we will now seek to populate the column names with their correct descriptive variable names found in the _features.txt_ file.
This time, we will actually load in this features.txt file into its own dataframe, ```features```. From there, we will then select the names of the same relevant columns from Step 2 and save it to a vector named
```variable_names```.

###### _Reading in the "features.txt" file to save all the variable names to a vector_
```
setwd("~/Desktop/Data/Data Science Specialization Course/Getting and Cleaning Data Course/Week 4 Project Assignment/UCI HAR Dataset")
features <- read.table("features.txt")
variable_names <- features[c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,
                             241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543), 2]
```

We now have a vector of all of the corresponding variable names for the exact columns that we are working with in the ```data``` data set. 

These names, however, are not entirely tidy and contain several ambiguities and special characters (ex: "tBodyAcc-mean()-X"). 
To fix this, we will clean the variable names using ```str_replace()``` and regular expressions. Specifically, we will be: replacing the "t" prefixes with "Time", replacing the "f" prefixes with "Freq", replacing
"mean()" with "Mean" and "std()" with "Std", and removing all dashes.

###### _Cleaning and appropriately naming variable names_
```
variable_names %<>% str_replace(pattern = "^t", replacement = "Time") %>%
                    str_replace(pattern = "^f", replacement = "Freq") %>%
                    str_replace(pattern = "mean\\(\\)", replacement = "Mean") %>%
                    str_replace(pattern = "std\\(\\)", replacement = "Std") %>%
                    str_replace_all(pattern = "\\-", replacement = "")
```

Now that our ```variable_names``` vector has the final version of all the column names, we can use it to rename the original columns in our ```data``` dataset.

###### _Replacing default variable names with corresponding descriptive variable names_
```
colnames(data) <- c("SubjectID", "Activity", variable_names)
```

As a final (optional) step to leave the data in its most organized and tidy form, we will sort the dataset by SubjectID and Activity.

###### _Sorting by SubjectID and Activity_
```
data %<>% arrange(SubjectID, Activity)
```
Done! Our dataset is now cleaned and tidy, ready for any potential downstream analysis that someone may want to use it for.

### 5) (From the Data Set in Step 4) Creating a Second, Independent Tidy Data Set With the Average of Each Variable for Each Activity and Each Subject
The final step is fairly self explanatory from reading the title. We can accomplish this by grouping by SubjectID and Activity and using ```summarise_all()``` in order to apply a function (in this case the mean) across all
of the columns. We will assign this new resulting dataframe to an object named ```averages```. The final product is a dataframe made up of 180 observations and 68 variables.

###### _Creating the final ```averages``` data set_
```
averages <- data %>% group_by(SubjectID, Activity) %>% summarise_all(mean)
```

---

## Variable Descriptions & Naming Convention/Schema
The following is to clarify what each variable is supposed to represent by its given properties and/or naming schema. Note that this will be pertaining to the cleaned and final data 
set from Step 4, _not_ the uncleaned form of the data set originally provided to us for this assignment (although the definitions are fundamentally the same).

### SubjectID:
Integers ranging from 1-30, each representing the unique identifier of each subject. Each number represents a different person/subject.
### Activity:
Qualitative character strings denoting which physical activity is being performed. 

The values can take on: 
- Laying 
- Sitting
- Standing
- Walking 
- Walking Downstairs
- Walking Upstairs
### Columns 3-68 Naming Convention
The remaining columns are all quantitative variables consisting of doubles that are normalized and bounded from -1 to 1 in standard gravity units "g". 

Since there are too many variables to individually list and describe here, I will instead state what each "section"/prefix/suffix refers to in the context of this data set.

**Time:** Denotes time domain signals

**Freq:** Denotes frequency domain signals produced from a Fast Fourier Transform (FFT)

**Body:** Denotes body signals 

**Gravity:** Denotes gravity signals 

**Gyro:** Denotes gyroscope readings

**Acc:** Denotes accelerometer readings

**Jerk:** Denotes "Jerk" signals derived from body linear acceleration and angular velocity measurements

**Mag:** Denotes the magnitude of the signals, calculated using the Euclidean norm

**Mean:** Denotes a mean value

**Std:** Denotes a standard deviation value

**X:** Denotes 3-axial signals in the X direction

**Y:** Denotes 3-axial signals in the Y direction

**Z:** Denotes 3-axial signals in the Z direction








