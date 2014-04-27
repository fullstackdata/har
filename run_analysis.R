require(plyr);

# Step 1 - Read date frames assuming "UCI HAR Dataset" folder is in the working directory

xTest <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors=FALSE);
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt", stringsAsFactors=FALSE);
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors=FALSE);
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt", stringsAsFactors=FALSE);
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=FALSE);
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors=FALSE);
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE);
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt");

# Step 2 - Merge data sets

#2.a Test
A <- cbind(yTest, subjectTest);
colnames(A) <- c("Activity", "Subject");
#2.b Train
B <- cbind(yTrain, subjectTrain)
colnames(B) <- c("Activity", "Subject")
#2.c Merge activity and subject columns of test and train data frames
C <- rbind(A,B);
#2.D Merge test and train
D <- rbind(xTrain, xTest);
#2.E Apply column names from features data frame
colnames(D) <- features$V2;

# Step 3 - Filter out irrelevant columns
# look for mean() and std() patterns in column names
E <- D[, c(grep("mean()", colnames(D), fixed=TRUE), grep("std()", colnames(D), fixed=TRUE))];

# Add activity and subject columns to the subset data frame
F <- cbind(C, E);

# Step 4 - Find the average of each variable for each activity and each subject 
Fmean <- ddply(F, .(Subject, Activity), numcolwise(mean));
colnames(activityLabels) <- c("Activity", "Activity_label");

# Step 5 - Merge Fmean and activityLabels to add the activity label to Fmean data set
final <- join(Fmean, activityLabels);


#Step 6 - Write the output to a text file called tidy.txt
write.table(final, file="tidy.txt", row.names=FALSE, quote=FALSE, col.names=names(final));




