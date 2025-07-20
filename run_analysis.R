# Install and load dplyr
install.packages("dplyr")  # Run only once
library(dplyr)

# Download and unzip the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "~/Desktop/R-Coursera/Coursera_Final.zip", method = "curl")
unzip("~/Desktop/R-Coursera/Coursera_Final.zip", exdir = "~/Desktop/R-Coursera")

# Set working directory to extracted folder (optional)
setwd("~/Desktop/R-Coursera/UCI HAR Dataset")

# Read metadata
features <- read.table("features.txt", col.names = c("n", "functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))

# Read test data
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")

# Read train data
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

# Merge activity names into y data
y_test <- merge(y_test, activities, by = "code")[, 2, drop = FALSE]
y_train <- merge(y_train, activities, by = "code")[, 2, drop = FALSE]
colnames(y_test) <- "activity"
colnames(y_train) <- "activity"

# Combine data
test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)
merged_data <- rbind(test, train)

# Select mean and std columns
tidy_data <- merged_data %>% select(subject, activity, contains("mean"), contains("std"))

# Clean variable names
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("-mean\\(\\)", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-std\\(\\)", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-freq\\(\\)", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

# Create final dataset with averages
FinalData <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Write to file
write.table(FinalData, "FinalData.txt", row.name = FALSE)

# Check structure
str(FinalData)

write.table(FinalData, "FinalData.txt", row.name = FALSE)
  