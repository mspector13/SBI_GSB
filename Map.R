#Let's make a map

library(tidyverse)
library(tibble)
library(ggmap)
#citation("ggmap") ##to cite ggmap if used
library(sf)
library(mapview)
library(rgdal)

bassloc <- read_csv("/Users/PikesStuff/github/SBI_GSB/GSBsites.csv") #read in data as_tibble()
bassloc

bassloc$Lat_dd
bassloc$Lon_dd

sites <- st_as_sf(bassloc, coords = c("Lat_dd", "Lon_dd"), proj4string = CRS("+proj=longlat +datum=WGS84"))

mapview(sites)
