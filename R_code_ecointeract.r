# This is a code for investigating relationships among ecological variables

# sp package usage with function install.packages("sp"), here with "" bc we are going out of R for reaching that package; once it's installed I can avoid ""
# install.packages(sp)
library(sp)
# require() has the same functioning of library(), there are some differences but for us will be the same

# we are going to use "meuse package": https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf

# for recalling the dataset we use data()
# in this case we want the meuse dataset

data(meuse)

# meuse here is the object connected to the data
# we can tipe "meuse" for looking at the dataset in R: its dataframe (x,y, amount of cadmium, of copper, of lead and zinc, etc...)
# there are functions for seeing the table of the dataset
# one is calling a data viewer: View() (Capital letter here)

View(meuse)

# the function dev.off() can close plotting device in order to delete errors

# the function head(x,...) returns the first or last parto of an object: shows the head of something

head(meuse)
# with meuse we have the first 6 raws

# another function showing only coloumns names: names(): very fast idea of what there is in the dataset

names(meuse)

# for calculating the mean, median, quartiles of a field we can use: summary()

summary(meuse)

# now if we want to use plot() we have to tell r what to plot

plot(cadmium,zinc)

# here we have an error, bc the fields are not simple objects, they are objects hidden inside a teble, they are not free
# we have to tell R that those are objects of meuse: link cadmium and zinc to meuse
# we can do that with: $ 

plot(meuse$cadmium,meuse$zinc)

# if I don't want to have all of these words in the plot, I want to summarize
# I can assign meuse$cadmium to whaever name

cad<-meuse$cadmium
zin<-meuse$zinc
# then I can plot
plot(cad,zin)

# we can also use only dataframe: we can attach meuse to the table with attach() to directly use the names of coloumns

attach(meuse)         # with this we attached the data frame: we can use the proper coloumn names

# I can also detach: detach(meuse)
# I want to see the relationships between all variables present we can use a function: pairs()

pairs(meuse)

# 17.10.2022
# first we need to recall the library
library(sp)
# we are still going to use (meuse)
data(meuse)
# doing all operations seen before on graphs, cex, col, pairs

# now we want to use the function pairs() but for subsets, not all the variables, we can use the interval; e.g. 3:6
# we want cadmium, copper, lead and zinc, from coloumn 3 to 6
# fro telling r the starting point of the selection we usse the comma; ,
pairs(meuse[,3:6])
# let's put together these under an object
pol <- meuse[,3:6]
# and now we can pairs pol
pairs(pol)
# if we want to pair only some variables without them being one next to the other or in general
# here we will need the simbol ~ (alt+0126), we need something to take the variables together, the tilde
pairs(~cadmium+copper+lead+zinc,data=meuse)
pairs(~cadmium+copper+lead+zinc, data=meuse)
pairs(~cadmium+copper+lead+zinc, data=meuse, col="darkgoldenrod2")
pairs(~cadmium+copper+lead+zinc, data=meuse, col="darkgoldenrod2",pch=17,cex=3)







