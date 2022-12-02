# we are going to consider the ice melting in Greenland
library(raster)

# we want to import the single images with the raster function
setwd("C:/lab/")

# I can import every image alone
lst_2000 <- raster("lst_2000.tif")
lst_2000
library(ggplot2)
library(RStoolbox)
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000))
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis()
# without specifying the colors I wil have the basic viridis colors
# the legend of the image represents the bits of the image (2^14) 

ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma")
# in the map we see the temperature
# we can also reverse the legend colors we can use the option direction=-1
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=-1)
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=-1) + ggtitle("Temperature 2000")

# an additional parameter in viridis is alpha, the amount of transparency in the plot
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.2) + ggtitle("Temperature")
# the higher the alpha the lower will be the transparency
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.8) + ggtitle("Temperature")

library(patchwork)
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.2) + ggtitle("Temperature")
ggplot() + geom_raster(lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.2) + ggtitle("Temperature")

dev.off()

lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# we want to import all the images together so we don't waste time
# we should use the lapply function, which is applying a function to a list or a vector
# first we need to make the list of files

rlist <- list.files(pattern="lst")
# it's gonna consider all the lst names
rlist
lapply(rlist, raster)
import <- lapply(rlist, raster)

# another important function is stack(), which is going to create stacks
TGr <- stack(import)
# TGr=Tempareature of Greenland
TGr
plot(TGr)

# when I want to recall only certain images of a set I should find or the same words in all the images
# or I can write something more for every image I will need in the analysis

ggplot() + geom_raster(TGr&lst2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.8) + ggtitle("Temperature")
# is the same as
p1 <- ggplot() + geom_raster(TGr[[1]], mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.8) + ggtitle("Temperature 2000")
p2 <- ggplot() + geom_raster(TGr[[4]], mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma", direction=1, alpha=0.8) + ggtitle("Temperature 2015")

# we can see the difference in the two images
p1 <- ggplot() + geom_raster(TGr[[1]], mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=-1, alpha=0.8) + ggtitle("Temperature 2000")
p2 <- ggplot() + geom_raster(TGr[[4]], mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma", direction=-1, alpha=0.8) + ggtitle("Temperature 2015")

# with the reverse colors we can understand better the distribution and the density of the ice
# the bright color in the middle of the ice changed a lot in the 15 years
# we could also make the difference putting first 2015

# 2015 - 2000
dift = TGr[[4]] - TGr[[1]]
p3 <- ggplot() + geom_raster(dift, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno", direction=-1, alpha=0.8) + ggtitle("Temperature Dif")
p1 + p2 + p3

plotRGB(TGr, r=1, g=2, b=4, stretch="lin")
# in a single plot we are plotting three layers
# the prevalent color will indicate us the layer with higher temperatures

# there is also the colorist package











