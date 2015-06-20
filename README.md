# Getting and Cleaning Data Course Project
## Introduction 
This repository satisfies the requirements of the course project for the Coursera "Getting and Cleaning Data" class.
The purpose is to demonstrate processing raw data into a "tidy" data set with sufficient documentation so that others may replicate the work.

The files contained in this repository are:
* README.md - (this file)
* run_analysis.R - An R script which processes the data into the "tidy" format
* CodeBook.md - A description of the data resulting from running run_analysis.README

## The Assignment
The assignment requires the student to develop a script which reads and performs processing on experimental data collected by accelerometers from the Samsung Galaxy S smartphone.

A full description of the data is available where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 
The full instructions for the assignment are to write a script which:
1. Merges the training and the test sets to create one data set.
(This is performed by a call to readAndMergeData which uses readDataSet)

2. Extracts only the measurements on the mean and standard deviation for each measurement.
(This filtering is performed by reduceToMeanStdData)

3. Uses descriptive activity names to name the activities in the data set
(This is handled by readDataSet beginning with the comment:
	convert the activity codes read in into a factor with readable labels
)

4. Appropriately labels the data set with descriptive variable names. 
(The columns of the data are set as the data set is Read in.  The data columns are assigned the name from the features.txt file.  
The others are a name manually when read in.)

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
(This is handled by computeSubjectActivityAve)

## Using the Script
The run_analysis.R script will perform the analysis automatically when it is sourced by R resulting in an text file being written
It does so with an initial call to writeSummaryData() using the default argument values.
To disable this automated analysis, please locate and comment out the following line:

	writeSummaryData()
 
However, each of the functions can be called with alternate argument values in situations where different file names or paths are required.
In this case, an example call sequence is:

	data <- readAndMergeData("<path to root of raw data>")
	data <- reduceToMeanStdData(data)
	data <- computeSubjectActivityAve(data)
	writeSummaryData(data, fileOutPath="<path to output file>")
   
 If such a customized call sequence is required, please locate and comment out the following line:

	writeSummaryData()

## Using the Results
The script produces a text data file (default name is SummaryData.txt) that can be read into R and inspected using the following commands:

	data <- read.table(file_path, header = TRUE)
    View(data)
	
See CodeBook.md for a description of the structure of the data file.  However, in general one can interpret the first two columns as the key that uniqurely identifies a single measurement (row)
	SubjectID,Activity
The remaining columns represent the data readings for that measurement (row).

This data is considered "tidy" because:
1. Each measured variable is in one column
2. Each measurement of that variable is in a separate row
3. All of the data (except the two key columns) is numeric and so there is only one table containing all of the data of that same "kind"
4. N/A (there is only one table)
	
## Structure of the Script
The script consists of 5 functions:
* writeSummaryData - Writes the final tidy data set to the specified file (defaults to SummaryData.txt)
* computeSubjectActivityAve - Computes the average for each data variable for every combination of SubjectID and Activity
* reduceToMeanStdData - Filters the data set to include only SourceSet, SubjectID, Activity, and any data variable that is a mean or a standard deviation value.
* readAndMergeData - Merges the "train" and "test" data sets into one
* readDataSet - Reads a single data set (either "train" or "test") from raw input files

Each function utilizes the next in the list to produce an automatic data processing pipeline.
The functions writeSummaryData, computeSubjectActivityAve, and reduceToMeanStdData each accept a data frame argument produced by the function defined next. 
In each of these, if no data value is passed in the argument x, it defaults to the result of calling the subsequent function with no arguments.

The function readAndMergeData does not accept a data frame as input but it does have an optional string argument defining the root folder location of the data.
It also calls readDataSet explicitly in the function body for the two known data sets ("train" and "test")

