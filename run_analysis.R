# Read activity_labels.txt
activity <- read.delim("activity_labels.txt", header = FALSE, sep = " ")
# assign column names
names(activity) <- c("activity_id", "activity_name")

#Read features.txt and assign column names to them
features <- read.delim("features.txt", header = FALSE, sep = " ")
names(features) <- c("feature_id", "feature_name")
# Read the subject_train_data
subject_train <- read.delim("train/subject_train.txt", header = FALSE, sep = "")
## Read the subject_test data
subject_test <- read.delim("test/subject_test.txt", header = FALSE, sep = "")
## Merge the subject_data
subject <- rbind(subject_train,subject_test)

#Assign a column name for the subject data
names(subject) <- c("subject_id")

#Read the x_train data
x_train <- read.delim("train/x_train.txt", header = FALSE, sep = "")
#Read x_test data
x_test <- read.delim("test/x_test.txt", header = FALSE, sep = "")
# Merge x data
x <- rbind(x_train,x_test)

#Assign the column names for x_train data using feature names
names(x) <- features$feature_name

# Read y-train data
y_train <- read.delim("train/y_train.txt", header = FALSE, sep = "")
# Read y-test data
y_test <- read.delim("test/y_test.txt", header = FALSE, sep = "")
# Merge Y Data
y <- rbind(y_train, y_test)
#Name the column as activity_id as this represents the 6 different activities
names(y) <- c("activity_id")

#2.only extracts the measurements of the mean and standard deviation for each measurement
#subset of features that are only the mean and std of the observations
features_mean_std <- grep("(.mean\\(\\).)|(.std\\(\\).)|(.mean\\(\\))|(.std\\(\\))",features$feature_name, value = TRUE)

x_mean_std <- x[features_mean_std]

# Create full table
tbl_train_test <- c(subject,y,x_mean_std)

#3.Uses descriptive activity names to name the activities in the data set
#join with activity vector to get activity name
library(dplyr)
tbl_act_name <- merge(tbl_df(tbl_train_test),activity)
#Re-order columns 
tbl_final <- select(tbl_act_name,subject_id,activity_name,everything(), -activity_id)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
by_sub_act <- group_by(tbl_final,subject_id,activity_name)
tbl_summ_final <- summarise_all(by_sub_act,mean)
