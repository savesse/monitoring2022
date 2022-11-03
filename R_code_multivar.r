# community ecology examples with R using multivariate analysis

install.packages("vegan")

library(vegan)

# this package is based on vegtation analysis

setwd("C:/lab/")

# we need to download the data from virtuale called 'biomes_multivar.RData'
# in the past we used read.table in order to read data but in this we are importing an R project
# we need another function: load(""); this reload saved datasets of R projects
# the lab folder is outside R so we need ""

load("biomes_multivar.RData")

# now with ls() function we can see files inside R

ls()

# we want to look at the biomes table

biomes
head(biomes)

# we are looking a matrix of plots (1,2,3,4,5,6) and species (names)
# in total we have 20 plots, we can't see 20 dimensions, we need to sqeeze them

ls()

# we see also biomes types: plots and the label of the biome

biomes_types

# we are going to use detrended correspondence analysis: decorana
# we are passing to a lower amount of axes
# we give also the name of object assigned

multivar <- decorana(biomes)
multivar

# we can see the explanation about the analysis done with decorana
# different axes are explaining different percentages of variance (DCA1, DCA2, ...)

plot(multivar)

# we have all of the previous plots squeezed in two axes
# red colubus (is a monkey) related to giant orb and tree fern: I suspect the tropical forest is in this part
# all the dimensions of before are now only in two of them
# we want to see all the different biomes in the plot: a circle taking all the plots in the same biome
# we can to this bc in the table we have labels in the biomes_type

attach(biomes_types)
# we explain we want to use that table so we attaach it

# we want to odrinate data

ordiellipse(multivar, type, col=c("black","red","green","blue"), kind = "ehull", lwd=3)

# multivar is data we are using; type means the type of biome; then we have colors
# the kind is about the ellipse; lwd is ?
# look better to the explanation of the function

# so we see ellipses trying to connect the plots from the same biome together



















