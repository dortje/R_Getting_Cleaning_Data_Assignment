run_analysis <- function() {
	
	print("loading data sets ...")
	# specify directories to read data from
	base_dir <- file.path(getwd(), "UCI_HAR_Dataset")
	train_dir <- file.path(base_dir, "train")
	test_dir <- file.path(base_dir, "test")

	# read data
	subject_train <- read.csv(file.path(train_dir, "subject_train.txt"), header = FALSE)
	X_train <- read.csv(file.path(train_dir, "X_train.txt"), sep = "", header = FALSE)
		# Learning: sep = "" refers to any length whitespace, whereas sep = " " refers to one length white space
	y_train <- read.csv(file.path(train_dir, "y_train.txt"), header = FALSE)

	subject_test <- read.csv(file.path(test_dir, "subject_test.txt"), header = FALSE)
	X_test <- read.csv(file.path(test_dir, "X_test.txt"), sep = "", header = FALSE)
	y_test <- read.csv(file.path(test_dir, "y_test.txt"), header = FALSE)

	activity_labels <- read.csv(file.path(base_dir, "activity_labels.txt"), sep = "", header = FALSE)
	features <- read.csv(file.path(base_dir, "features.txt"), sep = "", header = FALSE)
	
	
	print("naming variables ...")
	# name variables in columns
	colnames(y_train)[1] <- "activity_id"
	colnames(y_test)[1] <- "activity_id"
	colnames(subject_train)[1] <- "subject"
	colnames(subject_test)[1] <- "subject"
	colnames(activity_labels) <- c("id", "activity")
	featurenames <- make.names(features[,2], unique = TRUE) 
		# Learning: make.names with unique = TRUE sorgt für Anpassung von Namen bei Duplikaten
	featurenames <- gsub("\\.\\.", "", featurenames)
	colnames(X_train) <- featurenames
	colnames(X_test) <- featurenames


	print("merging data sets ...")
	library(dplyr)
	# merge data sets
	X_train_typed <- cbind.data.frame(subject_train, y_train, X_train)
	X_test_typed <- cbind.data.frame(subject_test, y_test, X_test)
	X_train_and_test <- rbind(X_train_typed, X_test_typed)

	
	print("extracting variables ...")
	# extract only variables for mean and standard deviation
	X_train_and_test_mean_std <- X_train_and_test[, grep("(std|mean)($|[^A-Za-z])", colnames(X_train_and_test))]
		# Learning: to escape for grep, double escape must be used, since single \ already escapes string
	X_train_and_test_mean_std <- cbind.data.frame(X_train_and_test[, c(1,2)], X_train_and_test_mean_std)
		# Learning:
		# X_train_and_test_mean_std <- cbind.data.frame(X_train_and_test$subject, X_train_and_test$activity, X_train_and_test$type, X_train_and_test_mean_std)
		# sorgt dafür, dass die colnames der ersten drei Spalten noch den Namen des ursprünglichen DFs beinhalten (z.B. X_train_and_test$subject)
	
	
	print("naming activities ...")
	# replace activity ids by descriptive activity names
	X_train_and_test_mean_std_new <- merge.data.frame(x = X_train_and_test_mean_std, y = activity_labels, by.x = "activity_id", by.y = "id")
	new_ordered_colnames <- colnames(X_train_and_test_mean_std_new)[c(ncol(X_train_and_test_mean_std_new), 2, 3:(ncol(X_train_and_test_mean_std_new)-1))]
	X_train_and_test_mean_std <- X_train_and_test_mean_std_new[,new_ordered_colnames]
	rm(X_train_and_test_mean_std_new)
	
	
	print("creating new data set ...")	
	# create a second, independent tidy data set with the average of each variable for each activity and each subject.
	grouped_X_data <- group_by(X_train_and_test_mean_std, activity, subject)
	mean_X_data <- summarize_all(grouped_X_data, .funs = mean)
	
	
	print("writing data sets ...")
	# write data sets to csv files
	write.table(X_train_and_test_mean_std, file = "activity_measurements.csv", row.names = FALSE)
	write.table(mean_X_data, file = "activity_measurements_mean.csv", row.names = FALSE)
	
	
	print("done.")
}