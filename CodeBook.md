# Code Book 
## Introduction
This document describes the resulting data set produced by running the run_analysis.R script.
Both this file, the script, and a README file can be obtained at the repository located at:
https://github.com/jonathanlabin/getcleandata_proj

This document is created based on the data definition provided in the raw data set which can be obtained at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## Raw Data Description
The original raw data was the:
Human Activity Recognition Using Smartphones Dataset Version 1.0
by:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

As per the project instructions, the raw data was obtained from the following location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This archive contains experimental data readings intended for classification and clustering applications.

From the README.txt file from the raw data archive:
>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>
>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 
>
>For each record it is provided:
>======================================
>
> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
> - Triaxial Angular velocity from the gyroscope. 
> - A 561-feature vector with time and frequency domain variables. 
> - Its activity label. 
> - An identifier of the subject who carried out the experiment.

## Study Design
The raw data from this archive was read and processed by the R script run_analysis.R (also in the repository).
See the README.md file and the script comments for a full description of the structure and functionality of this script.

### Read individual data sets
The raw archive contains two separate data sets: "train" and "test".  The first step in the study was to read both of these sets into R for further manipulation.
The function readDataSet will read either data set based on a setName argument and return a data frame which merges data from the following files:
* subject_<setName>.txt
* X_<setName>.txt
* y_<setName>.txt
Additionally a factor column named SourceSet is included which labels all of the rows with the source set from which it was read (again "train" or "test")

The columns of data from the X_<setName>.txt file are assigned from the values provided in features.txt.
The data from the subject_<setName>.txt file is a single column and is assigned a column name of "SubjectID"
The dat from the y_<setName>.txt file is a single column and is assigned the column name of "Activity" and is converted to a factor type using the labels provided in activity_labels.txt.

### Merge Data
The two data sets ("train" and "test") are merged into one single data frame using the function readAndMergeData.

### Reduce to Means and Standard Deviations
The project instructs that the raw data be reduced to only include data that represent a mean or a standard deviation.
The function reduceToMeanStdData performs this reduction on an input data frame by selecting only the index columns:
* SourceSet
* SubjectID
* Activity
as well as any further data column whose name contains either "mean" or "std".

### Compute Averages for each Subject-Activity Pair
Next, the reduced data set from the last step was processed to compute the average of each variable for every combination of SubjectID and Activity.
For this step, the SourceSet column was also dropped.
The function computeSubjectActivityAve performs this analysis and returns the final data set

### Write Results
Finally, the resulting tiny data set is written to a text file with the writeSummaryData function.

## Code Book
This section describes all of the variables in the final data set and their units.

### Key Variables
The following variables together uniquely identify each row of the data as a separate measurement:
* SubjectID - A numeric identifier of the test subject that collected the data in this row (ranges from 1 to 30).
* Activity - A factor indicating the activity that the subject was performing during the collection of the data in this row (One of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

### Data Variables
The following variables each represent an average for the all measurements of a variable in the raw set with this combination of SubjectID and Activity.  

* tBodyAcc.mean...X_mean - Average for this key of the mean body acceleration of the sensor in the X direction
* tBodyAcc.mean...Y_mean - Average for this key of the mean body acceleration of the sensor in the Y direction
* tBodyAcc.mean...Z_mean - Average for this key of the mean body acceleration of the sensor in the Z direction
* tBodyAcc.std...X_mean - Average for this key of the standard deviation of the body acceleration of the sensor in the X direction
* tBodyAcc.std...Y_mean - Average for this key of the standard deviation of the body acceleration of the sensor in the Y direction
* tBodyAcc.std...Z_mean - Average for this key of the standard deviation of the body acceleration of the sensor in the Z direction
* tGravityAcc.mean...X_mean - Average for this key of the mean of the gravity component of the acceleration of the sensor in the X direction
* tGravityAcc.mean...Y_mean - Average for this key of the mean of the gravity component of the acceleration of the sensor in the Y direction
* tGravityAcc.mean...Z_mean - Average for this key of the mean of the gravity component of the acceleration of the sensor in the Z direction
* tGravityAcc.std...X_mean - Average for this key of the standard deviation of the gravity component of the acceleration of the sensor in the X direction
* tGravityAcc.std...Y_mean - Average for this key of the standard deviation of the gravity component of the acceleration of the sensor in the Y direction
* tGravityAcc.std...Z_mean - Average for this key of the standard deviation of the gravity component of the acceleration of the sensor in the Z direction
* tBodyAccJerk.mean...X_mean - Average for this key of the mean body acceleration jerk of the sensor in the X direction
* tBodyAccJerk.mean...Y_mean - Average for this key of the mean body acceleration jerk of the sensor in the Y direction
* tBodyAccJerk.mean...Z_mean - Average for this key of the mean body acceleration jerk of the sensor in the Z direction
* tBodyAccJerk.std...X_mean - Average for this key of the standard deviation of the body acceleration jerk of the sensor in the X direction
* tBodyAccJerk.std...Y_mean - Average for this key of the standard deviation of the body acceleration jerk of the sensor in the Y direction
* tBodyAccJerk.std...Z_mean - Average for this key of the standard deviation of the body acceleration jerk of the sensor in the Z direction
* tBodyGyro.mean...X_mean - Average for this key of the mean body gyroscope sensor reading in the X direction
* tBodyGyro.mean...Y_mean - Average for this key of the mean body gyroscope sensor reading in the Y direction
* tBodyGyro.mean...Z_mean - Average for this key of the mean body gyroscope sensor reading in the Z direction
* tBodyGyro.std...X_mean - Average for this key of the standard deviation of the body gyroscope sensor reading in the X direction
* tBodyGyro.std...Y_mean - Average for this key of the standard deviation of the body gyroscope sensor reading in the Y direction
* tBodyGyro.std...Z_mean - Average for this key of the standard deviation of the body gyroscope sensor reading in the Z direction
* tBodyGyroJerk.mean...X_mean - Average for this key of the mean body gyroscope sensor jerk in the X direction
* tBodyGyroJerk.mean...Y_mean - Average for this key of the mean body gyroscope sensor jerk in the Y direction
* tBodyGyroJerk.mean...Z_mean - Average for this key of the mean body gyroscope sensor jerk in the Z direction
* tBodyGyroJerk.std...X_mean - Average for this key of the standard deviation of the body gyroscope sensor jerk in the X direction
* tBodyGyroJerk.std...Y_mean - Average for this key of the standard deviation of the body gyroscope sensor jerk in the Y direction
* tBodyGyroJerk.std...Z_mean - Average for this key of the standard deviation of the body gyroscope sensor jerk in the Z direction
* tBodyAccMag.mean.._mean - Average for this key of the mean magnitude of body acceleration of the sensor
* tBodyAccMag.std.._mean - Average for this key of the standard deviation of the magnitude of body acceleration of the sensor
* tGravityAccMag.mean.._mean - Average for this key of the mean magnitude of gravity component of acceleration of the sensor
* tGravityAccMag.std.._mean - Average for this key of the standard deviation of the magnitude of gravity component of acceleration of the sensor
* tBodyAccJerkMag.mean.._mean - Average for this key of the mean magnitude of the body acceleration jerk of the sensor
* tBodyAccJerkMag.std.._mean - Average for this key of the standard deviation of the magnitude of the body acceleration jerk of the sensor
* tBodyGyroMag.mean.._mean - Average for this key of the mean magnitude of body gyroscope sensor reading
* tBodyGyroMag.std.._mean - Average for this key of the standard deviation of the magnitude of body gyroscope sensor reading
* tBodyGyroJerkMag.mean.._mean - Average for this key of the mean magitude of body gyroscope sensor jerk
* tBodyGyroJerkMag.std.._mean - Average for this key of the standard deviation of the magnitude of body gyroscope sensor jerk
* fBodyAcc.mean...X_mean - Average for this key of the mean body acceleration frequency the X direction
* fBodyAcc.mean...Y_mean - Average for this key of the mean body acceleration frequency the Y direction
* fBodyAcc.mean...Z_mean - Average for this key of the mean body acceleration frequency the Z direction
* fBodyAcc.std...X_mean - Average for this key of the standard deviation of the body acceleration frequency the X direction
* fBodyAcc.std...Y_mean - Average for this key of the standard deviation of the body acceleration frequency the Y direction
* fBodyAcc.std...Z_mean - Average for this key of the standard deviation of the body acceleration frequency the Z direction
* fBodyAcc.meanFreq...X_mean - Average for this key of the mean frequency of body acceleration in the X direction
* fBodyAcc.meanFreq...Y_mean - Average for this key of the mean frequency of body acceleration in the Y direction
* fBodyAcc.meanFreq...Z_mean - Average for this key of the mean frequency of body acceleration in the Z direction
* fBodyAccJerk.mean...X_mean - Average for this key of the mean body acceleration jerk frequency in the X direction
* fBodyAccJerk.mean...Y_mean - Average for this key of the mean body acceleration jerk frequency in the Y direction
* fBodyAccJerk.mean...Z_mean - Average for this key of the mean body acceleration jerk frequency in the Z direction
* fBodyAccJerk.std...X_mean - Average for this key of the standard deviation of the body acceleration jerk frequency in the X direction
* fBodyAccJerk.std...Y_mean - Average for this key of the standard deviation of the body acceleration jerk frequency in the Y direction
* fBodyAccJerk.std...Z_mean - Average for this key of the standard deviation of the body acceleration jerk frequency in the Z direction
* fBodyAccJerk.meanFreq...X_mean - Average for this key of the mean frequency of the body acceleration jerk in the X direction
* fBodyAccJerk.meanFreq...Y_mean - Average for this key of the mean frequency of the body acceleration jerk in the Y direction
* fBodyAccJerk.meanFreq...Z_mean - Average for this key of the mean frequency of the body acceleration jerk in the Z direction
* fBodyGyro.mean...X_mean - Average for this key of the mean body gyroscope frequency in the X direction
* fBodyGyro.mean...Y_mean - Average for this key of the mean body gyroscope frequency in the Y direction
* fBodyGyro.mean...Z_mean - Average for this key of the mean body gyroscope frequency in the Z direction
* fBodyGyro.std...X_mean - Average for this key of the standard deviation of the body gyroscope frequency in the X direction
* fBodyGyro.std...Y_mean - Average for this key of the standard deviation of the body gyroscope frequency in the Y direction
* fBodyGyro.std...Z_mean - Average for this key of the standard deviation of the body gyroscope frequency in the Z direction
* fBodyGyro.meanFreq...X_mean - Average for this key of the mean frequency body gyroscope in the X direction
* fBodyGyro.meanFreq...Y_mean - Average for this key of the mean frequency body gyroscope in the Y direction
* fBodyGyro.meanFreq...Z_mean - Average for this key of the mean frequency body gyroscope in the Z direction
* fBodyAccMag.mean.._mean - Average for this key of the mean magnitude of body acceleration frequency
* fBodyAccMag.std.._mean - Average for this key of the standard deviation of the magnitude of body acceleration frequency
* fBodyAccMag.meanFreq.._mean - Average for this key of the mean frequency magnitude of body acceleration
* fBodyBodyAccJerkMag.mean.._mean - Average for this key of the mean magnitude of the body acceleration jerk frequency
* fBodyBodyAccJerkMag.std.._mean - Average for this key of the standard deviation of the frequency magnitude of the body acceleration jerk of the sensor
* fBodyBodyAccJerkMag.meanFreq.._mean - Average for this key of the mean frequency of the magnitude of body acceleration
* fBodyBodyGyroMag.mean.._mean - Average for this key of the mean magnitude of body gyroscope frequency
* fBodyBodyGyroMag.std.._mean - Average for this key of the standard deviation of the magnitude of body gyroscope frequency
* fBodyBodyGyroMag.meanFreq.._mean - Average for this key of the mean magnitude of body gyroscope frequency
* fBodyBodyGyroJerkMag.mean.._mean - Average for this key of the mean magnitude of body gyroscope sensor jerk frequency
* fBodyBodyGyroJerkMag.std.._mean - Average for this key of the standard deviation of the magnitude of body gyroscope sensor jerk frequency
* fBodyBodyGyroJerkMag.meanFreq.._mean - Average for this key of the mean frequency of the magnitude of body gyroscope sensor jerk
* angle.tBodyAccMean.gravity._mean - Average for this key of the angle between mean body acceleration and gravity vectors
* angle.tBodyAccJerkMean..gravityMean._mean - Average for this key of the angle between mean body acceleration jerk and gravity mean vectors
* angle.tBodyGyroMean.gravityMean._mean - Average for this key of the angle between mean body gyroscope and gravity mean vectors
* angle.tBodyGyroJerkMean.gravityMean._mean - Average for this key of the angle between mean body gyroscope jerk and gravity mean vectors
* angle.X.gravityMean._mean - Average for this key of the angle between the X axis of the sensor and the gravity mean vector
* angle.Y.gravityMean._mean - Average for this key of the angle between the Y axis of the sensor and the gravity mean vector
* angle.Z.gravityMean._mean - Average for this key of the angle between the Z axis of the sensor and the gravity mean vector