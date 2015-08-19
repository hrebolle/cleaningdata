## README 
### Getting and Cleaning Data Project
### Hugo Rebolledo

## Purpose of the Project

The goal of this project is to prepare tidy data from a Human Activity Recognition database, built from the recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded inertial sensors.

## Obtaining source (raw) data

First of all you must retrieve the raw data from this source:
	[UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip) 
and extract the files in a local folder.

The full description of the data set can be obtained from this site:
	[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

A brief description of the data set can also be found in Codebook.md (in this repository).

## Process to create the Tidy Data Set ###

The process implemented to obtain a tidy data set consists of the following steps:

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

## Running script run_analisys.R ###

To produce the desired results, the working directory must be set to the folder where you extracted the **UCI HAR Dataset** . This can be done using **setwd()**.

To run the script, you should source **run_analisys.R** from within RStudio. After that, you will see the output file **"tinyData.txt"** in the working directory, plus an extra file **"tinyData.csv"** with the same output, in a format suitable for Excel users like me.

If everything goes fine, you should see this ouput on screen after sourceing  **run_analisys.R**:

    [1] "Checking required raw data files ... "
    [1] "Reading raw data, merging and extracting required columns ... "
    [1] "Transforming column names ... "
    [1] "Summarizing data ... "
    [1] "Writing results ... 
    [1] "And that´s it!!! "

## Script run_analisys.R explained ###

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

**MergeData()**: Returns a data frame containing the full data set, performing the following actions:
 
- Reads the measurement files from the training set ("X\_train.txt") and expands them with the corresponding subject ("subject\_train.txt") and activity id ("y\_train.txt") as additional columns. Applies same procedure to the test set ("X\_test.txt", "subject\_test.txt", "y\_test.txt").

- Appends the rows from the test set to the training set using **rbind()**.

- Sets the column names from the file "features.txt", with additional names for the expanded columns: "Subject" and "ActivityId",

- Adds a column "Activity", with the human readable label of the activity class, retrieved from the file "activity_labels.txt", using ActivityId as index.

- Extracts mean value and standard deviation columns from the source data sets, while keeping Subject and Activity from the added columns.

**tidyNames(x)**: Takes the names from the input data frame and returns a character vector of transformed column names, as explained in Codebook.md, section **"Choice of Descriptive Names"**.

**Reshape(x, method = "melt")**: Takes the input data frame, produced by MergeData() and returns a reshaped data frame, either by using melt(...) followed by dcast(...) or by using ddply (...). These options are specified by the argument **"method"** which can be **"melt"** or **"ddply"**, with default "melt". The "melt" option requires library **reshape2**  and the "ddply" option requires library **plyr**.

The **main section** of the script invokes each one of these functions in sequence in order to get the tiny data set, and finally writes it to the file **"tinyData.txt"**.



 






