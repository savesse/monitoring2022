# SDM PACKAGE (species distribution model)
# install.packages("sdm")
# install.packages("rgdal", dependencies=T)

library(sdm)
library(raster) # predictors, needed also for the function shapefile
library(rgdal) # species

# system.file function is showing the path
# external is a folder inside the sdm package

file <- system.file("external/species.shp", package="sdm") 
# it shows exactly the path to the data
species <- shapefile(file)

# looking at the set
species

# plot
plot(species)

# looking at the occurrences
species$Occurrence

presences <- species[species$Occurrence == 1,]
# we want only the values with 1 and not with 0
absences <- species[species$Occurrence == 0,]
# vice versa

# copy and then write:
plot(presences, col="blue", pch=16)
points(absences, col="red", pch=16)
# I have together absences and presences, we can see some initial patterns

plot(species[species$Occurrence == 1,],col='blue',pch=16)
points(species[species$Occurrence == 0,],col='red',pch=16)

# predictors: look at the path
path <- system.file("external", package="sdm") 
path
# same path used previously but we are goign to the folder

# we are intrested in the .asc files
# list the predictors
lst <- list.files(path=path,pattern='asc$',full.names = T) #
lst

# stack
preds <- stack(lst)
preds

# plot preds
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)
# frogs don't love mountains, with cold, they like humidity

# plot predictors and occurrences
plot(preds$elevation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$temperature, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$precipitation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$vegetation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# model

# set the data for the sdm
datasdm <- sdmData(train=species, predictors=preds)

# model
# ~ is the same as =
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")

# make the raster output layer
p1 <- predict(m1, newdata=preds) 

# plot the output
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# add to the stack
s1 <- stack(preds,p1)
plot(s1, col=cl)

# Do you want to change names in the plot of the stack?
# Here your are!:
# choose a vector of names for the stack, looking at the previous graph, qhich are:
names(s1) <- c('elevation', 'precipitation', 'temperature', 'vegetation', 'model')
# and then replot!:
plot(s1, col=cl)
# you are done, with one line of code (as usual!)
