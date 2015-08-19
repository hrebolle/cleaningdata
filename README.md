# README
## Purpose of the Getting and Cleaning Data Project

The goal of this project is to prepare tidy data from a Human Activity Recognition database, built from the recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded inertial sensors.

## Obtaining source (raw) data

First of all you must retrieve the raw data from this source:
	[UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip) 
and extract the files in a local folder.

The full description of the data set can be obtained from this site:
	[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

A brief description of the data set can also be found in Codebook.md (in this repository).

## Process to create a Tidy Data Set ###

The process to obtain a tidy data set consists of the following steps:

1. Merge two data sets,train and test, to produce the full set of  observations (measurements and estimated variables).
2. Extract only mean value and standard deviation among these variables.
2. Append subject identifier and activity label to each observation.
3. Change variable names to more descriptive ones.
4. Generate a table with the averages separated by subject and activity.

Script **run_analisys.R** processes the raw data to create a tidy data set. The output is produced in tabular form in the **tidyData.txt** file. The table has 181 rows and 81 columns:

-  1 header row (column names), followed by
-  180 rows (30 subjects performing 6 classes of activities), and
-  2 columns identifying the subject and the activity class, followed by
-  79 columns with the averages of the mean value and the standard deviation of the signal measurements.

## Script run_analisys.R explained ###

To produce the desired results, the working directory must be set to the folder where you extracted the **UCI HAR Dataset** . This can be done using **setwd()**.

To run the script, you should source **run_analisys.R** from within RStudio. After that, you will see the output file **"tinyData.txt"** in the working directory, plus an extra file **"tinyData.csv"** with the same output, in a format suitable for Excel users like me.

The script has four functions:

**CheckFiles()**: Checks the existence of the 8 files containing the source data, and returns a logical TRUE if everything OK, or FALSE otherwise:

| File                    | Content                                                      |
|-------------------------|---------------------------------------------------------------|
| train/X_train.txt       | All measurements, training set                                |
| train/y_train.txt       | Activity labels for the training set                          |
| train/subject_train.txt | Subject id for the training set                               |
| test/X_test.txt         | All measurements, test set                                    |
| test/y_test.txt         | Activity labels for the test set                              |
| test/subject_test.txt   | Subject id for the test set                                   |
| features.txt            | Variable names (measurement and estimated variables)          |
| activity_labels.txt     | Classes of activity: STANDING, LAYING, etc. (see Codebook.md) |

**MergeData()**: Compiles the full data set, by means of:
 
- Reading the measurement files ("X_train.txt") and expanding them with the corresponding subject ("subject\_train.txt") and activity id ("y\_train.txt") as additional columns, on both sets (training and test),

- Adding the rows from the test set to the training set.

- Adding column names from the file "features.txt", and additional names for the expanded columns: "Subject" and "ActivityId",
- Adding the Activity (class or label) retrieved from the file "activity_labels.txt", based on the activity id, 

- Extracting mean value and standard deviation columns from the source data sets, while keeping Subject and Activity from the added columns.

**tidyNames()**: Changes the column names to a more human readable version, as explained in Codebook.md, section **"Choice of Descriptive Names"**.

**Reshape()**: Reshapes the data merged by the previous function to produce a tiny data set, either by using melt(...) followed by dcast(...) or by using ddply (...). These options are specified by the argument **"method"** which can be **"melt"** or **"ddply"**, with default "melt". The "melt" option requires library **reshape2**  and the "ddply" option requires library **plyr**.

The **main section** of the script invokes each one of these functions in sequence in order to get the tiny data set, and finally writes it to the file **"tinyData.txt"**.



 






