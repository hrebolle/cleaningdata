## CodeBook 
### Getting and Cleaning Data Project

The goal of this project is to prepare tidy data from a Human Activity Recognition database, built from the recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded inertial sensors.

### Raw Data Brief Description

The data comes from measurements of 3-axial **linear acceleration** and 3-axial **angular velocity** signals, collected from the embedded accelerometer and gyroscope of the subject´s smartphone, while he or she is performing six activities labeled WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, and LAYING.

This **time domain** signals were captured at a constant rate of 50 Hz and filtered with a Butterworth filter to reduce noise. The **linear acceleration** signal was separated into **body linear acceleration** and **gravity acceleration** signals. Subsequently, the **body linear acceleration** and **angular velocity** were derived in time to obtain **Jerk** (rate of change of acceleration) signals. Also the **magnitude** of all these three-dimensional signals were calculated, using the Euclidean norm. Finally a Fast Fourier Transform (FFT) was applied to some of these signals to produce **frequency domain** signals.  

Several variables were afterward estimated from these signals: mean value, standard deviation,largest and smallest value in array,energy measure,signal entropy, among others.

**Important Notes:**

- All this data is normalized and bounded within [-1,1].
- The acceleration units (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units (angular velocity) are rad/seg.
- A very illustrative video of the experiment including examples of the 6 classes of activities can be seen in the following link:
	[Activity Recording Video](http://www.youtube.com/watch?v=XOEN9W05_4A)
- The full description of the data set can be obtained from this site:
	[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- The raw data was obtained from this site:
	[UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip)


### Generating a Tidy Data Set ###

The source data is separated in two sets, "train" and "tests", to perform supervised machine learning. A set of labels (classes of activities) and the identifier of the subjects performing the activities are provided in two additional files.

The tidy data set consists of the average of the mean value and the standard deviation of the signal measurements described above, for each activity and each subject.

Therefore, the process to obtain a tidy data set consists of the following steps:

1. Merge both data sets,train and test, to produce the full set of  observations (measurements and estimated variables).
2. Extract only mean value and standard deviation among these variables.
2. Append subject identifier and activity label to each observation.
3. Change variable names to more descriptive ones.
4. Generate a table with the averages separated by subject and activity.

Script **run_analisys.R** processes the raw data to create a tidy data set. The output is produced in tabular form in the **tidyData.txt** file. The table has 181 rows and 81 columns:

-  1 header row (column names), followed by
-  180 rows (30 subjects performing 6 classes of activities), and
-  2 columns identifying the subject and the activity class, followed by
-  79 columns with the averages of the mean value and the standard deviation of the signal measurements.

Details of the implementation can be found in **README.md**

### Choice of Descriptive Names

Source data comes in tabular form, with column names representatives of the domain, type of measurement and estimated variables. These elements are transformed as follows:

| Concept                        | Raw Data | Tidy Data     |
|--------------------------------|----------|---------------|
| Time domain signal             | t        | time.         |
| Frequency domain signal        | f        | freq.         |
| Linear acceleration            | Acc      | .Acceleration |
| Angular acceleration           | Gyro     | .AngularAccel |
| Rate of change of acceleration | Jerk     | .Jerk         |
| Vector magnitude               | Mag      | .Magnitude    |
| Mean value                     | mean()   | .Mean         |
| Standard deviation             | std()    | .StdDev       |

Dashes(-) where changed by dots(.). Words like Body and Gravity were kept unchanged. With this choice, column name elements become a) Expanded rather than abbreviated, and b) All separated by a dot (.).  So for instance:

- tBodyAccJerk-std()-X becomes time.Body.Acceleration.Jerk.StdDev.X
- fBodyGyroMag-mean() becomes freq.Body.AngularAccel.Magnitude.Mean

**Note**: It can be argued that long names are difficult to manage when processing data, but the aim of this project is to demonstrate how to process data to produce a clean data set. Expanded names are easier to understand though. The choice (short vs. long names) depends on the target audience, I think.



