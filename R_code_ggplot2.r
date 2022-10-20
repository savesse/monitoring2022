# first we r gonn install the package
# this package is useful for graphic representations

install.packages("ggpllot2")
library(ggplot2)

# we are gong to construct the dataframe, to make a table with 2 variables
# we want to talk about the virus spread: we invent an array of values
# we invent both the virus and the deaths, we don't use a predone dataset

virus <- c(10, 30, 40, 50, 60, 80)
death <- c(100, 240, 310, 470, 580, 690)

plot(virus, death)
plot(virus, death, pch=19,cex=2)
# we have a plot of the relationship between virus and deaths

# we can build a real table with the data from virus and death
# the table in R is a datframe (data.frame function)

data.frame(virus, death)

# with this we reated the dataframe: a table with 2 coloumns
# we can assign this dataframe to an object, and then we can use the object

d <- data.frame(virus, death)
d

summary(d)
# we can have all the measure of the object assigned to the dataframe

# we are going to use the function ggplot(), where we usa data and mapping
# the data are based on the dataframe (data will be d)
# aes means aesthetics: which aesthetic of the graph we want, so which are the variables
# important to put spaces or not always in the same way
# then we have to explain the geometry we want to use; in this situation we want points
# for seeing points we can use geom_point and we can add it outside parenthesis with a +
# with geom_point we are adding only the geometry of the plot

ggplot(d, aes(x=virus, y=death)) + geom_point()

# here we can add derectly insidde of geom_point what we want to see in the grap, size and colour, symbol

ggplot(d, aes(x=virus, y=death)) + geom_point(size=3, col="darkred")
ggplot(d, aes(x=virus, y=death)) + geom_point(size=5, col="coral", pch=17)

# we can use also areas, lines or whatever we want

ggplot(d, aes(x=virus, y=death)) + geom_line()
ggplot(d, aes(x=virus, y=death)) + geom_line() + geom_point()
ggplot(d, aes(x=virus, y=death)) + geom_polygon()

# we can join various geometries together
# for all geometries we can choose different colours, sizes, symbols




