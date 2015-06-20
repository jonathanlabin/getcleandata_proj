## Coursera: Getting and Cleaning Data
## Course Project
## Jonathan Labin
## 2015-06-18

library(dplyr)

## Reads and performs processing on experimental data collected by
## accelerometers from the Samsung Galaxy S smartphone.
##
## A full description of the data is available where the data was obtained:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## 
## The full instructions for the assignment are to write a script which:
## 1) Merges the training and the test sets to create one data set.
##  * This is performed by a call to readAndMergeData which uses readDataSet
##
## 2) Extracts only the measurements on the mean and standard deviation for
##    each measurement.
##  * This filtering is performed by reduceToMeanStdData
##
## 3) Uses descriptive activity names to name the activities in the data set
##  * This is handled by readDataSet beginning with the comment:
##       "convert the activity codes read in into a factor with readable labels"
##
## 4) Appropriately labels the data set with descriptive variable names. 
##  * The columns of the data are set as the data set is Read in.  The data 
##    columns are assigned the name from the features.txt file.  The others are
##    a name manually when read in. 
##
## 5) From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.
##  * This is handled by computeSubjectActivityAve
##
##
## The script will perform the analysis automatically when it is sourced by R.
## It does so with an initial call to writeSummaryData() using the default 
## argument values.
## To disable this automated analysis, please comment out the following line:
writeSummaryData()
 
## However, each of the functions can be called with alternate argument values
## in situations where different file names or paths are required.
## In this case, an example call sequence is:
##
##   data <- readAndMergeData("<path to root of raw data>")
##   data <- reduceToMeanStdData(data)
##   data <- computeSubjectActivityAve(data)
##   writeSummaryData(data, fileOutPath="<path to output file>")
##
## If such a customized call sequence is required, comment out the above call
## to writeSummaryData() above.

## Writes the data frame in to the file specified by fileOutPath.
## The x argument is of the form produced by computeSugjectActivityAve and if
## not provided defaults to the result of calling computeSubjectActivityAve
## with no arguments
writeSummaryData <- function(x = computeSubjectActivityAve(),
                             fileOutPath = "SummaryData.txt"){
    write.table(x, file = fileOutPath, row.name=FALSE)
}

## Returns a data frame containing the mean of each data column grouped by the
## SubjectID and Activity
##
## x is a data frame of the form returned by reduceToMeanStdData
computeSubjectActivityAve <- function(x = reduceToMeanStdData()){
    # Drop SourceSet column
    data <- subset(x, select=-SourceSet)
    
    # Group by SubjectID and Activity and then call mean on each of the
    # remaining columns within each group.
    data<-data %>% group_by(SubjectID, Activity) %>% summarise_each(funs(mean))
    
    # append _mean to the data column names (but not SubjectID or Activity)
    data_col_names <- colnames(data)
    colnames(data) <- c(data_col_names[seq(2)], 
                        paste(data_col_names[-seq(2)], "_mean", sep=""))
    data
}

## Reduces the data by retaining only those data columns containing mean and
## standard deviation values.
##
## x is a data frame of the form produced by function readAndMergeData.
reduceToMeanStdData <- function(x = readAndMergeData()){
    
    keepCols = "^SourceSet$|^SubjectID$|^Activity$|mean|std"
    columnIndices <- grep(keepCols, colnames(x), ignore.case = TRUE)
    
    x[,columnIndices]
}

## Creates a data frame contining the merged data from both the train and test 
## sets by reading the files located at the path location indicated by argument 
## dataRootDir.
## 
## The dataRootDir argument should be a character string defining a file system
## path to the root of the downloaded data.
readAndMergeData <- function(dataRootDir = "UCI HAR Dataset"){
    # read in the train set
    trainData <- readDataSet(dataRootDir, "train")
    
    #read in the test set
    testData <- readDataSet(dataRootDir, "test")
    
    # return a merged data frame containing both sets
    rbind(trainData, testData)
}

## Creates a data frame by reading the data set named by argument setName from 
## the files located at the path location indicated by argument dataRootDir.
## 
## The dataRootDir argument should be a character string defining a file system
## path to the root of the downloaded data.
## The setName argument should be one of the values: "test" or "train"
readDataSet <- function(dataRootDir, setName){
    
    # define path to data set
    setDir <- paste(dataRootDir, setName, sep="/")
    
    # read in subject ids
    subjectFile <- paste(setDir, "/subject_", setName, ".txt", sep="")
    subjectIDs <- read.table(subjectFile, col.names="SubjectID")
    
    # read in activity identifiers and set column name
    activityFile <- paste(setDir, "/y_", setName, ".txt", sep="")
    activity <- read.table(activityFile, col.names = "Activity")
    
    # convert the activity codes read in into a factor with readable labels
    actLblFile <- paste(dataRootDir, "activity_labels.txt", sep="/")
    actLblCols <- c("ActivityCode", "ActivityName")
    activityLabels <- read.table(actLblFile, col.names=actLblCols)
    activity$Activity <- factor(activity$Activity,
                                levels=seq(nrow(activityLabels)),
                                labels=activityLabels$ActivityName)
    
    # read the column names for the data from features.txt
    featuresFile <- paste(dataRootDir, "features.txt", sep="/")
    features <- read.table(featuresFile, col.names=c("colNum", "name"))
    
    # read in body of sensor data and set column names from features
    dataFile <- paste(setDir, "/X_", setName, ".txt", sep="")
    data <- read.table(dataFile, col.names = features$name)
    
    # create a factor identifying the source set of this data
    sourceSet <- as.data.frame(factor(rep(setName, nrow(data)), 
                                      levels=c("train", "test")))
    colnames(sourceSet)<-"SourceSet"
    
    # combine all of the columns into one data frame to return
    cbind(sourceSet, subjectIDs, activity, data)
}

