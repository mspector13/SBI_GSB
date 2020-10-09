#Homerange detections 

library(rgdal)
library(rgeos)
library(adehabitatHR)
library(maptools)
library(raster)
library(tidyverse)
library(lubridate)
library(sp)
library(dplyr)

detections <- read_csv("/Users/PikesStuff/github/SBI_GSB/GSB_detections_25Oct2019_Clean.csv")
head(detections)

dates <- detections %>% 
  mutate(`Date and Time (UTC)` = mdy_hm(`Date and Time (UTC)`)) %>% 
  separate(`Date and Time (UTC)`, into = c('Date', 'Time'), sep=' ', remove = FALSE) %>% 
  filter(!is.na(Longitude)) %>% 
  filter(!is.na(Latitude))

coords <- dates[ , c("Longitude", "Latitude")]
crs <- CRS("+proj=longlat +datum=WGS84")

spdf_1 <- SpatialPointsDataFrame(coords = coords,
                               data = dates,
                               proj4string = crs)

bassloc <- SpatialPointsDataFrame(data.frame(dates$Longitude, dates$Latitude), 
                                proj4string = CRS("+proj=longlat +datum=WGS84"), 
                                data=new_dates)

plot(bassloc, pch=16)
#par(bg="honeydew") don't know what this does...
