library(tidyverse)
library(CMRnet)
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
#Construct co-capture networks ####
mindate <- "2018/08/13"
maxdate <- "2019/10/17"
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
#Error in h(simpleError(msg, call)) : 
#error in evaluating the argument 'x' in selecting a method for function 'julian': 
#character string is not in a standard unambiguous format
#I think the issue is the date format in Trans_ID$date 
#But POSIXct and lubridates' magic won't work... 
