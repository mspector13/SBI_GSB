library(tidyverse)
library(CMRnet)
library(lubridate)
#Load data as a tibble... won't work as a df for some reason.... 

# If not first time, skip ####
GSB_data <- read_csv("filter_dections_all.csv", na="NULL")
head(GSB_data)

#rename 2x columns to match "cmrData"
GSB_data <- GSB_data %>% 
  rename(date=dt) %>% 
  rename(loc=sta_id)

#Select the appropriate columns, filter out any id's that aren't our fish
IntrData <- GSB_data %>% 
  select(id, loc, x, y, date) %>%
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
write.csv(IntrData, file = "Trans_ID.csv") #save to repo and edit in Excel lmao

#Load the data ####
Trans_ID <- read_csv("Trans_ID.csv", na="NULL")

Trans_ID <- Trans_ID %>% 
  select(id, loc, x1, y1, date)
Trans_ID <- Trans_ID %>% 
  rename(x=x1) %>% 
  rename(y=y1)
#Our data had a date issue, try:
#First, mutate dates into characters from vectors
Trans_ID %>% 
  mutate(date = as.character(date)) %>% 
  mutate(loc = as.factor(loc))
#Then use lubridate to get the character string into the correct format 
Trans_ID$date <- mdy_hm(Trans_ID$date) #note: syntax is for original format *not* desired

Trans_ID %>% 
  mutate(x = as.double(x)) %>% 
  mutate(y = as.double(y))

#Construct co-capture networks ####
mindate <- "2018-08-13"
maxdate <- "2019-10-17"
intwindow <- 1 #length of time (in days) w/in which individuals are considered co-captured
netwindow <- 12 #length of each network window in months
overlap <- 0 #overlap between network windows in months
spacewindow <- 0 #spatial tolerance for defining co-captures

#create co-capture (social) networks:
islanddat <- DynamicNetCreate(
  data = Trans_ID,
  intwindow = intwindow,
  mindate = mindate,
  maxdate = maxdate,
  netwindow = netwindow,
  overlap = overlap,
  spacewindow = spacewindow,
  index=FALSE)
