require(plyr);
args <- commandArgs();

inputDir <- args[1];

# Step 1 - Read date frames assuming "UCI HAR Dataset" folder is in the working directory

xTest <- read.table(paste(inputDir,"/test/X_test.txt", sep=""), stringsAsFactors=FALSE);
yTest <- read.table(paste(inputDir,"/test/Y_test.txt", sep=""), stringsAsFactors=FALSE);
xTrain <- read.table(paste(inputDir,"/train/X_train.txt", sep=""), stringsAsFactors=FALSE);
yTrain <- read.table(paste(inputDir,"/train/Y_train.txt", sep=""), stringsAsFactors=FALSE);
subjectTest <- read.table(paste(inputDir,"/test/subject_test.txt", sep=""), stringsAsFactors=FALSE);
subjectTrain <- read.table(paste(inputDir,"/train/subject_train.txt", sep=""), stringsAsFactors=FALSE);
features <- read.table(paste(inputDir,"/features.txt", sep=""), stringsAsFactors=FALSE);
activityLabels <- read.table(paste(inputDir,"/activity_labels.txt", sep=""));

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



