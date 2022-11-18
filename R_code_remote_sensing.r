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

# MISSING 11.11.2022 LECTURE

# now we want to plot only the first band of the image, we can use [[1]]
plot(p224r63_2011[[1]])

# we can make a multiframe with 2 raws and 2 coloumns with 4 images
par(mfrow=c(2,2))

# now we want to plot the single images inside

plot(p224r63_2011[[1]])
plot(p224r63_2011[[2]])
plot(p224r63_2011[[3]])
plot(p224r63_2011[[4]])

# now we have the first 4 bands: blue 1, green 2, red 3, near infrared 4
# for each band we have the reflectance

# we can put a different legend for each band (color ramps)
par(mfrow=c(2,2))
# we need color ramp palette
colorRampPalette(c('dark blue','blue','light blue'))(100)
clb <- colorRampPalette(c('dark blue','blue','light blue'))(100)
plot(p224r63_2011[[1]], col=clb)
# we want to do it for all the colors
clg <- colorRampPalette(c('dark green','green','light green'))(100)
plot(p224r63_2011[[2]], col=clg)
# now to the red
clr <- colorRampPalette(c('red4','red2','red1'))(100)
plot(p224r63_2011[[3]], col=clr)

# and near infrared
cln <- colorRampPalette(c('darkorange1','darkorange','wheat3'))(100)
plot(p224r63_2011[[4]], col=cln)

# we now gìhave together all the 4 bands with colors that we chose one beside the other
# now we are goin to usee how to put them all together and how to represent them
# we can anage bands all together to give a visualization of the landscape
# we can make it looking like we would see it in real life
# there's the RGB scheme: 3 basic colors (also in laptops and smartphones): red, green, blue
# it starts with these 3 basic colors and overlapping them between each other in order to obtain every possible color
# we are going to use this RGB scheme to create a multilayer image
# the same bands we have from the landsat dataset: B, G, R + IR
# we need to use the 3 levels all together, we can assign every single band to a component of RGB
# natural colors: we assign blue band to blue (of RGB) and so on with the other 2
# the function is called plotRGB(name of the object, RGB to which bands they refer, stretch=)
# the stretch refers to stretching the colors in order to see what we want to use
# there are different types of stretch and the simplest is Linear

dev.off()
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

# we now see the image in natural colors but here is difficult to discriminte between water and forests
# the NIR is reflected a lot by plants (see slides) while R and B are adsorbed and the G reflected
# if we can see the NIR we will see where the plants are since they reflect it a lot
# we have to choose which band we should remove, we can have different trials

plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")

# everything which will be reflecting a lot in the NIR will become red: everything red will be vegetation
# now we can see kinda inside the forest, also plants and humidity and plants outside the forest
# this is powerful for monitoring to see what can happen to ecosystems 
# apart from the forest we can see agricultural ares
# we can still change colors (which are "mistakes" of our eyes

plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")

# now the NIR is seen as green, all the vegetation will become green

plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")

# now the NIR is seen as blue, all the vegetation will become blue
# this is powerful for detecting areas without vegetation
# yellow areas are soil without anything on top
# once you see in the landscape some threshold, there is human intervention
# areas whith perfect geometries (like triangoles) are bc of humans: nature doesn't have that type of geometry

# plot the previous 4 manners in a single multiframe
par(mfrow=c(2,2))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")

# now we can see them all together
# life has mainly some colors but we need the sensors to see them: our aeyes are anot a good sensor for that
# we need this type of sensor in order to see the sensors with new colors

# stretch 
# the reflectance is a ratio: light reflected/total light
# the range of the ratio will be from 0 to 1 (potentially covering all values)
# an actual band can for example go from 0.2 to 0.6
# we can have a possibility to stretch this short range in order to reach an interval 0 to 1
# a linear stretch takes the values linearly to the value 1: 0.6 in this case will become 1
# another one is called histogram and it's using a higher jump in the middle (more or less exponential)
# the histogram is going to tìstretch a lot the colors

dev.off()
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist")

# we can compare the linear and the histogram: now stretching a lot (more or less exp) we can see even better inside the forest
# the upper brighter part of the forest couldn't be seen before, there probably we are modifying the forest
# we can better see with a better stretch

par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")

# we can then consider 2 different timetables: comparing two different moments in time










