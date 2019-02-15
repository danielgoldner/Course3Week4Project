library(dplyr)

# Label X Test Data columns
x_test <- read.table('X_test.txt')
features <- read.table('features.txt')
tbl_df(features) -> features
rename(features, id=V1, feature_name=V2) %>% mutate(uniq_feature_name=paste0(id, '_', feature_name)) -> features
features$uniq_feature_name -> names(x_test)
tbl_df(x_test) -> x_test

# Label X Train Data columns
x_train <- read.table('X_train.txt')
names(x_train) <- features$uniq_feature_name
tbl_df(x_train) -> x_train

# Combine subject_test, y_test with X test
y_test <- read.table('y_test.txt')
s_test <- read.table('subject_test.txt')
names(y_test) <- 'activity_id'
names(s_test) <- 'subject'
tbl_df(y_test) -> y_test
tbl_df(s_test) -> s_test
tbl_df(cbind(s_test, y_test, x_test)) -> test_data

# Read in activity labels
activity_labels <- read.table('activity_labels.txt')
names(activity_labels) <- c('activity_id', 'activity_name')
tbl_df(activity_labels) -> activity_labels


# Read in Train Data (subject, y and X)
y_train <- read.table('y_train.txt')
s_train <- read.table('subject_train.txt')
names(y_train) <- 'activity_id'
names(s_train) <- 'subject'
tbl_df(y_train) -> y_train
tbl_df(s_train) -> s_train
tbl_df(cbind(s_train, y_train, x_train)) -> train_data

# Combine train and test data
bind_rows(train_data, test_data) -> train_test_data

# Join in activity labels and select only the needed columns
inner_join(train_test_data, activity_labels) -> train_test_data
select(train_test_data, subject, activity_name, contains('mean'), contains('std')) -> train_test_data

# Group by subject and activity. Find mean of all columns.
by_subject_activity <- group_by(train_test_data, subject, activity_name)
means <- summarize_all(by_subject_activity, funs(mean))

print (means)

