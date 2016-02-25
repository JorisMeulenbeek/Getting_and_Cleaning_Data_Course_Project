##load packages
require("data.table"); 
require("reshape2") ;

##set working directory
setwd('/Users/Joris/Documents/Getting_data_eindproject');

##Load files 
activity_labels <- read.table('./activity_labels.txt',header=FALSE)[,2];   
features <- read.table('./features.txt',header=FALSE)[,2];  
x_test <- read.table('./x_test.txt',header=FALSE);
y_test <- read.table('./y_test.txt',header=FALSE); 
subject_test <- read.table('./subject_test.txt',header=FALSE); 
x_train <- read.table('./x_train.txt',header=FALSE); 
y_train <- read.table('./y_train.txt',header=FALSE); 
subject_train <- read.table('./subject_train.txt',header=FALSE);

##Extract measurements mean or std 
extract_features <- grepl("mean|std", features); 
names(x_test) = features;
x_test = x_test[,extract_features]; 

##Set labels 
y_test[,2] = activity_labels[y_test[,1]] ;
names(y_test) = c("Activity_ID", "Activity_Label"); 
names(subject_test) = "subject" ;

##Combine files 
test <- cbind(as.data.table(subject_test), y_test, x_test); 

##Set labels 
names(x_train) = features; 

##Extract measurements mean or std
x_train = x_train[,extract_features]; 

##Set labels 
y_train[,2] = activity_labels[y_train[,1]]; 
names(y_train) = c("Activity_ID", "Activity_Label"); 
names(subject_train) = "subject" ;

##Combine files 
trein <- cbind(as.data.table(subject_train), y_train, x_train); 

##Merge data 
alle_data  = rbind(test, trein); 

kolommen = c("subject", "Activity_ID", "Activity_Label"); 
kolommen_data = setdiff(colnames(alle_data), kolommen) ;
samenvoeg = melt(alle_data, id = kolommen, measure.vars = kolommen_data) ;

##Mean function data 
totaal_data = dcast(samenvoeg, subject + Activity_Label ~ variable, mean); 

##create file
write.table(totaal_data, row.name=FALSE ,file = "./tidy_data.txt")