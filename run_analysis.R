setwd("/scratch/lfs/qscai/R/R_learning/smartphone/UCI HAR Dataset")

#### get the colname for dataset
features <- read.table("features.txt")
colname <- features[,2]

#### read the train data and label the colnames
train_data <- read.table("train/X_train.txt")
colnames(train_data) <- colname

#### read the train data subject and label the colname as "Subject_ID"
train_subject_ID <- read.table("train/subject_train.txt")

#### read the train data activity ID and label the colname as "Activity_ID"
train_activity_ID <- read.table("train/y_train.txt")
                                                    
#### Combine the train data with  subject id's, and activity id's 
train_data_with_ID <- cbind(train_subject_ID,train_activity_ID,train_data)
head(train_data_with_ID)




#### read the test data and label the colnames
test_data <- read.table("test/X_test.txt")
colnames(test_data) <- colname

#### read the test data subject and label the colname as "Subject_ID"
test_subject_ID <- read.table("test/subject_test.txt")
 
#### read the test data activity ID and label the colname as "Activity_ID"
test_activity_ID <- read.table("test/y_test.txt")

#### Combine the test data with  subject id's, and activity id's 
test_data_with_ID <- cbind(test_subject_ID,test_activity_ID,test_data)
#head(test_data_with_ID)

#### combine test data and train data, this is step 1 requiement
all_data_with_ID <- rbind(train_data_with_ID, test_data_with_ID)

#head(all_data_with_ID)
#dim(train_data_with_ID)
#dim(test_data_with_ID)
#dim(all_data_with_ID)


#### 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_col_list <- grep("mean",names(all_data_with_ID),ignore.case=TRUE)
std_col_list <- grep("std",names(all_data_with_ID),ignore.case=TRUE)
mean_std_data_with_ID <-all_data_with_ID[,c(1,2,mean_col_list,std_col_list)]


#### 4 Appropriately labels the data set with descriptive variable names
colnames(mean_std_data_with_ID)[1] <- "Subject_ID"
colnames(mean_std_data_with_ID)[2] <- "Activity_ID"


## Read all activities and their names and label the aproppriate columns 
activity_labels <- read.table("activity_labels.txt",col.names=c("Activity_ID","Activity_NAME"))
    
#### 3 Merge the activities datase with the mean/std values datase to get one dataset with descriptive activity names
mean_std_data_descrnames <- merge(activity_labels, mean_std_data_with_ID, by.x="Activity_ID", by.y="Activity_ID",all=TRUE)
 


#### 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

#Melt the dataset with the descriptive activity names 
data_melt <- melt(mean_std_data_descrnames ,id=c("Activity_ID", "Activity_NAME", "Subject_ID"))
dim(data_melt )
data_melt[1:10,1:10]

##Cast the melted dataset according to  the mean of each variable for each activity and each subject 
smart_phone_tidy_data <- dcast(data_melt,  Subject_ID +Activity_ID + Activity_NAME  ~ variable, mean)
head(smart_phone_tidy_data)

write.table(smart_phone_tidy_data, "smart_phone_tidy_data.txt",  row.name=FALSE )












