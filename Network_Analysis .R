library(tidyverse)
library(lubridate)
library(tibble)
library(dplyr)

#Source: https://www.jessesadler.com/post/network-analysis-with-r/

#Load data as a tibble
GSB_data <- read_csv("filter_dections_all.csv", na="NULL")
head(GSB_data)

#Make a new tibble by splitting "dt" into "Date" and "Time" columns
dates <- GSB_data %>% 
  mutate(dt = as.character(dt)) %>% 
  separate(dt, into = c("Date", "Time"), sep = " ")

head(dates)

#Make a new tibble with only the selected columns 
#detections <- dates %>% 
  #select(Date, Time, Receiver, Transmitter, `Station Name`)

#Import the *transmitter* IDs of interest (these are the tagged GSB we're interested in)
GSB_ids <- tibble::tribble(
    ~Transmitter, 
                9719,
                9720,
                9721,
                9723,
                9722,
                9716,
                9718,
                9712,
                9714,
                16712,
                16716,
                16715,
                16718,
                16710,
                      )
GSB_ids

#Make a new tibble with only the selected transmitters 
trans_ID <- dates %>% 
 select(Date, Time, rec_id, id, sta_id) %>%
  filter(id == "A69-1602-9719")

view(trans_ID)


