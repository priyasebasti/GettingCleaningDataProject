# Load Features (X) from Test and Train datasets
X_Test<- read.table("UCI HAR Dataset/test/X_test.txt")
X_Train<- read.table("UCI HAR Dataset/train/X_train.txt")

# Load Activity (Y) from Test and Train datasets
Y_Test<- read.table("UCI HAR Dataset/test/Y_test.txt")
Y_Train<- read.table("UCI HAR Dataset/train/Y_train.txt")

# Load Subjects from Test and Train datasets
Subject_Test<- read.table("UCI HAR Dataset/test/subject_test.txt")
Subject_Train<- read.table("UCI HAR Dataset/train/subject_train.txt")

# Combine the test and train datasets individually for X,Y, Subject
X<-rbind(X_Train,X_Test)
Y<-rbind(Y_Train,Y_Test)
Subject<-rbind(Subject_Train,Subject_Test)

# Load feature names 
features<- read.table("UCI HAR Dataset/features.txt")
feature_names<-as.character(features[,2])

# Edit the names of the features to make them meaningful
feature_names<-gsub("-","_",feature_names)
feature_names<-gsub("^t","Time_Domain_",feature_names)
feature_names<-gsub("^f","Freq_Domain_",feature_names)
feature_names<-gsub("Acc","_Accelerometer",feature_names)
feature_names<-gsub("[(][)]","",feature_names)
feature_names<-gsub("Gyro","_Gyroscope",feature_names)
feature_names<-gsub("Mag","_Magnitude",feature_names)
# We only need the mean and standard deviation
feature_names<-gsub("mean","Mean",feature_names)
feature_names<-gsub("std","StdDev",feature_names)
mean_sd_colnums <- grep('Mean|StdDev', feature_names)

# Create a combined (Subject, Activity(Y), Feature(X))  dataset
Merged_DS<-cbind(Subject,Y,X)

# Add column names
names(Merged_DS)<-c('Subject','Activity',feature_names)

# Replace activity labels with activity names
activity_labels<- read.table("UCI HAR Dataset/activity_labels.txt")
Merged_DS$Activity<-activity_labels[Merged_DS$Activity,2]

# Create the a merged dataset with only the mean and SD columns
MeanSD_Dataset<- Merged_DS[,c(1,2,mean_sd_colnums+2)]

# Create the tidy dataset with the average of each variable for each activity and each subject.
Tidy_Dataset <- aggregate(MeanSD_Dataset[,3:88], by = list(Activity = MeanSD_Dataset$Activity, Subject = MeanSD_Dataset$Subject),FUN = mean)
write.table(x = Tidy_Dataset, file = "Tidy_Dataset.txt", row.names = FALSE)

