# In this project I tried to study the evolution during time of snow cover in the region between Trentino Altro Adige, Veneto and the border with Austria
# The period considered is between the year 2000 nd the year 2020
# The snow present in this area can be collocated on the mountain groups of pre-Alps and Alps (so called Dolomites) present in that area
# I chose that area because I come from Veneto and I spent a lot of time on those mountains and I care pretty much about them
# In order to get the images I used Google Earth Engine
# Fisrt of all I had to build a code with the necessary parameters so I could get the images in which I was intrested in
# Following now there will be the code used, obtained from the Google Earth Engine's guides and from some forums on the website

# GOOGLE EARTH ENGINE CODE
# The first thing to specify is the area, so I proceeded to draw a rectangle including the area I wanted to consider
# The rectangle is defined by four points with the following coordinates
# 1: [12.780909262125903,45.44974637731209]
# 2: [12.780909262125903,47.14977329138755]
# 3: [10.715479574625903,47.14977329138755]
# 4: [10.715479574625903,45.44974637731209]

Imports (1 entry)     # referred to the geometry selected
var geometry: Polygon, 4 vertices       # the variable considered is the geometry, which is a polygon defined by the four points of before
coordinates: List (1 element)         # the list of the 4 groups of coordinates
geodesic: false

var dataset = ee.ImageCollection('MODIS/006/MOD10A1')                         # we are considering the images coming from MODIS, an instrument onboard a satellite
                  .filter(ee.Filter.date('2020-01-01', '2020-12-31'));        # we set the time period in which we are intrested, so the single year
var snowCover = dataset.select('NDSI_Snow_Cover');                            # as a variable we have the snowCover, which is considering the NDSI dataset
                                                                              # NDSI (normalized difference snow index), useful for the snow and ice
var snowCoverVis = {
  min: 0.0,
  max: 100.0,
  palette: ['black', '0dffff', '0524ff', 'ffffff'],
};                                                    # we have also the visualization of the NDSI throughout the snowCoverVis with its palette

print('snowCover', snowCover)                 # that's the variable in which we are intrested in

Map.setCenter(11.65, 46.386, 6);              # this is useful in Google Earth Engine to set the centre of the map in a point of our preference
Map.addLayer(snowCover, snowCoverVis, 'Snow Cover');       # these are the layers present in our map


// Export a cloud-optimized GeoTIFF.          # we also need to export this file as a GeoTIFF
Export.image.toDrive({                          # we do it in the drive
  image: snowCover.select('NDSI_Snow_Cover').mean(),    # we want the mean of the year for what regards the snow cover
  description: 'snowCover Mar 2020',          # this is the name given to the GeoTIFF
  scale: 30,                              # this is the resolution of the scale
  region: geometry,                     # this is the region which is going to be exported, so our geometry
  fileFormat: 'GeoTIFF',              # the format
  formatOptions: {
    cloudOptimized: true            # we want to optimize the images without considering the images with a lot of clouds
  }
});

# Normalized Difference Snow Index (NDSI) is used to delineate the presence of snow/ice
# It is a standardized ratio of the difference in the reflectance in the bands that take
# advantage of unique signature and the spectral difference to indicate snow from the surrounding features and even clouds.
# Once I got the GeoTIFF files I was able to download them and to visualize them in QGIS
# Then I started my analysis in R

# I start with setting the working directory on the folder inside my laptop
setwd("C:/project/")
# I can also inspect what I can find inside it
dir()
# now I recall all the libraries that I will need throughout the project
library(raster)     # useful for importing raster
library(ggplot2)    # useful for graphs
library(RStoolbox)    # useful for graphs analysis
library(viridis)      # useful fro graphic representations
# I can start to import the first image to see if everything is working
# In order to use this I can use the raster function
# I can assign the result to an object through the <- operator
snow_2000 <- raster("snow_cover_2000.tif")
# now I can inspect the first image
snow_2000
# I can see all the followings features of the dataset
# class      : RasterLayer 
# dimensions : 6309, 7665, 48358485  (nrow, ncol, ncell)
# resolution : 0.0002694946, 0.0002694946  (x, y)
# extent     : 10.71537, 12.78105, 45.44972, 47.14996  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# source     : snow_cover_2000.tif 
# names      : NDSI_Snow_Cover 

# I can proceed with plotting the image through ggplot()
# I want to fill the image with the NDSI index
# since it's a raster file I can use x=x and y=y
ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover ))
# I can immediately see the distribution of ice and snow in the area considered
# in dark blue there are the parts without snow or ice coverage
# in light blue/azure there are the parts characterized by snow and ice
# then I can experiment different colors
ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover )) + scale_fill_viridis()
ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover)) + scale_fill_viridis(option="magma")
# I can also add a title
ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover)) + scale_fill_viridis(option="magma", direction=1) + ggtitle("Snow Cover")
# and add the titles of the x and the y axis
ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover 2000")+ xlab("Lat")+ ylab("Lon")
# now I should assign all the plot to an object, in order to recall it very fast
p_2000 <-
  ggplot() + geom_raster(snow_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover 2000")+ xlab("Lon")+ ylab("Lat")
p_2000

# now I can do this for every single image like it follows

snow_2002 <- raster("snow_cover_2002.tif")
snow_2002
p_2002 <-
  ggplot() + geom_raster(snow_2002, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover 2002")+ xlab("Lat")+ ylab("Lon")
p_2002

snow_2004 <- raster("snow_cover_2004.tif")
snow_2004
p_2004 <-
  ggplot() + geom_raster(snow_2004, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover 2004")+ xlab("Lat")+ ylab("Lon")
p_2004

snow_2020 <- raster("snow_cover_2020.tif")
snow_2020
p_2020 <-
  ggplot() + geom_raster(snow_2020, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover 2020")+ xlab("Lat")+ ylab("Lon")
p_2020

dif = snow_2000 - snow_2020
d_20y <- ggplot() + geom_raster(dif, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno", direction=-1, alpha=0.8) + ggtitle("Snow Dif")
d_20y




dif4 = snow_2004 - snow_2020
d_16y <- ggplot() + geom_raster(dif4, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno", direction=-1, alpha=0.8) + ggtitle("Snow Dif")
d_16y

# but since we have 12 images, we prefer to import all the images at the same time
# we want to import all the images together so we don't waste time
# first I named all the images in the same way: snow_coverage_year
# we should use the lapply function, which is applying a function to a list or a vector
# first we need to make the list of files including the world 'snow'

rlist <- list.files(pattern="snow")
# it's gonna consider all the names which include the world snow
rlist
# we see all the GeoTIFF files considered, so all in which we are interested in
# we apply the raster function to all the set of images
lapply(rlist, raster)
# and we import them in R
import <- lapply(rlist, raster)
# another important function is stack(), which is going to create stacks
SCD <- stack(import)
# SCD = Snow Coverage of Dolomites
SCD
plot(SCD)

# when I want to recall only certain images of a set I should find or the same words in all the images
# or I can write something more for every image I will need in the analysis

































