#Getting and Cleaning Data: Course Project:
#Part 1.
#Make sure the run_analysis.R script is in the same directory as UCI HAR Dataset
# read in the test and training set data 
train_data=read.table("UCI HAR Dataset/train//X_train.txt")
train_subject=read.table("UCI HAR Dataset//train/subject_train.txt",col.names="Subject")
train_label=read.table("UCI HAR Dataset//train/y_train.txt",col.names="Labels")
#combining training data:
train_data_ALL=cbind(train_data,train_subject,train_label)

#reading in the test sets
test_data=read.table("UCI HAR Dataset/test//X_test.txt")
test_subject=read.table("UCI HAR Dataset//test/subject_test.txt",col.names="Subject")
test_label=read.table("UCI HAR Dataset//test/y_test.txt",col.names="Labels")
#combining the test data
test_data_ALL=cbind(test_data,test_subject,test_label)
#combining the test and training data
complete_dataset= rbind(train_data_ALL,test_data_ALL)

##Part2 
#read in the features.txt file to get all the feature names:
features=read.table("UCI HAR Dataset/features.txt")
#V2 is the column with the actual names; run grep with pattern="mean" and "std" on it.
mean_cols=grep("mean()",features$V2)
std_cols=grep("std()",features$V2)
#list of all the columns I want to subset out, including the activity labels and the subject ID
mean_std_list=c(mean_cols,std_cols)
#Extracts/subset only the measurements on the mean and standard deviation for each measurement. 
new_data=complete_dataset[,mean_std_list]

#Part4
#convert the default column names("V1","V2" etc) to the names provided in the features.txt file
colnames(new_data)=features$V2[mean_std_list]
# remove the "()" symbol from the column names.
colnames(new_data)=sapply(colnames(new_data),function(X){gsub("\\()","",X)})
#convert all the time domain signal names which are prefixed with a "t" to be prefixed with "time_" and 
#frequency domain signal names which are prefixed with "f", to be prefixed with "freq_".
colnames(new_data)=sapply(colnames(new_data),function(X){gsub("^t","time_",X) })
colnames(new_data)=sapply(colnames(new_data),function(X){gsub("^f","freq_",X) })

#Part3
#adding in the Subject Id and Labels column from the original data to the new_data.
updated_data=cbind(new_data,complete_dataset$Labels,complete_dataset$Subject)
colnames(updated_data)=c(colnames(new_data),"Labels","Subject_Id")
#adding activity labels:
relabel1=function(X){gsub("1","WALKING",X)}
relabel2=function(X){gsub("2","WALKING_UPSTAIRS",X)}
relabel3=function(X){gsub("3","WALKING_DOWNSTAIRS",X)}
relabel4=function(X){gsub("4","SITTING",X)}
relabel5=function(X){gsub("5","STANDING",X)}
relabel6=function(X){gsub("6","LAYING",X)}
updated_data$Labels=sapply(updated_data$Labels,relabel1)
updated_data$Labels=sapply(updated_data$Labels,relabel2)
updated_data$Labels=sapply(updated_data$Labels,relabel3)
updated_data$Labels=sapply(updated_data$Labels,relabel4)
updated_data$Labels=sapply(updated_data$Labels,relabel5)
updated_data$Labels=sapply(updated_data$Labels,relabel6)

#Part5
#First calculate the average for variable,grouped by activity label and subject_Id.
#We use the reshape package to do that.
library("reshape2")
updated_data_melt=melt(updated_data,id=c("Subject_Id","Labels"))
tidy_data=dcast(updated_data_melt,Subject_Id+Labels~variable,mean)
#rename the variables so they reflect the fatc that they are averages:
colnames(tidy_data)=sapply(colnames(tidy_data),function(X){gsub("^","Avg_of_",X)})
#write it to a table
write.table(tidy_data,"UCI_HAR_tidydata.txt",sep="\t")