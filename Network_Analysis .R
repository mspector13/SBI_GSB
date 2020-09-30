library(tidyverse)
library(lubridate)

#Source: https://www.jessesadler.com/post/network-analysis-with-r/

#Load data as a tibble
GSB_data <- read_csv("/Users/PikesStuff/github/GSB/GSB_detections_25Oct2019_Clean.csv", na="NULL")
head(GSB_data)

#Make a new tibble by splitting "Date and Time (UTC)" into "Date" and "Time" columns
dates <- GSB_data %>% 
  mutate(`Date and Time (UTC)` = mdy_hm(`Date and Time (UTC)`)) %>% 
  separate(`Date and Time (UTC)`, into = c('Date', 'Time'), sep=' ', remove = FALSE)

#Make a new tibble with only the selected columns 
detections <- dates %>% 
  select(Date, Time, Receiver, Transmitter, `Station Name`)

# 

