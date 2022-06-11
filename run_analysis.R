
## One of the most exciting areas in all of data science right now is wearable computing - 
##see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing 
##to develop the most advanced algorithms to attract new users. 
##The data linked to from the course website represent data collected from 
##the accelerometers from the Samsung Galaxy S smartphone.
## A full description is available at the site where the data was obtained:



#  data for the project:

url <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 


library(tidyverse)



InertiaTest_List <- lapply(list.files(path = paste0(getwd(), "/UCI HAR Dataset/test/Inertial Signals"), 
                                      pattern = ".txt",
                                      full.names = TRUE), read.table)


file_names <- str_replace(list.files(path = paste0(getwd(), "/UCI HAR Dataset/test/Inertial Signals"), 
                                     pattern = ".txt"),
                          ".txt", "") 

names(InertiaTest_List ) <- file_names


Intertial_Test <- bind_rows(InertiaTest_List, .id = "column_label")

##################### Part 1: Merge the training and the test sets to create one data set

## Load Test files 

Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")

Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")



Test_Set <- bind_cols(list( Subject_test, Y_test, X_test))

names(Test_Set)[1:3] <- c("Subject", "Activity", "V1")
                   

## Load Training Files 


Subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_Train <- read.table("UCI HAR Dataset/train/X_train.txt")

Y_Train <- read.table("UCI HAR Dataset/train/y_train.txt")

Train_Set <- bind_cols(list( Subject_Train, Y_Train, X_Train))

names(Train_Set)[1:3] <- c("Subject", "Activity", "V1")



## Merge training and test sets 
Train_Test <- bind_rows(list(train = Train_Set, test = Test_Set), .id = "id")


##################### Part 2:Extracts only the measurements on the mean and standard deviation for each measurement. 



Train_Test_Mean <- Train_Test %>% summarise_at(vars(V1:V561), mean, na.rm = TRUE)
                                          

Train_Test_Stdev <- Train_Test %>% summarise_at(vars(V1:V561), sd, na.rm = TRUE)


##################### Part 3:Use descriptive activity names to name the activities in the data set

Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(Activity_Labels) <- c("Code", "Label")

Train_Test$Activity.str <- Activity_Labels$Label[match(Train_Test$Activity, Activity_Labels$Code)]


##################### Part 4:Appropriately labels the data set with descriptive variable names. 
library(tidyverse)

Features <- read.table("UCI HAR Dataset/features.txt")
names(Features) <- c("Code", "Label")

Features$Code <- paste0("V", Features$Code)

Features$Label <- vctrs::vec_as_names(Features$Label, repair = "unique")


Train_Test <- Train_Test %>% rename_at(vars(V1:V561), ~ Features$Label)



################Part 5:From the data set in step 4, 
##################### create a second, independent tidy data set 
##################### with the average of each variable for each activity and each subject.

Train_Test_GroupedMeans <- Train_Test %>% 
                                group_by(Subject, Activity) %>% 
                                summarise_at(vars(-id), mean, na.rm = TRUE)
