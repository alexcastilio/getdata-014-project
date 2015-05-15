run_analysis <- function(){
  
  #####################################################
  # 1. Merge the training and the test sets
  #####################################################
  
  install.packages("data.table")
  install.packages("LaF")
  
  library(data.table)
  library(LaF)
  
  col_names <- read.table(file="./features.txt",header = F, sep = " ",colClasses = c("integer","character"))
  col_names <- col_names[2]
  
  #Create conection to Fixed Width File
  train_data <- laf_open_fwf(filename = "./train/X_train.txt",
                             column_types = rep("numeric",dim(col_names)[1]),
                             column_widths = rep(16,dim(col_names)[1]),
                             column_names=c(col_names),trim = T)
  
  #Get data from file
  train_data<-train_data[,]
  
  
  
  #train_data <- read.fwf(file = "./data/train/X_train.txt",sep = " ",widths = c(16,rep(15,dim(col_names)[1]-1)),header = F,col.names = col_names)
  #train_data <- read.table(file = "./data/train/X_train.txt",header = F, sep = " ", col.names = col_names,colClasses = "numeric",na.strings = "N/A")
  
  #train_data <- data.frame()
  
  
  #Extract only the measurements on the mean and standard deviation
  #for each measurement
  
  
  
}