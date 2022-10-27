# point pattern analysis for population ecology

# we want to make use of the covid_agg file: use of working directory

setwd("C:/lab/")

# now I can upload every tipe of file from that working directory
# we reuse the read.table() function

read.table("covid_agg.csv", header=T)

# so now we have our file inside R

covid <- read.table("covid_agg.csv")
head(covid)

# we already plotted everything in the previous lesson
# now we need to use spatstat: we can use that to pass from simple points, to curves, densities and othera
# we are interpolating points

library(spatstat)

# we need to explain that we have coordinates and we want to use them in the planar point pattern (ppp)
# we have to explain our coordinates
# we have to explain our longitude and latitude: longitude from -180 to 180, so all over the world, latitude from -90 to 90
# we want also to assign an object to the function
# we attach covid dataset

attach(covid)
covid_planar <- ppp(lon, lat, c(-180,180), c(-90,90))

# SEE ON VIRTUALE CODE

density_map <- density(covid_planar)

plot(density_map)
points(covid_planar)

# with the function points we can add points to the density map in order to see them both
# the highest density is in EU, bc there are several countries with one point per country
# we can also change the legend and so the colors
# the 100 mean 100 different colors for passing from one color to the other

cl <- colorRampPalette(c('yellow','orange','red'))(100) #
cl <- colorRampPalette(c('cyan','coral','chartreuse'))(100)
plot (density_map, col=cl)
points(covid_planar, pch=17, col="blue")






