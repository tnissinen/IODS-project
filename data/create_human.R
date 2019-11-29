# Tomi Nissinen, 22.11.2019, data wrangling exercise
# Dataset from http://hdr.undp.org/en/content/human-development-index-hdi

#############
# Exercise 4:
#############

library(dplyr)


# Read the “Human development” and “Gender inequality” datas from csv files
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# structure of the data
str(hd)
str(gii)

# dimensions of the mat data (seems to have 395 observations and 33 variables)
dim(hd)

# dimensions of the por data (seems to have 649 observations and 33 variables)
dim(gii)

# take a glimpse of the datasets 
glimpse(hd)
glimpse(gii)

colnames(gii)
gii <- rename(gii,
       edu2F = Population.with.Secondary.Education..Female.,
       edu2M = Population.with.Secondary.Education..Male.,
       labF = Labour.Force.Participation.Rate..Female.,
       labM = Labour.Force.Participation.Rate..Male.
)
colnames(gii)
gii <- mutate(gii, edu2F_edu2M_ratio = edu2F / edu2M)
gii <- mutate(gii, edu2F_edu2M_ratio = labF / labM)

# common columns to use as identifiers
#join_by <- c("Country", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# join the datasets
hd_gii <- inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))
glimpse(human)


# create a new data frame with only the joined columns
human <- select(hd_gii, "Country")

# columns not used for joining
notjoined_columns <- colnames(hd_gii)[!colnames(hd_gii) %in% c("Country")]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'hd_gii' with the same original name
  two_columns <- select(hd_gii, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  #if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    #alc[column_name] <- round(rowMeans(two_columns))
  #} else { # else if it's not numeric...
    # add the first column vector to the alc data frame
  human[column_name] <- first_column
  #}
}

# take a glimpse of the completed dataset 
glimpse(human)

# set working directory
setwd("C:/Users/tomni/Documents/IODS-project")

# write to csv file
write.csv(human, "data/human.csv", row.names = FALSE)


#############
# Exercise 5:
#############

library(stringr)

# my previous data wrangling exercise was not perfect so I load the downloaded human1.txt file
human <- read.table("data/human1.txt", sep  =",", header = T)

# look at the (column) names of human
names(human)

  # look at the structure of human
  str(human)

# print out summaries of the variables
summary(human)

# check last few rows
tail(human)

# mutate GNI to numeric
human <- mutate(human, GNI = as.numeric(str_replace(GNI, pattern=",", replace ="")))

# check the tail again with some more rows
tail(human, 20)

# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(human, one_of(keep))

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human <- filter(human, complete.cases(human))

# select only the country rows and not regions
human <- human[1:155, ]

# set Country as row name
rownames(human) <- human$Country

# remove the Country variable
human <- select(human, -Country)

# check structure again
str(human)

# check tail again
tail(human, 60)

# write to csv file
write.csv(human, "data/human.csv")

