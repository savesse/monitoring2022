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













