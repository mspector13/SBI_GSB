#Detections

library(ggplot2)
library(tidyverse)
library(lubridate)
library(dplyr)

gsb.raw<-read.csv('GSB_detections_25Oct2019_Clean.csv') #vemco spit out
gsb.raw$Transmitter.Serial<-str_sub(gsb.raw$Transmitter, -4)
colnames(gsb.raw)<-c("Date.Time", "Receiver", "Transmitter","Transmitter.Name", "Transmitter.Serial", "Sensor.Value", "Sensor.Unit", "Station.Name", "Latitude", "Longitude")
#gsb.raw$Date.Time<-as.POSIXct(gsb.raw$Date.Time, tz="America/Los_Angeles", format= "%m/%d/%y %H:%M")

gsb.date <- gsb.raw %>% 
  mutate(`Date.Time` = mdy_hm(`Date.Time`)) %>% 
  separate(`Date.Time`, into = c('Date', 'Time'), sep=' ', remove = FALSE) %>% 
  mutate(
    dates2=ymd(Date),
    year=year(dates2),
    month=months(dates2),
    day=day(dates2)
  )


gsb.date %>% 
  ggplot(aes(x=month, y=Station.Name)) +
  geom_bar(stat="identity") +
  coord_flip()
