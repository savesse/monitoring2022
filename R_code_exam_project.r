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
                  .filter(ee.Filter.date('2020-01-01', '2020-12-31'));        # we set the time period in which we are intrested, so the year
var snowCover = dataset.select('NDSI_Snow_Cover');
var snowCoverVis = {
  min: 0.0,
  max: 100.0,
  palette: ['black', '0dffff', '0524ff', 'ffffff'],
};

print('snowCover', snowCover)

Map.setCenter(11.65, 46.386, 6);
Map.addLayer(snowCover, snowCoverVis, 'Snow Cover');


// Export a cloud-optimized GeoTIFF.
Export.image.toDrive({
  image: snowCover.select('NDSI_Snow_Cover').mean(),
  description: 'snowCover Mar 2020',
  scale: 30,
  region: geometry,
  fileFormat: 'GeoTIFF',
  formatOptions: {
    cloudOptimized: true
  }
});

























