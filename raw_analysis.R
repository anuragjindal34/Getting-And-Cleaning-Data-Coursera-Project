library(dplyr)
#Reading Test Data
X_test <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\test\\subject_test.txt")
#Reading Training Data
X_train <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\train\\y_train.txt")
subject_train <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\train\\subject_train.txt")
#Reading Features Data
features <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\features.txt", stringsAsFactors = FALSE)
#Reading Activities Data
activities <- read.table("C:\\Users\\Jai\\Documents\\UCI HAR Dataset\\activity_labels.txt")

#Step1: Merging Test & Training Data

#Merging Test Data
test <- cbind(subject_test, X_test, y_test)
#Merging Training Data
train <- cbind(subject_train,X_train,y_train)
#Human Activity Data
data <- rbind(test,train)
colnames(data) <- c("Subject", features[,2], "Activity")

#Step2 : Extracts only the measurements on the mean and standard deviation for each measurement.
f <- features[grepl("[sS][Tt][Dd]|[Mm][Ee][Aa][nN]", features$V2),]
data <- subset(data, select = c("Subject",f$V2, "Activity"))

#Step3 : Uses descriptive activity names to name the activities in the data set

data <- merge(data,activities, by.x = "Activity", by.y = "V1", all.x = TRUE)
data$Activity <- NULL
data <- rename(data, Activity = V2)

#Step4 : Appropriately labels the data set with descriptive variable names.

datacols <- colnames(data)
dataCols <- gsub("[\\(\\)-]", "", dataCols)
datacols <- gsub("^f", "frequencyDomain", datacols)
datacols <- gsub("^t", "timeDomain", datacols)
colnames(data) <- datacols


#Step 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data <- group_by(data,Subject, Activity, add = TRUE)
datameans <- summarise_all(data,funs(mean))
write.table(datameans,"tidy_data.txt",quote = FALSE,row.names = FALSE)





