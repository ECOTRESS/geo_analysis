## Lucas Santos 10.13.2021
## Crop and mask several rasters based on shp

# Clean the env
rm(list=ls()) 

# Load libs
library(sf)

# Load .shp 
ws = shapefile("C:/Users/santoslr/Desktop/Lucas/phd/data/chapter_1/bacias/micro_xingu.shp")

# List raster files
l = list.files("C:/Users/santoslr/Desktop/Lucas/phd/data/raster/chapter_1/mapbiomas/root/br",
               pattern = ".tif",
               full.names = T)

# Import rasters
lu = lapply(l, raster) # This function apply the raster function in all elements of the list

# Crop all rasters
lu_ws_croped = lapply(lu, function(x) {
  crop(x,ws)
})

# Mask all rasters -- need to run this separately from the crop function otherwise R may crash
lu_ws_masked = lapply(lu_ws_croped, function(x){
  mask(x,ws)
})

# Save cropped data
setwd("C:/Users/santoslr/Desktop/Lucas/phd/data/raster/chapter_1/mapbiomas/root/small_watershed/xingu") # Define directory
# Save all rasters
for (i in 1:length(lu_ws_masked)) {
  print(i) # Just follow for steps
  writeRaster(lu_ws_masked[[i]], names(lu_ws_masked[[i]]), format='GTiff')
}
