# Tomi Nissinen, 8.11.2019, data analysis exercise

# read the dataset
#lrn14 <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/learning2014.txt", sep=",", header=TRUE)

lrn14 <- read.csv("data/learning2014.csv")

# structure of the data (all integers except gender that is "F"/"M")
str(lrn14)

# dimensions of the data (seems to have 183 observations and 60 variables)
dim(lrn14)

pairs(lrn14)

# fit a linear model
my_model <- lm(Points ~ Attitude + Age + gender, data = lrn14)

# print out a summary of the model
summary(my_model)

my_model <- lm(Points ~ Attitude, data = lrn14)
summary(my_model)

par(mfrow = c(2,2))
# draw diagnostic plots using the plot() function. Choose the plots 1, 2 and 5
plot(my_model, which=c(1,2,5))


library(ggplot2)
qplot(Attitude, Points, data = lrn14) + geom_smooth(method = "lm")
#qplot(Age, Points, data = lrn14) + geom_smooth(method = "lm")