# we want to calculate vegetation indices through remote sensing 

library(raster)
setwd("C:/lab/")

# first we want to import data and look at them
# we will use again the function brick()

l1992 <- brick("defor1.png")

# there's a warning but it's okay
# names are the names of the bands: 1 NIR, 2 red and 3 green
# we want a simple plot with RGB

plotRGB(l1992, r=1, g=2, b=3, streth="lin")

# everything that was vegetation will become red
# we can do the same in 2006

l2006 <- brick("defor2.png")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, streth="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# pure water adsorbs the NIR completely so it will be black
# bare soil in the water takes the water to be less dark
# in 2006 the water is more dark so in that period there was less soil inside the water
# we want to calculate some indices that dimostrate that big changes happened
# we want to quantify the change and to compare the changes present
# we start with DVI (it considers 2 bands: 1 is NIR and 2 is RED)

dvi1992 <- l1992[[1]] - l1992 [[2]]
dvi1192
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1992, col=cl)

# we can see the red parts with high vegetation presence

dvi2006 <- l2006[[1]] - l2006[[2]]
dvi2006
plot(dvi2006, col=cl)

# we can see a huge vegetation loss, a consistent change of soil usage
# how to make a threshold and classify data for the amount of change in this period?
# we need to classify
# we can both classify the dvi images but also the original images (better since we have more bands)

library(RStoolbox)      # that's for classification

# unsuperclass is the function to make the unsupervised (the software is doing the threshold on its own) classification

d1c <- unsuperClass(l1992, nClasses=2)
# d1c = first calssified image on deforestation

d1c
# there are two different things inside
# first there is the model used and then the map

dev.off()
plot(d1c$map)
# in the map there are only 2  default classes
# now we can now the amount of pixels where tjere was forest, water or something else
# we can use a function: freq: I want to know how many pixels are in one class
# class 1 is the forest in my case and 2 is human impact (and water)

freq(d1c$map)

# in 1992 I have 306947 pixels in forest (class1)
# in 1992 34345 pixels are representing hmman impact (class2)
# I can calculate the proportion of each calss in that moment

# forest
f1992 <- 306947/(306947+34345)
# human impact
h1992 <- 34345/(34345+306947)

f1992
# f1992 was almost 90%
h1992
# h1992 was around 10%

# we do the same for 2006
d2c <- unsuperClass(l2006, nClasses=2)
plot(d2c$map)     # two different classes 
# in my case forest is in the class number 2, while human impact is 1
# here all the green parts are forest for this case

freq(d2c$map)
# class 1 now is human impact: 163321 pixels
# class 2 is forest: 179405 pixels

# forest
f2006 <- 179405/(179405+163321)
# human impact
h2006 <- 163321/(163321+179405)

f2006
# forest is 52%
h2006
# human impact is 48%

# now I have the percentages in both years
# the change is visible and so big
# we want a final table
# the function for the table is data.frame

data.frame


























