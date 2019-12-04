# Tomi Nissinen, 4.12.2019, data wrangling exercise
# Datasets from
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt


#############
# Exercise 6:
#############

library(dplyr)
library(tidyr)

# Read the 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# structure of the data
# Look at the (column) names
names(BPRS)
names(RATS)

# Look at the structure of BPRS
str(BPRS)
str(RATS)

# Print out summaries of the variables
summary(BPRS)
summary(RATS)

# We see that the weeks and times in the datasets are in different columns (wide form)


# Factor BPRS treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Convert BPRS to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# We now see that for each treatment and subject we have the different weeks as separate rows (wide form). 
# The week number is in one column.



# Factor variables ID and Group
# Factor treatment & subject
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert data to long form and extract the time
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4))) 

# Glimpse the data
glimpse(RATSL)

# We now see that for each id and group we have the different times as separate rows (wide form).
# The time is in one column.

# write formatted sets to csv files
write.csv(RATSL, "data/rats_long.csv")
write.csv(BPRSL, "data/bprs_long.csv")
