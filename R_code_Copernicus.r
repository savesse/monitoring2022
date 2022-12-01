# how to download and analyse Copernicus data

setwd("C:/lab/")
install.packages("ncdf4")
library(ncdf4)  # used for reading .nc files
library(raster)   
library(ggplot2)    # plots; with ratser data I have to use ggplot2 and RStoolbox
library(RStoolbox)   # remote sensing functions
library(viridis)    # legends
library(patchwork)   # multiframe for ggplot

# the function brick() takes something outside R in R
# if I want only one layer we should use the raster() function with ""
# I can import data one layer per type
# the file we will use is from NOAA, like NASA but about oceanic data

snow <- raster("c_gls_SCE_202012210000_NHEMI_VIIRS_V1.0.1.nc")
snow

# we are dealing with one layer with more than 200000000 pixels
# the resolution is in degrees, we are WGS84
# the layer inside the snow object is called Snow.Cover.Extent

# Exercise based on plotting the snow cover with ggplot and viridis
ggplot() + geom_raster(snow, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="brewer blues")
# we have to put the layer Snow.Cover.Extent
# as fill we should never use turbo, or rainbow colors
# depending on the resolution we are using we might have lower or higher pixels
# in copernicus website we also have the 500m resolution data (we used the 1km one), the resolution is better

# in our image the upper part isn't rapresented because it doesn't have data available
# if we want only the european data we can zoom and crop the image
# one way is to draw a rectangle (extent): we should not use it, because we can't dra the same rectangle again
# we should use the object ext and the minimum x and y and the maximum x and y
# first the two x, then the two y
# this is in order to have a new extent

ext <- c(-20, 70, 20, 75)
# then we can use crop() in order to cut the image
snow_Europe <- crop(snow, ext)
ggplot() + geom_raster(snow_Europe, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="brewer blues")

# we have the data in december, we can download the data from the same period the year before to compare them

# let's plot things together
# plot the two sets with the patchwork() 

p_tot <- ggplot() + geom_raster(snow, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="mako")
p_EU <- ggplot() + geom_raster(snow_Europe, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="mako")
p_tot + p_EU
p_tot / p_EU

