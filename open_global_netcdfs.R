#-------------------------------------------------------------------------------
# This scripts opens ensemble-mean GRACE JPL forced by ERA5 and reads for Xingu and Pantanal
#-------------------------------------------------------------------------------
# By: Andreia Ribeiro 10.14.2021
# andreia.ribeiro@env.ethz.ch
#-------------------------------------------------------------------------------
remove(list=ls()) 
graphics.off()
​
library(rgdal) # shapefiles
library(ncdf4) #netcdf
library('fields') #image.plot
​
#-------------------------------------------------------------------------------
# Regions shapefile
#-------------------------------------------------------------------------------
Xregion_xingu<-readOGR('C:/Users/silvaa/polybox/Amazon_risk/5_Data/GWC_Study_area/GWC_Study_area.shp')
Xregion_pantanal<-readOGR('C:/Users/silvaa/polybox/Amazon_risk/5_Data/pantanal_border/biome_border_bbox.shp')
​
# GSFC_ERA5  - trained with GRACE GSFC mascons, forced with ERA5 forcing (1979-present)
# GSFC_GSWP3 - trained with GRACE GSFC mascons, forced with GSWP3 forcing (1901-2014)
# GSFC_MSWEP - trained with GRACE GSFC mascons, forced with MSWEP forcing (1979-2016)
​
# JPL_ERA5   - trained with GRACE JPL mascons, forced with ERA5 forcing (1979-present)
# JPL_GSWP3  - trained with GRACE JPL mascons, forced with GSWP3 forcing (1901-2014)
# JPL_MSWEP  - trained with GRACE JPL mascons, forced with MSWEP forcing (1979-2016)
​
nc_JPL_ERA5 <- nc_open("C:/Users/silvaa/polybox/Amazon_risk/5_Data/GRACE/reconstruction/01_monthly_grids_ensemble_means_allmodels/GRACE_REC_v03_JPL_ERA5_monthly_ensemble_mean.nc")
print(nc_JPL_ERA5)
​
# read latitude and longitude
lon <- ncvar_get(nc_JPL_ERA5, "lon")
lat <- ncvar_get(nc_JPL_ERA5, "lat", verbose = F)
​
# select the lat and lon of Xingu and Pantanal
lat_xingu <- which(lat>=Xregion_xingu@bbox[2,1] & lat<=Xregion_xingu@bbox[2,2])
lon_xingu <- which(lon>=Xregion_xingu@bbox[1,1] & lon<=Xregion_xingu@bbox[1,2])
lat_pantanal <- which(lat>=Xregion_pantanal@bbox[2,1] & lat<=Xregion_pantanal@bbox[2,2])
lon_pantanal <- which(lon>=Xregion_pantanal@bbox[1,1] & lon<=Xregion_pantanal@bbox[1,2])
​
# time variables to plot time series
t <- ncvar_get(nc_JPL_ERA5, "time")
tunits <- ncatt_get(nc_JPL_ERA5,'time')
tustr <- strsplit(tunits$units, " ")
timestamp <- as.POSIXct(t*3600*24,tz='GMT',origin=tustr[[1]][3])
years <- format(timestamp, "%Y")
months <- format(timestamp, "%m")
​
# get variables for the desired regions
tws_JPL_ERA5_xingu <- ncvar_get(nc_JPL_ERA5,"rec_ensemble_mean",start=c(lon_xingu[1], lat_xingu[1],1),count=c(length(lon_xingu),length(lat_xingu),length(timestamp)))
tws_JPL_ERA5_pantanal <- ncvar_get(nc_JPL_ERA5,"rec_ensemble_mean",start=c(lon_pantanal[1], lat_pantanal[1],1),count=c(length(lon_pantanal),length(lat_pantanal),length(timestamp)))
​
# plot first timestep for illustration
par(mfrow=c(1,2))
image.plot(lon[lon_xingu],lat[lat_xingu],tws_JPL_ERA5_xingu[,,1], main='Xingu JPL_ERA5')
plot(Xregion_xingu,add=TRUE)
image.plot(lon[lon_pantanal],lat[lat_pantanal],tws_JPL_ERA5_pantanal[,,1], main='Pantanal JPL_ERA5')
plot(Xregion_pantanal,add=TRUE)
