run_analysis <- function(){
  
  #####################################################
  # 1. Merge the training and the test sets
  #####################################################
  
  install.packages("data.table")
  install.packages("LaF")
  install.packages("dplyr")
  
  library(data.table)
  library(LaF)
  library(dplyr)
  library(reshape2)
  
  col_names <- read.table(file="data/features.txt",header = F, sep = " ",colClasses = c("integer","character"))
  col_names <- eval(parse(text = as.character(col_names[2])))
  
  #Create conection to Fixed Width File X_train.txt
  data_con <- laf_open_fwf(filename = "data/train/X_train.txt",
                             column_types = rep("numeric",length(col_names)),
                             column_widths = rep(16,length(col_names)),
                             column_names = col_names,
                             trim = T)
  
  #Get data from file X_train.txt
  train_data<-data_con[,]
  
  #Close Connection to X_train.txt
  close(data_con)
  
  #Read y_train.txt
  y_train <- read.csv("data/train/y_train.txt",header = F,colClasses="numeric")
  
  #Read subject_train.txt
  subject_train <- read.csv("data/train/subject_train.txt",header = F,colClasses="numeric")
  
  #Merges y_train and subject_train with train_data
  train_data<-mutate(train_data,y=as.integer(unlist(y_train)))
  train_data<-mutate(train_data,subject=as.integer(unlist(subject_train)))
  
  #Create conection to Fixed Width File X_test.txt
  data_con <- laf_open_fwf(filename = "data/test/X_test.txt",
                                 column_types = rep("numeric",length(col_names)),
                                 column_widths = rep(16,length(col_names)),
                                 column_names = col_names,
                                 trim = T)
  
  #Get data from file X_test.txt
  test_data<-data_con[,]
  
  #Close Connection to X_test.txt
  close(data_con)
  
  #Read y_test.txt
  y_test <- read.csv("data/test/y_test.txt",header = F,colClasses="numeric")
  
  #Read subject_test.txt
  subject_test <- read.csv("data/test/subject_test.txt",header = F,colClasses="numeric")
  
  #Merges y_test and subject_tset with test_data
  test_data<-mutate(test_data,y=as.integer(unlist(y_test)))
  test_data<-mutate(test_data,subject=as.integer(unlist(subject_test)))
  
  #Merge data sets
  full_data<-rbind(train_data,test_data)
  
  #####################################################
  # 2. Extracts only the measurements on the mean and standard deviation for each measurement
  #####################################################
  
  #Mean
  mean_data <- lapply(full_data,mean)
  
  #Std dev
  std_dev_data <- lapply(full_data,sd)
  
  #####################################################
  # 3. Uses descriptive activity names to name the activities in the data set
  # 4. Appropriately labels the data set with descriptive variable names
  #####################################################
  
  #Read activity_labels.txt
  activity_labels <- read.table("data/activity_labels.txt",header = F,colClasses=c("integer","character"))
  activity_labels <- activity_labels[2]
  
  #Create new column describing activity
  full_data<-mutate(full_data,activity=activity_labels$V2[y])
  
  #####################################################
  # 5. From the data set in step 4, creates a second, independent tidy data set 
  #    with the average of each variable for each activity and each subject.
  #####################################################
  
  final_data <- full_data %>% group_by(activity,subject) %>% summarise_each(funs(mean))
  final_data <- as.data.frame(final_data)
}