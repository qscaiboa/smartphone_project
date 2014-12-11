setwd("E:/R_learning/3_getdata_009/week3/UCI HAR Dataset")

list.files("test/inertial Signals")




#### get the colname for dataset
features <- read.table("features.txt")
colname <- features[,2]

#### read the train data and label the colnames
train_data <- read.table("train/X_train.txt")
colnames(train_data) <- colname

#### read the train data subject and label the colname as "Subject_ID"
train_subject_ID <- read.table("train/subject_train.txt")
colnames(train_subject_ID) <- "Subject_ID"


#### read the train data activity ID and label the colname as "Activity_ID"
train_activity_ID <- read.table("train/y_train.txt")
colnames(train_activity_ID) <- "Activity_ID"

#### Combine the train data with  subject id's, and activity id's 
train_data_with_ID <- cbind(train_subject_ID,train_activity_ID,train_data)
#head(train_data_with_ID)



#### read the test data and label the colnames
test_data <- read.table("test/X_test.txt")
colnames(test_data) <- colname

#### read the test data subject and label the colname as "Subject_ID"
test_subject_ID <- read.table("test/subject_test.txt")
colnames(test_subject_ID) <- "Subject_ID"

#### read the test data activity ID and label the colname as "Activity_ID"
test_activity_ID <- read.table("test/y_test.txt")
colnames(test_activity_ID) <- "Activity_ID"

#### Combine the test data with  subject id's, and activity id's 
test_data_with_ID <- cbind(test_subject_ID,test_activity_ID,test_data)
#head(test_set)

#### combine test data and train data, this is step 1 requiement
all_data_with_ID <- rbind(train_data_with_ID, test_data_with_ID)




#### 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_col_list <- grep("mean",names(all_data_with_ID),ignore.case=TRUE)
std_col_list <- grep("std",names(all_data_with_ID),ignore.case=TRUE)
mean_std_data_with_ID <-all_data_with_ID[,c(1,2,mean_col_list,std_col_list)]




#### 3 Uses descriptive activity names to name the activities in the data set
#### read the activity label
activity_labels <- read.table("./activity_labels.txt",col.names=c("Activity_ID","Activity_name"))

#### add new column for Activity_name 
all_data_with_ID_new <- cbind(all_data_with_ID[,1:2] ,all_data_with_ID[,2], all_data_with_ID[,3:563])
dim(all_data_with_ID_new)
##### remove NA row from data frame


dim(all_data_with_ID_new)

#### rename the Activity_name with descriptive activity names, by loop
i<-1 
for (i in 1:6){
  all_data_with_ID_new[,3] [all_data_with_ID_new$Activity_ID %in% as.character(c(i))] <- as.character(activity_labels$Activity_name[i])
i <- i+1
}

##### 4 Appropriately labels the data set with descriptive variable names.
colnames(all_data_with_ID_new)[3] <- "Activity_name"



#all_data_with_ID_new[55:58,1:4]

#### 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## tempory data only has colnames of all_data_with_ID
tem2 <- all_data_with_ID_new [0,]
# loop for subject_ID from 1 to 30 
i<- 1
for (i in 1:30){
  # loop for activity_ID from 1 to 6
  j <- 1 
  for( j in 1:6) {
     # get subset  with same subject ID and activity_ID 
     tem1 <- all_data_with_ID_new[all_data_with_ID_new$Subject_ID %in% as.character(c(i)) & all_data_with_ID_new$Activity_ID %in% as.character(c(j)),] 
     # remove subset data's NA
     tem1 <- tem1[complete.cases(tem1),]
     # get the average with same subject_ID and same activity_ID
     tem1[1, 4:564] <- sapply(tem1[,4:564],mean)
     tem2 <- rbind(tem2,tem1[1,])
     j <- j+1
    }
  
i <- i+1
}

smart_phone_tidy_data <- tem2

rownames(smart_phone_tidy_data) <- c(1:180)
# write tidy data to txt file
write.table(smart_phone_tidy_data, "smart_phone_tidy_data.txt" )
