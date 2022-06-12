
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

Subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

X_Test <- read.table("UCI HAR Dataset/test/X_test.txt")

Y_Test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")



## Load Training Files 

Subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

X_Train <- read.table("UCI HAR Dataset/train/X_train.txt")

Y_Train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")



## Label the column names to display the feature it represents 


Features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Code", "Label"))


names(X_Train)<- Features[,2]
names(X_Test)<- Features[,2]


## Merge training and test sets 

Test_Set <- cbind(Subject_Test, Y_Test, X_Test)
Train_Set <- cbind(Subject_Train, Y_Train, X_Train)

Train_Test <- rbind(Train_Set, Test_Set)



##################### Part 2:Use descriptive activity names to name the activities in the data set

Activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Label"))


for(i in Activity_Labels$Code){
  Train_Test$Activity <- replace(Train_Test$Activity,Train_Test$Activity==i,
                                 Activity_Labels$Label[Activity_Labels$Code==i])

    }

##################### Part 3: Tidy the column names 

##Appropriately labels the data set with descriptive variable names.

Features2 <- str_extract(Features$Label, "[^-]+")
Features2_Unique <-unique(Features2)
Features2_Unique 

#23 unique variations of the characters before the dash

names(Train_Test) <- str_replace(names(Train_Test),"tBody","TimeBody")   
names(Train_Test) <- str_replace(names(Train_Test),"Acc","Accelerometer") 
names(Train_Test) <- str_replace(names(Train_Test),"Gyro","Gyroscope") 
names(Train_Test) <- str_replace(names(Train_Test),"tGravity","TimeGravity")  
names(Train_Test) <- str_replace(names(Train_Test),"Mag","Magnitude") 
names(Train_Test) <- str_replace(names(Train_Test),"^f","Frequency")  
names(Train_Test) <- str_replace(names(Train_Test),"BodyBody","Body") 
names(Train_Test) <- str_replace(names(Train_Test),"angle","Angle")  
names(Train_Test) <- str_replace(names(Train_Test),"gravity","Gravity") 



##################### Part 4:Extract only the measurements on the mean and standard deviation for each measurement. 


Measurement_Summary <- Train_Test %>% pivot_longer(cols = V1:V561,
                                                 names_to = "Variable", 
                                                 values_to = "Measurement") %>% 
                                    group_by(Variable) %>% 
                                    summarise(mean = mean(Measurement), 
                                               sd = sd(Measurement))

################Part 5:From the data set in step 4, 
##################### create a second, independent tidy data set 
##################### with the average of each variable for each activity and each subject.

Train_Test_GroupedMeans <- Train_Test %>% 
                                group_by(Subject, Activity) %>% 
                                summarise_at(vars(-id), mean, na.rm = TRUE)


write.table(Train_Test_GroupedMeans, file = Train_Test_Summary.txt)
