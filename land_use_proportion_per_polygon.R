# Lucas Santos 10.13.2021
# Land Use propotion per polygon 
library(sf)
library(dplyr)
library(tidyr)
# Import shapefile
ws = st_read("C:/Users/santoslr/Desktop/Lucas/phd/data/chapter_1/bacias/micro_xingu.shp"); head(ws)

# LU rasters
l = list.files("C:/Users/santoslr/Desktop/Lucas/phd/data/raster/chapter_1/mapbiomas/root/small_watershed/xingu",
               pattern = ".tif",
               full.names = T)

# Import LU rasters
lu = lapply(l, raster)

# Prop. LU per polygon (Still need to define each lu to get the analysis from -- a for loop can be used to make iterativelly
  freqs = exactextractr::exact_extract(lu[[1]], ws, function(value, coverage_fraction) {
    data.frame(value = value,
               frac = coverage_fraction / sum(coverage_fraction)) %>%
      group_by(value) %>%
      summarize(freq = sum(frac), .groups = 'drop') %>%
      pivot_wider(names_from = 'value',
                  names_prefix = 'freq_',
                  values_from = 'freq')
  }) %>% 
    mutate(across(starts_with('freq'), replace_na, 0)) %>%
    mutate(fid = ws$fid)
