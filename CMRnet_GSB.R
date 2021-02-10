library(tidyverse)
library(CMRnet)
library(lubridate)

# If not first time, skip ####
GSB_data <- read_csv("filter_dections_all.csv", na="NULL")
head(GSB_data)

#rename 2x columns to match "cmrData"
GSB_data <- GSB_data %>% 
  rename(date=dt) %>% 
  rename(loc=sta_id)

#Select the appropriate columns, filter out any id's that aren't our fish
IntrData <- GSB_data %>% 
  dplyr::select(id, loc, x, y, date) %>%
  filter(id %in% c("A69-1602-9719",
                   "A69-1602-9720",
                   "A69-1602-9721", 
                   "A69-1602-9723", 
                   "A69-1602-9722",
                   "A69-1602-9716",
                   "A69-1602-9718",
                   "A69-1602-9712",
                   "A69-1602-9714",
                   "A69-1602-16712",
                   "A69-1602-16716",
                   "A69-1602-16715",
                   "A69-1602-16718",
                   "A69-1602-16710"))

#There's going to be a problem with the "loc" column (as.character = true)
#We need to rename all of the characters in that column with numers (ugh)
write_csv(IntrData, file = "Trans_ID.csv") #save to repo and edit in Excel lmao

#Load the data ####
Trans_ID <- read_csv("Trans_ID.csv", na="NULL")
#Remember to remove the "A69-1602-" manually in Excel, until a better script is written

#From the "coordmeters.R" script to translate lat/longs into a grid
#LOAD AND RUN "coordmeters.R" first!
Trans_ID <- Trans_ID %>% 
  dplyr::select(id, loc, x1, y1, date)
Trans_ID <- Trans_ID %>% 
  rename(x=x1) %>% 
  rename(y=y1)

#Then use lubridate to get the character string into the correct format 
#Trans_ID$date <- mdy_hms(Trans_ID$date) #note: syntax is for original format *not* desired

New_data <- Trans_ID %>% 
  dplyr::mutate(id = as.integer(id)) %>% 
  dplyr::mutate(loc = as.factor(loc)) %>% 
  dplyr::mutate(x = as.integer(x)) %>% 
  dplyr::mutate(y = as.integer(y))

#This should, ideally, group by unique DAYS (not minutes or seconds w/in days)
New_data %>% 
  mutate(date = date(date)) %>% 
  group_by(id, loc, x, y, date) %>% 
  summarize(n_detections = n()) %>% 
  arrange(desc(n_detections))
  

#Construct co-capture networks ####
mindate <- "2018-08-13"
maxdate <- "2019-10-17"
intwindow <- 1 #length of time (in days) w/in which individuals are considered co-captured
netwindow <- 12 #length of each network window in months
overlap <- 0 #overlap between network windows in months
spacewindow <- 0 #spatial tolerance for defining co-captures

#create co-capture (social) networks:
islanddat <- DynamicNetCreate(
  data        = New_data,
  intwindow   = intwindow,
  mindate     = mindate,
  maxdate     = maxdate,
  netwindow   = netwindow,
  overlap     = overlap,
  spacewindow = spacewindow,
  index       = FALSE)
