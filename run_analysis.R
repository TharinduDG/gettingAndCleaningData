# Clean up workspace
rm(list=ls())

#set working directory
setwd("C:\\Users\\tharindu\\Documents\\R_Workspace\\R_data\\coursera\\UCI HAR Dataset")


# Load activity labels and features
activityLabels = read.table("./activity_labels.txt")
activityLabels[,2] = as.character(activityLabels[,2])
features = read.table("./features.txt")

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
wantedFeatures = grep(".*mean.*|.*std.*", as.character(features[,2]))
wantedFeatures.names = features[wantedFeatures,2]
wantedFeatures.names = gsub('-mean', 'Mean', wantedFeatures.names)
wantedFeatures.names = gsub('-std', 'Std', wantedFeatures.names)
wantedFeatures.names = gsub('[-()]', '', wantedFeatures.names)
wantedFeatures.names = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude", wantedFeatures.names)
wantedFeatures.names = gsub("JerkMag","JerkMagnitude", wantedFeatures.names)
wantedFeatures.names = gsub("GyroMag","GyroMagnitude", wantedFeatures.names)

# 2. Loading train data and Extractint only the measurements on the 
# mean and standard deviation for each measurement.
train = read.table("./train/X_train.txt")[wantedFeatures]
trainActivities = read.table("./train/Y_train.txt")
trainSubjects = read.table("./train/subject_train.txt")
train = cbind(trainSubjects, trainActivities, train)

# 2. Loading test data and Extractint only the measurements on the 
# mean and standard deviation for each measurement.
test = read.table("./test/X_test.txt")[wantedFeatures]
testActivities = read.table("./test/Y_test.txt")
testSubjects = read.table("./test/subject_test.txt")
test = cbind(testSubjects, testActivities, test)

# 1. Merges the training and the test sets to create one data set
finalData = rbind(train, test)
colnames( finalData) = c("subject", "activity", wantedFeatures.names)

# turn activities & subjects into factors
finalData$activity = factor( finalData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
finalData$subject = as.factor( finalData$subject)

library(reshape2)

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject
subAndActWise = melt( finalData, id = c("subject", "activity"))
subAndActWiseMeans = dcast( subAndActWise, subject + activity ~ variable, mean)

write.table( subAndActWiseMeans, "./subjectAndActivityWiseMeans.txt", row.names = FALSE, quote = FALSE, sep = '\t')