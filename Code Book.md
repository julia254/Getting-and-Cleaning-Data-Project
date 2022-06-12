
**run_analysis.R** script file is used to load and clean the UCI HAR Dataset per course instructions 


### Loading and Extracting the Dataset

Source: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

The data was downloaded from the link provided and loaded as a list of files into the project directory.

  Subject_Test = test/subject_test.txt  
  X_Test = test/X_test.txt  
  Y_Test = test/y_test.txt  
  
  Subject_Train = train/subject_train.txt  
  X_Train = train/X_train.txt  
  Y_Train = train/y_train.txt  
  
  Activity_Labels = activity_labels.txt  
  Features = features.txt  
  
  The columns were named using numeric variables; 
  features.txt dataset was used to provide the descriptive column name   
  
  The Y test and training data represent physical activities 
  they are given numeric variables, the activity_labels.txt dataset
  was used to provide the descriptive activity name     

  
### Part 1: Merging Training and Testing Data

Test_set = subject_test + X_test + Y_test (column bind)  
Train_set = Subject_Train + X_Train + Y_Train (column bind)  

Train_Test = Train_Set + Test_Set  (row bind)  



### Part 2: Replacing the numerically coded observations with character values 

The "activity_labels.txt" data set was used to replace the numeric variable as 
displayed in the "Activity column "with a character variable to provide 
a descriptive activity name 


### Part 3: Re-labeling Column names

The following strings in the column names have been updated for readability. 

  tBody = TimeBody  
  t = Time  
  f = Frequency  
  Acc = Accelerometer  
  Gyro = Gyroscope  
  Mag = Magnitude  
  BodyBody = Body  
  angle = Angle  
  gravity = Gravity  


### Part 4: Select columns that contain the Mean and Standard Deviations 

Extract columns that have strings "mean" or "std"


### Part 5: Creating the final data set: "Test_train_summary.txt"

Create the variable "Train_Test_GroupedMeans" by grouping and summarizing the Train_Test variable. 

Write the "Test_train_summary.txt" from the "Train_Test_GroupedMeans" variable.








