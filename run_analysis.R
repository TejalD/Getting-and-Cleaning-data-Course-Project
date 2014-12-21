#********************************
#Name : Tejal Dasnurkar
#Course: Getting and Cleaning data
#R- Version: R version 3.1.2
#********************************
  
#*****************
#**** PART 1 - Reading from Test and Train datasets
#*****************

#Reads the subject test file
ds.subject_test<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/test/subject_test.txt") 

#Reads the subject train file
ds.subject_train<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/train/subject_train.txt") 

# Merges the subject test and train files into one data frame ds.subject
ds.subject<-rbind(ds.subject_test,ds.subject_train) 

# I have covered PART 2 here where I am renaming the variables from V1,V2 to something meanigful as it
# is easier later to subset based on column names
names(ds.subject)[names(ds.subject)=="V1"] <- "Subject" 

#Reads the subject X test file
ds.X_test<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/test/X_test.txt")

#Reads the X train file
ds.X_train<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/train/X_train.txt")

# Merges the X test and train files into one data frame ds.X
ds.X<-rbind(ds.X_test,ds.X_train)

# I have covered PART 2 here where I am renaming the variables from V1,V2 to names extracted from the feature.txt file
# as it is easier later to subset based on column names
features<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/features.txt")

# Converts to vector col_headings
col_headings<-c(features)

# Associates feature names from variable V2 to columns of ds.X
names(ds.X)<-col_headings$V2

#Reads the subject Y test file
ds.Y_test<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/test/Y_test.txt")

#Reads the Y train file
ds.Y_train<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/train/Y_train.txt")

#Merges the Y test and train files into one data frame ds.Y
ds.Y<- rbind(ds.Y_test,ds.Y_train)

#Rename the varibale V1 of ds.Y to Activity
names(ds.Y)[names(ds.Y)=="V1"] <- "Activity"

#Combines data frames of subject,Y and X to form one merged data set
ds<-cbind(ds.subject,ds.Y,ds.X)

#*****************
#**** PART 3 - Creating the new dataset with std and mean fucntion variables
#*****************

# Finds the pattern 'std(' from the column names of dataset ds and store it in new data frame ds.std 
ds.std<-ds[grep("std\\(",names(ds))]


# Findss the pattern 'mean(' from the column names of dataset ds and store it in new data frame ds.mean
#I am excluding the column names which ends with meanFreq()
ds.mean<-ds[grep("-mean\\(",names(ds))]

# creates a new data set which is a combination of Subject and Activity variable from main dataset
# and recently created ds.mean andds.std datasets
ds.new<-cbind(ds$Subject , ds$Activity, ds.std ,ds.mean)

#Renames the variables from ds$Subject,ds$Activity to Subject,Activity
names(ds.new)[names(ds.new)=="ds$Subject"] <- "Subject"
names(ds.new)[names(ds.new)=="ds$Activity"] <- "Activity"

#*****************
#**** PART 4 - Replacing the Activity id with Activity descriptions
#*****************

# reads the activity_labels.txt file and store the result in data frame
ds.Activity<-read.table("C:/Users/Tejal/Documents/UCI HAR Dataset/activity_labels.txt")

# Joins the ds.new and activity dataset on activity id column to get activity description columns
ds.merged<-merge(ds.new,ds.Activity,by.x="Activity",by.y="V1")

# Removes the activity id column from merged data set
ds.merged$Activity<-NULL

# Renames the activity description column (which is the last column of datset because of merge) to Activity
names(ds.merged)[names(ds.merged)=="V2"] <- "Activity"

#*****************
#**** PART 5 - Create a tidy data set with aggregates
#*****************

# Aggregates all std and mean columns which are starting from 2 to 67 by Subject and Activity variables
tidy.data<-aggregate(ds.merged[,2:67] , by=list(ds.merged$Subject,ds.merged$Activity),mean)

# Renames the variable Group.1 from tidy.data to Subject
names(tidy.data)[names(tidy.data)=="Group.1"] <- "Subject"

# Renames the variable Group.2 from tidy.data to Activity
names(tidy.data)[names(tidy.data)=="Group.2"] <- "Activity"

#Writes the tidy data set to output file tidy_dataset,txt
write.table(tidy.data, "C:/Users/Tejal/Documents/UCI HAR Dataset/tidy_datatset.txt", sep="\t" ,row.name=FALSE )













