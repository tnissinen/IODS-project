# Tomi Nissinen, 8.11.2019, data wrangling exercise

# accessing the dplyr library
library(dplyr)

# read the dataset
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# structure of the data (all integers except gender that is "F"/"M")
str(lrn14)

# dimensions of the data (seems to have 183 observations and 60 variables)
dim(lrn14)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# filter to only have rows with points > 0
lrn14 <- filter(lrn14, Points > 0)

# keep only some columns
lrn14 <- select(lrn14, one_of(c("gender","Age","Attitude", "deep", "stra", "surf", "Points")))

# set working directory
setwd("C:/Users/tomni/Documents/IODS-project")

# write to csv file
write.csv(lrn14, "data/learning2014.csv")

# read from csv file
lrn14_from_file <- read.csv("data/learning2014.csv")

# check that data is valid
head(lrn14_from_file)
