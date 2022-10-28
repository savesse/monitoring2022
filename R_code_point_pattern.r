# point pattern analysis for population ecology

# we want to make use of the covid_agg file: use of working directory

setwd("C:/lab/")

# now I can upload every tipe of file from that working directory
# we reuse the read.table() function

read.table("covid_agg.csv", header=T)

# so now we have our file inside R

covid <- read.table("covid_agg.csv", header=T)
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

# SEE ON VIRTUALE CODE also without attaching is possible to do it

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

# today we r gonna use also rgdal

library(spatstat)
library(rgdal)

# rgdal is the version or gdal (geo spatial data library) of R
# we are going to use ne_10m_coastline.zipFile data on virtuale
# we then set our working directory in the lab folder

setwd("C:/lab/")

# we are going to upload the coastal lines and we put our name to it

coastlines <- readOGR("ne_10m_coastline.shp")
coastlines

# the data are forming polygons
# we want to rebiuld the map of yesterday

covid <- read.table("covid_agg.csv", header=T)
head(covid)
attach(covid)
covid_planar <- ppp(lon, lat, c(-180,180), c(-90,90))
plot(covid_planar)

# now we can add the coastlines to the previous plot
# the other argument is add=T (T is true), always useful to add stuff to plots

plot(covid_planar)
plot(coastlines, add=T)

# now we have the union of them and we want the map of yesterday

density_map <- density(covid_planar)
plot(density_map)
points(covid_planar)
cl <- colorRampPalette(c('bisque','azure','brown'))(100)
plot(density_map, col=cl)

head(covid)
covid

# we want to interpulate the number of cases 
# we have point data and we want to have informations about where we didn't have data
# in order to do this we can interpulate, and we explain which variable we want to process
# we are marking the points with the number of cases 

attach(covid)
marks(covid_planar) <- cases
cases_map <- Smooth(covid_planar)

# warning bc of the number of points

plot(cases_map, col=cl)
plot(coastlines, add=T)

# now we can understand this map including what we didn't know before











