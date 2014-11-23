run_analysis.r does the following:
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement. 
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names. 
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

How it does so:
It uses the following libraries: reshape2 and data.table
It loads test and train data
It loads the features and activity labels
It extracts mean and standard deviation data
It processes and combines the data sets

The original data is obtained from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of the data can be obtained from: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data set includes the following files:
README.txt
features_info.txt: Description of variables used.
features.txt: List of features.
activity_labels.txt: Associates labels with respective activity.
train/X_train.txt: Training set.
train/y_train.txt: Training labels.
test/X_test.txt: Test set.
test/y_test.txt: Test labels.
train/subject_train.txt: Identifies 30 subjects. 
train/Inertial Signals/total_acc_x_train.txt: Smart phone data from accelerometer.
train/Inertial Signals/body_acc_x_train.txt: Net acceleration (subtract gravity from total).
train/Inertial Signals/body_gyro_x_train.txt: Angular velocity from gyroscope.

The smartphone collected data from an accelerometer and gyroscope related to the following six activities:
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING