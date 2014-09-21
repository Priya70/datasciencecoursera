Getting and Cleaning Data: Course Project Codebook
==================================================
 This is the Codebook accompanying the *run_analysis.R* script for the Course Project. The goal of the project was to take a raw dataset (taken from subjects who each performed six activities wearing a smartphone) consisting of a training set and a test set, and create a tidy dataset which included the average of each measurement that measured amean or standard deviation, grouped by SubjectId and Activity Label. The algorithm workflow is described in the accompaying Readme. The R code (*run_analysis.R*) can be run so long as it is the same directory containing the UCI HAR Dataset directory which contains the datafiles.
 
**About the Raw DataSet provided**     
  Data from 30 volunteers(subjects) who each performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist has been provided in two parts: Taining set and Test set. This includes a total of 561 features which were measured/caculated  as the subjects performed the activities, the identity of the subject, and the label of the activity.7352 records are provided as part of the Training Set, and 2947 records are part of the Test set.

**Raw Data details**
  The 561 features that make up this dataset are actual measurements (accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ) and derived quantities/measurements like body linear acceleration, angular velocity, Jerk signals etc for the following variables (as obtained from features_info.txt file)
  
**Signal Variables**  
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

Additional features obtained by averaging the signals in a signal window sample and used on the angle() variable:
gravityMean(XYZ)
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Furthermore, more statisical quantities like mean,entropy,standard deviation etc calculated and provided for each signal to make a total of 561 features/variables. Note that in the data, the variables that have been denoted above
with a suffix XYZ are actually 3 measurements in the X,Y and Z direction.  

**Data Analysis**

*Part 1* We read in the training sets using read.table and combine the subject identity and the and activity labels to the features dataset using cbind (train_data_ALL). Note that its is a good idea to specifically give the subject identity and activity label columns distinct column names before combining. 
Similarly we create the combined test set(test_data_ALL) using rbind. and then combine them both using rbind. This combined dataset is called "complete dataset" , and consists of 10299 rows and 563 columns  and is what is the deliverable for part 1.


*Part 2* We can extract the column names that belong to variables containing the mean and standard deviation for each measurement by reading in the features.txt file and then using the grep command on the feature names. I made a list of all the mean() and std() columns I want to subset out NOT including the Activity Label and Subject Id, called it *mean_std_list*, and subsetted those out. The new dataset with 79 variables and 10299 rows is called *new_data*.  I choose to NOT include the 7 features (gravityMean(XYZ),tBodyAccMean,tBodyAccJerkMean,tBodyGyroMean,tBodyGyroJerkMean) as they represent the averaged vectors obtained by averaging the signals in a signal window, but not means of a single signal/variable.

*Part 4* I chose to do part 4 (of the questions asked) first, as it made more logical sense to do that - which was name the columns of the *new_data* in a meaning way. The names of the features as provided in features.txt were quite reasonable and a good place to start. I extracted out the the names of the columns (we had pulled out in the last section) and renamed the columns of *new_data*. Using sapply, I could further clean up the names by removing extraneous characters like "()" and adding "time" and "freq" as the prefix to variables measuring signals in the time and frequency domain respectively.

*Part 3* I used cbind to combine the corresponding Subject Id and Labels columns from the *complete_data* to the *new_data*, and called the combined dataframe *updated_data*. Adding in the activity labels using the mapping provided in the UCI HAR Dataset/activity_labels.txt  
was done using sapply  and defining afunction map between activity no. and activity label.

*Part 5* To calculate the average for variable, grouped by activity Labels and Subject Id, used the reshape2 package and used the melt and dcast functions. Using melt, I converted the into narrow format using "Labels" and "Subject ID" as the the id variables, as those are the variable we evntually want to group by. The temporary narrow variable is called *updated_data_melt*. Then I recast it into wide format but summarizing by mean to create the final tidy data frame; which was then written out using write.table. 
```{r}
library("reshape2")
updated_data_melt=melt(updated_data,id=c("Subject_Id","Labels"))
tidy_data=dcast(updated_data_melt,Subject_Id+Labels~variable,mean)
```


