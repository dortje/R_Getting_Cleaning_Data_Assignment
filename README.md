# R_Getting_Cleaning_Data_Assignment
## What is this repo about
This repo was created for the final assigment for the Coursera course Getting and Cleaning Data from the Johns Hopkins University.
It contains all the required files along with the original data.

## What is the task about
The task for the assignment is placed within the field of activity recognition. A group of scientists has conducted an experiment with 30 human subjects to recognize six basic activities, which are:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING
They have used signals from a smartphones accelerometer and gyrospce.
A more detailed description is available here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The data can be obtained here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
(The original data is also part of this GitHub repo.)

The task for this assigment is to reshape the data and to derive new data from the original data sets given.

## What files are included and what are they for
The following files are included within ths repo:
* README.md - This file. It gives a short introduction to the purpose of this repo and an overview of the files and their content
* codebook.md - This markdown file explains the data sets produced, the variables within them and how they were derived from the original data sets
* activity_measurements.csv - A reshaped data set containing the mean and standard deviation of acceleration and gyroscope measurements for six basic activities conducted by 30 human subjects
* activity_measurements_mean.csv - A derived data set containing the average of the mean and standard deviations of the measurements from file activity_measurements.csv per activity and subjects
* run_analysis.R - An R file containing a function to produce the two data sets from the original data
* directory UCI_HAR_Dataset - The directory containing the original data sets along with descriptions about them. (Further explanations about the files used for the assigment can be found in the coodbook.)

## How can the resulting data sets be read
I have used write.csv() to write the data sets. So please use read.csv() for reading them. No further arguments (apart from the file name of course) are required.