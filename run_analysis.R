####Download and read zip data####
if(!file.exists("./Datos")){dir.create("./Datos")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl,destfile="./Datos/Dataset.zip",method="curl")
#### Unzip data####
unzip(zipfile="./data/Dataset.zip",exdir="./Datos")
### File path ###
project <- file.path("./Datos" , "UCI HAR Dataset")
files<-list.files(project, recursive=TRUE)
files
### Data into variables ####
##Features##
Features_Test  <- read.table(file.path(project, "test" , "X_test.txt" ),header = FALSE)
Features_Train <- read.table(file.path(project, "train", "X_train.txt"),header = FALSE)
##Activity##
Activity_Test  <- read.table(file.path(project, "test" , "Y_test.txt" ),header = FALSE)
Activity_Train <- read.table(file.path(project, "train", "Y_train.txt"),header = FALSE)
##Subject##
Subject_Test  <- read.table(file.path(project, "test" , "subject_test.txt"),header = FALSE)
Subject_Train <- read.table(file.path(project, "train", "subject_train.txt"),header = FALSE)

#### To merge the training and test sets ####
Subject <- rbind(Subject_Train, Subject_Test)
Activity<- rbind(Activity_Train, Activity_Test)
Features<- rbind(Features_Train, Features_Test)

### Names of variables ###
names(Activity)<- c("activity")
names(Subject)<-c("subject")
Features_NM <- read.table(file.path(project, "features.txt"),head=FALSE)
names(Features)<- Features_NM$V2

#### Data ###
Def_data <- cbind(Subject, Activity)
Data1 <- cbind(Features, Def_data)

#### Select data ###
subsetFeatures_NM<-Features_NM$V2[grep("mean\\(\\)|std\\(\\)", Features_NM$V2)]
NM <- c(as.character(subsetFeatures_NM), "subject", "activity" )
Data2 <- subset(Data1,select=NM)

### Descriptive activity names ###
Activity_NM <- read.table(file.path(project, "activity_labels.txt"),header = FALSE)
names(Data2)<-gsub("^t", "time", names(Data2))
names(Data2)<-gsub("^f", "frequency", names(Data2))
names(Data2)<-gsub("Acc", "Accelerometer", names(Data2))
names(Data2)<-gsub("Gyro", "Gyroscope", names(Data2))
names(Data2)<-gsub("Mag", "Magnitude", names(Data2))
names(Data2)<-gsub("BodyBody", "Body", names(Data2))

#### Part I #### 
install.packages("plyr")
library(plyr)
Data3<-aggregate(. ~subject + activity, Data2, mean)
Data3<-Data3[order(Data3$subject,Data3$activity),]
write.table(Data3, file = "CourseProject1.txt",row.name=FALSE)

#### Part II ####
install.packages("knitr")
library(knitr)
knit2html("codebook.Rmd")

#### END ###
