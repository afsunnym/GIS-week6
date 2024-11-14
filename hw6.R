library(spatstat)
library(here)
library(sp)
library(tmap)
library(sf)
library(tmaptools)

LondonBoroughs <- st_read(here::here("statistical-gis-boundaries-london", "ESRI", "London_Borough_Excluding_MHW.shp"))

library(stringr)
BoroughMap <- LondonBoroughs %>%
  dplyr::filter(str_detect(GSS_CODE, "^E09"))%>%
  st_transform(., 27700)

qtm(BoroughMap)
summary(BoroughMap)

BluePlaques <- st_read(here::here("open-plaques-london-2018-04-08.geojson")) %>%
  st_transform(.,27700)

summary(BluePlaques)

#plot the blue plaques in the city
tmap_mode("plot")
tm_shape(BoroughMap) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaques) +
  tm_dots(col = "blue")

#remove duplicates
library(tidyverse)

library(sf)
BluePlaques <- distinct(BluePlaques)

BluePlaquesSub <- BluePlaques[BoroughMap,]
#check to see that they've been removed
tmap_mode("plot")
tm_shape(BoroughMap) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesSub) +
  tm_dots(col = "blue")

# add sparse=false to get the complete matrix.
intersect_indices <-st_intersects(BoroughMap, BluePlaques)


Londonborough <- st_read(here::here("statistical-gis-boundaries-london", 
                                    "ESRI", 
                                    "London_Borough_Excluding_MHW.shp"))%>%
  st_transform(., 27700)

OSM <- st_read(here::here("greater-london-latest-free.shp", 
                          "gis_osm_pois_a_free_1.shp")) %>%
  st_transform(., 27700) %>%
  #select hotels only
  filter(fclass == 'hotel')
join_example <-  st_join(OSM, Londonborough)

nrow(join_example)