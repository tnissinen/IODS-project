# Tomi Nissinen, 14.11.2019, data wrangling exercise
# Dataset from https://archive.ics.uci.edu/ml/datasets/Student+Performance
library(dplyr)

# read the datasets from csv files
student_mat <- read.csv("data/student-mat.csv", sep = ";", header = TRUE)
student_por <- read.csv("data/student-por.csv", sep = ";", header = TRUE)

# structure of the data
str(student_mat)
str(student_por)

# dimensions of the mat data (seems to have 395 observations and 33 variables)
dim(student_mat)

# dimensions of the por data (seems to have 649 observations and 33 variables)
dim(student_por)

# take a glimpse of the datasets 
glimpse(student_mat)
glimpse(student_por)

# common columns to use as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# join the datasets
math_por <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

# take a glimpse of the joined dataset 
glimpse(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# columns not used for joining
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

# take a glimpse of the completed dataset 
glimpse(alc)

# set working directory
setwd("C:/Users/tomni/Documents/IODS-project")

# write to csv file
write.csv(alc, "data/alc.csv", row.names = FALSE)

