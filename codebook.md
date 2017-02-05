# Description of Data Sets

## Introduction
This git hub repo contains two tidy data sets:
* activity_measurements.csv (data set after step 4)
* activity_measurements_mean.csv (data set after step 5)

These data sets were derived from accelerometer data conducted in a study for Human Activity Recognition Using Smartphones (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The original data set along with some more descriptions can be found within this GitHub repo in the directory UCI_HAR_Dataset.

How the data sets were derived is explained below in the section *How the Data Sets were derived*.

## Background of data sets
The intention of the experiment was to recognize six basic human activities using the accelerometer and gyroscope 3-axial raw signals from a smartphone.
The six basic activities are: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
30 subjects participated in the experiment. By random 70% were selected in the training data set and 30% in the test data set.

## Description of variables
The data set *activity_measurements.csv* describes all the measurements conducted for the subjects doing the activities multiple times. 

The data set *activity_measurements_mean.csv* contains the average per activity and subject for all the measurements in the data set *activity_measurements.csv*.

Nevertheless both data sets have the same column names.

The first 2 columns in both data sets describe:
activity - the subject's activity as a label
subject - the number of the subject as int between 1 and 30

The other variables are all the means (mean) and standard deviations (std) from the features of the accelerometer and gyroscope 3-axial raw signals. (The second data set 
*activity_measurements_mean.csv* gives the average per subject and activity for all those stds and means of the measurements)

Folowing is an explanation of the feature measurements:
All features starting with t are time domain signals with noise already been removed.
All features starting with f are frequency domain signals produced by Fast Fourier Transformation (FFT) on some of the t features.
BodyAcc and GravityAcc denotes the seperation of body and gravity acceleration signals.
Gyro denotes the gyroscope signals.
Jerk denotes Jerk signals derived from other signals.
Mag denotes the magnitude of the three-dimensional signals.
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc.XYZ
* tGravityAcc.XYZ
* tBodyAccJerk.XYZ
* tBodyGyro.XYZ
* tBodyGyroJerk.XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc.XYZ
* fBodyAccJerk.XYZ
* fBodyGyro.XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The variables in the data set correspond to the following schema [feature_name].[mean/std].[X/Y/Z] where the last part is optional.
So, the actual variables look like:
* tBodyAcc.mean.X
* tBodyAcc.mean.Y
* tBodyAcc.mean.Z
* tBodyAcc.std.X
* tBodyAcc.std.Y
* tBodyAcc.std.Z
* tGravityAcc.mean.X
* tGravityAcc.mean.Y
* ...
* tBodyAccMag.mean
* tBodyAccMag.std
* ...

Further description of all original varibales and how they were produced can be found within the file UCI_HAR_Dataset/features_info.txt.

# How the Data Sets were derived

## Original Data Sets / Files
The original data sets can be found within this GitHub repo in the directory UCI_HAR_Dataset. 
The following files were used to produce the data sets (path is relative to UCI_HAR_Dataset directory):
* train/subject_train.txt - contains the subject vector for the X_train data set
* train/X_train.txt - X_train data set containing all feature vectors for the training subset
* train/y_train.txt - contains the activity vector for the X_train data set
* test/subject_test.txt - contains the subject vector for the X_test data set
* test/X_test.txt - X_test data set containing all feature vectors for the test subset
* test/y_test.txt - contains the activity vector for the X_test data set
* activity_labels.txt - contains a vector of the six acitivity ids and corresponding labels
* features.txt - contains a vector of all the featurenames (variable names) for X_train and X_test data set
	
## activity_measurements.csv
The measurements from the original training and test data sets were merged together into one data set along with the coresponding subject and activity value.
The activity columns contains the lables instead of the ids.
For all the given variables in the original data set, only the mean and the standard deviation was extracted.

## activity_measurements_mean.csv
Based on the data set *activity_measurements.csv* a second data set was derived containing the average values for all variables per activity and subject.
Thus data set contains 6 * 30 = 180 rows.

## Script to derive the data sets from the original data sets
The data sets were produced with the function run_analysis within the R file run_analysis.R which resides within this GitHub repo.
For running the script, the orginal data sets must be on the same relative paths as they are within this GitHub repo.

## Steps tp reshape and derive the data set
### 1. Merges the training and the test sets to create one data set.
This is done in the run_analysis.R script in line 38 to 42.
First the measurement data sets (X_train / X_test) are combined with their respective activity ids (y_train / y_test) and subject ids (subject_train / subject_test).
Afterwards both data sets are merged together with rbind().

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
This is done in line 46 to 51.
First with the help of grep, only those variables which are defined for mean() and std() are extracted. Intentionally, I did not extract meanFreq() variables and also not the angle variables, since I think they are not meant to be within scope.

### 3. Uses descriptive activity names to name the activities in the data set
This is done in line 56 to 60.
A new data set is created by joining the prepared data set and the activity label data set. Then the columns are reordered to have the activity label in first place, the subject in second and then following all the measeurements.
That way I just replaced the ids of the activities by their labels (aka descriptive names).

### 4. Appropriately labels the data set with descriptive variable names.
I decided to do that right after reading the data into the data frames. It is done in line 25 to 34.
That way I could use the given feature vector without any changes. And afterwards I could extract the measurements required for step 2 one the column names of the data set.
I not only found it easier that way, but also right from the beginning, the variables in the data frames have appropriate names.
Regarding the descriptive names I have chosen to use the function make.names() on the feature names vector. That function replaces any noncharacter in a string with a dot. Also duplicates are eliminated by adding a number. Since the duplicate names only occur on the brandEnergy variables, no further tidying of names is neccesary since they are removed later on.
Now the variable names clearly state what each columns stands for, espaecially along with the coodbook.
The activity and subject columns are also named. After step 3 the resulting data set first contains the subject the activity variable, then the subject variable, and then all the measurement variables.

After having done step 1 to 4, the data set *activity_measurements.csv* is complete.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
As there are many ways to interpret this task (see forum for this class) I shortly explain my interpretation:
For every column (except activity and subject) an average needs to be computed but only within the same activiy and subject.
That means the result would have 6 * 30 = 180 rows, with each row containing the average of all the measurements for the specific activity and subject indicated.
This was accomplished in line 64 to 66 in the script.

(The equivalent in SQL would be:
select activity, subject, avg(tBodyAcc.mean.X), avg(tBodyAcc.mean.Y), avg(tBodyAcc.mean.Z), ... 
from data_set 
group by activity, subject)

The result goes into data set *activity_measurements_mean.csv*