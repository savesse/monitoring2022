# landsat satellite is passing on the same spot every 14 days, in 14 days can cover all the surface of the Earth
# in the name of the files from the zip file we can see the position of the image in the grid from landsat
# p224 indicates the horizontal line where we cna find 224
# r63 indicates the raw we are considering 
# following the coordinates I can find where I am on the map of the landsat
# 2011 indicate which was the year of reference

# we are going to use raster package
library(raster)
library(RStoolbox)

# we set the working directory as always
setwd("C:/lab/")

# now we have to explain to R what we are using and how R should deal with them
# the data are records of reflectance in some particular wavelenght bands
# the type of file is a raster grid, with several layers one on the top of the other (.grd)
# the function will be brick()
# the name masked in the file means that the image has been cleaned

p224r63_2011 <- brick("p224r63_2011_masked.grd")
p224r63_2011

# the class is what type of file we are using
# the raster brick is a group of bands one on the top of each other
# we can also see how many pixels are there (1499 versus 2967) and the total pixels (4447533 for every band)
# every image (they are 7) has 4 million of pixels
# then we have the resolution of pixels (30m x 30m)
# extent: what are the coordinates of the file
#  crs: coordinate reference system: which projection is used and which coordinates are used
# names: all the different bands: we have the reflectance in 7 bands

plot(p224r63_2011)

# b1 blue, 2 green, 3 red, 4 near infrared
# for any graphical problem we can use dev.off() which will close the plot and then replot
# we can change the colors

cl <- colorRampPalette(c('black','grey','light grey'))(100) # 
plot(p224r63_2011, col=cl)

# the first wavelenght is the one of the blue, low amount of reflectance means that blue there is completely adsorbed 
# other objects there are reflecting a lot the blue wavelength












