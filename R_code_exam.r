# In this project I tried to study the evolution during time of snow cover firstly in the region between Trentino Altro Adige, Veneto and the border with Austria
# which is nearer to my home and where I spent more time during my life
# Afterwards I thought it was better to consider the area of all the Alps in order to understand if there was a general trend
# The period considered is between the year 2000 nd the year 2022
# The snow present in this area can be collocated on the mountain groups of pre-Alps (more little mountains before the real Alps) and Alps present in that area
# I chose this tpic nd area because I spent a lot of time on those mountains and I care pretty much about them
# In order to get the images I used Google Earth Engine
# Fisrt of all I had to build a code with the necessary parameters so I could get the images in which I was intrested in
# Following now there will be the code used, obtained from the Google Earth Engine's guides, from some forums on the website and from my trials

# GOOGLE EARTH ENGINE CODE
# The first thing to specify is the area, so I proceeded to draw a rectangle including the area I wanted to consider
# The rectangle is defined by four points with the following coordinates
# 1: [5.1783701996259035, 48.156210877606746],
# 2: [5.1783701996259035, 43.79213363926916],
# 3: [16.340479574625903, 43.79213363926916],
# 4: [16.340479574625903, 48.156210877606746]

# As for the time period I considered two seasons: summer and winter
# The summer was considered between 21.06 and 01.09 in order to have the negative peak of snow presence
# The winter was considered from 01.11 to 31.03: a wider interval than the real winter because I wanted to take in consideration
# also the first significant snowy precipitations of the year

# Follows the code used on google earth engine:
Imports (1 entry)     # referred to the geometry selected
var geometry: Polygon, 4 vertices       # the variable considered is the geometry, which is a polygon defined by the four points of before
coordinates: List (1 element)         # the list of the 4 groups of coordinates
geodesic: false

var dataset = ee.ImageCollection('MODIS/006/MOD10A1')                         # we are considering the images coming from MODIS, an instrument onboard a satellite
                                                                              # in particular the collection is the Snow Cover Daily L3 Global 500m Grid
                  .filter(ee.Filter.date('1999-11-01', '2000-03-31'));        # we set the time period in which we are intrested, so the season of the year
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
  image: snowCover.select('NDSI_Snow_Cover').mean(),    # we want the mean of the season for what regards the snow cover
  description: 'snow_cover_mar_2020',          # this is the name given to the GeoTIFF
  scale: 250,                              # this is the resolution of the scale
  region: geometry,                     # this is the region which is going to be exported, so our geometry
  fileFormat: 'GeoTIFF',              # the type of file exported
  formatOptions: {
    cloudOptimized: true            # we want to optimize the images without considering the images with a lot of clouds
  }
});

# Normalized Difference Snow Index (NDSI) is used to delineate the presence of snow/ice
# It is a standardized ratio of the difference in the reflectance in the bands that take
# advantage of unique signature and the spectral difference to indicate snow from the surrounding features and even clouds
# It is the normalized difference between spectral bands green (G) and the shortwave infrared (SWIR)
# The NDSI is particularly useful for separating snow from vegetation, soils, and lithology endmembers
# Once I got the GeoTIFF files I was able to download them and to visualize them in QGIS to be sure that everything was working
# Then I started my analysis in R

# I start with setting the working directory on the folder inside my laptop
setwd("C:/project/")
# I can also inspect what I can find inside it
dir()
# now I recall the libraries that I will need throughout the project
library(raster)     # useful for importing raster
library(ggplot2)    # useful for graphs
library(RStoolbox)    # useful for graphs analysis
library(viridis)      # useful fro graphic representations

# I can start to import the first image to see if everything is working
# In order to use this I can use the raster function
# I can assign the result to an object through the <- operator
# I should use names which are related to the actual image
# I start with the image considering summer in the year 2000
snow_est_2000 <- raster("snow_cover_est_2000.tif")

# now I can inspect the first image
snow_est_2000
# class      : RasterLayer 
# dimensions : 1389, 3551, 4932339  (nrow, ncol, ncell)
# resolution : 0.003144103, 0.003144103  (x, y)
# extent     : 5.178338, 16.34305, 43.79107, 48.15823  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# source     : snow_cover_est_2000.tif 
# names      : NDSI_Snow_Cover

# I'm not able to simply plot the image because the figure margins are too large
# I can proceed with plotting the image through ggplot()
# I want to fill the image with the NDSI index
# since it's a raster file I can use x=x and y=y
# x represents the latitude while y the longitude
ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover ))
# I can immediately see the distribution of ice and snow in the area considered
# in dark blue there are the parts without snow or ice coverage
# in light blue/azure there are the parts characterized by snow and ice
# in this particular image I can see that there is a little amount of snow and ice
# this image is representing the summer time

# then I can experiment different colors using the viridis library
ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover )) + scale_fill_viridis()
ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover)) + scale_fill_viridis(option="mako")
# I can also add a title
ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover)) + scale_fill_viridis(option="mako", direction=1) + ggtitle("Snow Cover Summer 2000")
# and add the titles of the x and the y axis
ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2000")+ xlab("Lat")+ ylab("Lon")
# now I should assign the plot to an object, in order to recall it very fast
s_2000 <-
  ggplot() + geom_raster(snow_est_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2000")+ xlab("Lon")+ ylab("Lat")
s_2000

# I can try to see the difference between the summer and the winter of the same year
# I go with the same procedure
snow_inv_2000 <- raster("snow_cover_inv_2000.tif")
snow_inv_2000
w_2000 <-
  ggplot() + geom_raster(snow_inv_2000, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Winter 2000")+ xlab("Lon")+ ylab("Lat")
w_2000
# I can see a huge difference since this one is considering winter time
# a lot of the area considered is represented in white or in light blue
# this means that there is a lot of snow/ice

# I can't use par(mfrow=c(2,1)) because the figure margins are too large

# I want to do the same for 2022
snow_est_2022 <- raster("snow_cover_est_2022.tif")
snow_est_2022
s_2022 <-
  ggplot() + geom_raster(snow_est_2022, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2000")+ xlab("Lon")+ ylab("Lat")
s_2022
# I can see that in summer in 2022 there was a very little amount of snow/ice
# I compare it to the 2000 and I can see still a big difference
s_2000
s_2022

# let's try with the winter
snow_inv_2022 <- raster("snow_cover_inv_2022.tif")
snow_inv_2022
w_2022 <-
  ggplot() + geom_raster(snow_inv_2022, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Winter 2022")+ xlab("Lon")+ ylab("Lat")
w_2022
# in 2022 we can actually observe a pretty important amount of snow ice

# now I try to compare the year 2000 with the year 2022
# I want to have the sum of the amount of snow in summer and winter, for 2000 and for 2022, so I use simply the +
sum_22 <- snow_est_2022 + snow_inv_2022
# and I can plot it in order to see if I'm on the right way
tot_2022 <-
  ggplot() + geom_raster(sum_22, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover 2022")+ xlab("Lon")+ ylab("Lat")
tot_2022

# I do the same operation for the year 2000
sum_00 <- snow_est_2000 + snow_inv_2000 
tot_2000 <-
  ggplot() + geom_raster(sum_00, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover 2000")+ xlab("Lon")+ ylab("Lat")
tot_2000

# I want to look for a difference between the two sums
# I assume that the sum in 2000 is bigger, so I put it first in the operation and I do the difference between them
dif_22y <- sum_00 - sum_22
dif_00_22 <-
  ggplot() + geom_raster(sum_00, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Difference 22 years")+ xlab("Lon")+ ylab("Lat")
dif_00_22
# I can observe that the plot has all positive values for what regards the Alps
# in the legend of the layer I can observe only positive values, meaning that everywhere 
# the sum between summer and winter snow in 2000 was higher than in 2022

# now if I want I can do this for every single image like it follows
snow_est_2002 <- raster("snow_cover_est_2002.tif")
snow_est_2002
s_2002 <-
  ggplot() + geom_raster(snow_est_2002, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2002")+ xlab("Lat")+ ylab("Lon")
s_2002


snow_inv_2002 <- raster("snow_cover_inv_2002.tif")
snow_inv_2002
w_2002 <-
  ggplot() + geom_raster(snow_inv_2002, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Winter 2002")+ xlab("Lat")+ ylab("Lon")
w_2002

snow_est_2004 <- raster("snow_cover_est_2004.tif")
snow_est_2004
s_2004 <-
  ggplot() + geom_raster(snow_est_2004, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2004")+ xlab("Lat")+ ylab("Lon")
s_2004

snow_est_2021 <- raster("snow_cover_est_2020.tif")
snow_est_2021
s_2021 <-
  ggplot() + geom_raster(snow_est_2021, mapping = aes(x=x, y=y, fill=NDSI_Snow_Cover))+ scale_fill_viridis(option="mako", direction=1)+ ggtitle("Snow Cover Summer 2021")+ xlab("Lat")+ ylab("Lon")
s_2021

# I can also calculate some differences between past years and past and recent years like I did before
dif_00_21 = snow_est_2000 - snow_est_2021
d_21y <- ggplot() + geom_raster(dif_00_21, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno", direction=-1, alpha=0.8) + ggtitle("Snow Dif")
d_21y
# in summer 2000 there was more snow than in 2021 but only in some parts
# it seems that in areas with less altitude the snow cover is higher in 2021

dif_04_22 = snow_est_2004 - snow_est_2022
d_18y <- ggplot() + geom_raster(dif_04_22, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno", direction=-1, alpha=0.8) + ggtitle("Snow Dif")
d_18y
# in 2004 the summer snow cover was higher than in 2022 almost everywhere
# but is this a casualty or is this a trend?

# BUT since we have 23 images per season, in total 46 images, we prefer to import all the images at the same time
# we want to import all the images together so we don't waste time
# first I named all the images in the same way: snow_cover_season_year
# we can firstly use the function list.files(pattern=x) where x is the part of the name which we are interested in
# we should use the lapply() function, which is applying a function to a list or a vector
# first we need to make the list of files including the world 'est' for the summer
# and then the list characterized by winter time, where the common pattern is 'inv'

rlist_est <- list.files(pattern="est")
# it's gonna consider all the names which include the world est
rlist_est
# we see all the GeoTIFF files considered, so all in which we are interested in
# we apply the raster function to all the set of images
lapply(rlist_est, raster)
# and we import them in R
import_est <- lapply(rlist_est, raster)
# another important function is stack(), which is going to create stacks
SCA_est <- stack(import_est)
# SCA = Snow Coverage of Alps
SCA_est

# we are going to do the same for winter
rlist_inv <- list.files(pattern="inv")
# it's gonna consider all the names which include the world inv
rlist_inv
# we see all the GeoTIFF files considered, so all in which we are interested in
# we apply the raster function to all the set of images
lapply(rlist_inv, raster)
# and we import them in R
import_inv <- lapply(rlist_inv, raster)
# another important function is stack(), which is going to create stacks
SCA_inv <- stack(import_inv)
# SCD = Snow Coverage of Alps
SCA_inv

# if we want we can plot all of them together
plot(SCA_est)
# or we can plot them one by one, selecting them from SCA_est and the double square brackets [[]] containing the number of the image in the order
plot(SCA_est[[1]])
plot(SCA_est[[2]])
plot(SCA_est[[3]])
plot(SCA_est[[4]])
plot(SCA_est[[5]])
plot(SCA_est[[6]])
plot(SCA_est[[7]])
plot(SCA_est[[8]])
plot(SCA_est[[9]])
plot(SCA_est[[10]])
plot(SCA_est[[11]])
plot(SCA_est[[12]])
plot(SCA_est[[13]])
plot(SCA_est[[14]])
plot(SCA_est[[15]])
plot(SCA_est[[16]])
plot(SCA_est[[17]])
plot(SCA_est[[18]])
plot(SCA_est[[19]])
plot(SCA_est[[20]])
plot(SCA_est[[21]])
plot(SCA_est[[22]])
plot(SCA_est[[23]])

# the same goes for winter season
plot(SCA_inv)
plot(SCA_inv[[1]])
plot(SCA_inv[[2]])
plot(SCA_inv[[3]])
plot(SCA_inv[[4]])
plot(SCA_inv[[5]])
plot(SCA_inv[[6]])
plot(SCA_inv[[7]])
plot(SCA_inv[[8]])
plot(SCA_inv[[9]])
plot(SCA_inv[[10]])
plot(SCA_inv[[11]])
plot(SCA_inv[[12]])
plot(SCA_inv[[13]])
plot(SCA_inv[[14]])
plot(SCA_inv[[15]])
plot(SCA_inv[[16]])
plot(SCA_inv[[17]])
plot(SCA_inv[[18]])
plot(SCA_inv[[19]])
plot(SCA_inv[[20]])
plot(SCA_inv[[21]])
plot(SCA_inv[[22]])
plot(SCA_inv[[23]])

# I try to divide the dataset in two subsets, more equal as possible
# the first one (1) going from 2000 to 2011, the second done (2) going from 2011 to 2022
# in this way I have 11 years in both the subsets
SCA_est_1 <- SCA_est[[1:12]]
# I plot it in order to see if it worked
plot(SCA_est_1)
# I use the stackApply() function to get the mean of the different raster (SCA_est_1) all together
SCA_est_mean_1 <- stackApply(SCA_est_1, indices=1, fun=mean)
# and I plot it to see if it worked
plot(SCA_est_mean_1)

# I go on with the second subset doing the same operation
SCA_est_2 <- SCA_est[[12:23]]
SCA_est_mean_2 <- stackApply(SCA_est_2, indices=1, fun=mean)
plot(SCA_est_mean_2)

# I calculate the difference between the two means
diff_est <- SCA_est_mean_1 - SCA_est_mean_2

# I choose an useful color palette
cl <- colorRampPalette(c("blue", "green", "lightgreen", "black", "orange", "red", "darkred"))(100)
# I can simply plot the difference 
plot(diff_est, col=cl)
# between the two subsets there is a visible difference
# while the majority of the area is orange (=no difference)
# the difference present is where the red is: that means that the first subset has an higher mean in the red parts
# sp this means that in the first years the snow cover was higher than in the last years
# summer snow cover has decreased over years
# if I look accurately at the image and I confront it with a georeferenced satellite image
# I can see that those red parts are on the top of very high mountains
# In particular also the region of Mont Blanc is corresponding to a red area, as well as Mount Rosa region
# the same goes for Ortler, Bolzano region, Grossglockner
# So actually a lot of highest peaks and mountains in the Alps region is experimenting a decreasing in snow cover during summer
# and this can be considered true in the range of only the last 22 years

# I can plot the difference also using ggplot
p_diff_est <-
  ggplot() + geom_raster(diff_est, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover Summer Diff")+ xlab("Lat")+ ylab("Lon")
p_diff_est
# I get the same result seen before

# I go on with the winter set, doing the same operations of before
SCA_inv_1 <- SCA_inv[[1:12]]
# I plot it in order to see if it worked
plot(SCA_inv_1)
# I use the stackApply() functione to get the mean of the different raster
SCA_inv_mean_1 <- stackApply(SCA_inv_1, indices=1, fun=mean)
plot(SCA_inv_mean_1)

# I go on with the second subset
SCA_inv_2 <- SCA_inv[[12:23]]
SCA_inv_mean_2 <- stackApply(SCA_inv_2, indices=1, fun=mean)
plot(SCA_inv_mean_2)

# I calculate the difference between the two means
diff_inv <- SCA_inv_mean_1 - SCA_inv_mean_2

# I can simply plot the difference 
plot(diff_inv, col=cl)
# in this case there's a higher positive difference (more snow in the first subset) in the NE
# and a slightly positive difference in the majority of Alps (black)
# other areas show no difference or slightly negative difference (black towards green)
# in particular all the regions near the Alps but characterized from snow in the South, Central and East parts of the area
# are experiencing a decrease in the snow cover during years also in winter
# I can plot the difference also using ggplot
p_diff_inv <-
  ggplot() + geom_raster(diff_inv, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover Winter Diff")+ xlab("Lat")+ ylab("Lon")
p_diff_inv


# I would have liked to use this formula but, at least on my laptop was not working
# time <- 1:nlayers(SCD)
# fun=function(x) { if (is.na(x[1])){ NA } else { m = lm(x ~ time); summary(m)$coefficients[2] }}
# SCA_slope=calc(SCD, fun)
# plot(SCA_slope)

# now we want to see if there's a general trend summing together winter and summer
# we use the stackApply function already seen before, for both the datsets
SCA_sum_1 <- stackApply(SCA_est_1, indices=1, fun=mean) + stackApply(SCA_inv_1, indices=1, fun=mean)
SCA_sum_2 <- stackApply(SCA_est_2, indices=1, fun=mean) + stackApply(SCA_inv_2, indices=1, fun=mean)

# we plot them with our color palette
plot(SCA_sum_1, col=cl)
plot(SCA_sum_2, col=cl)
# I have the two plots and I will do the difference between them

SCA_tot_diff <- SCA_sum_1 - SCA_sum_2
# I plot the difference
plot(SCA_tot_diff, col=cl)
# we can actually observe more or less the same trend seen in winter
# but here the winter trend is accentuated by some more intense colored parts
# but here we can also see a significant difference in all the low altitude parts of the mountains
# all over italy on the south parts of Alps we can identify the orange: this means that the mean snow cover is decreasing
# the majority of the decrease is in the arrea surrounding the Alps but also inside them, we can see that color
# this means that also high mountains and peaks are affected by this phenomena (like we have seen in summer time)

p_diff_tot <-
  ggplot() + geom_raster(SCA_tot_diff, mapping = aes(x=x, y=y, fill=layer))+ scale_fill_viridis(option="magma", direction=1)+ ggtitle("Snow Cover Total Diff")+ xlab("Lat")+ ylab("Lon")
p_diff_tot
# this is less useful to read the result

# CONCLUSIONS
# in all cases we can see a difference
# in summer the difference is particularly higher
# in winter the difference is present, not so much concentrated but wider
# also in the totality of the comparison the difference is present also if it's not exttremely high
# snow cover so is decreasing on the Alps
# we also have to think that this experiment was considering only 22 years and a trend was present
# all the experiment started from my own observation of pre-Alps and Alps in Veneto, where I usually go a lot whenever I can
# I'm also taking a lot of photos in those trip and comparing photos throughout the years I noticed
# this difference, which I was able to find here in this pattern
