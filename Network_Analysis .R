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

#Kris's base R to get POSIXct: > as.POSIXct(GSB_data$dt, format = "%Y-%m-%d %H:%M:%S")
# as.POSIXct(GSB_data$dt, format = "%Y-%m-%d %H:%M:%S"), "%H") to bin by hour

view(GSB_data)
#Make a new tibble with only the selected transmitters 
trans_ID <- dates %>% 
 select(Date, Time, rec_id, id, sta_id) %>%
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

#To view() our new tibble, now specifically filtered to show the fish of interest ("id")
view(trans_ID)

#Now we need to check to make sure all of the fish we're interested in are present
#unique() returns only unique variables in the selected parameters, the "id" column in this case
view(unique(trans_ID$id))

#From the call above, we see that only 10 of our 14 inque id's are present
#Let's search the original data for our missing id's
missing_fish <- GSB_data %>% 
  select(rec_id, id, sta_id) %>%
    filter(id %in% c("A69-1602-16712",
                     "A69-1602-16716",
                     "A69-1602-16718",
                     "A69-1602-16710"))
view(missing_fish)
#As it turns out, these unique id's are *not* present in our data! Moving on with just Trans_id

#make a node list; this *should* take each  destination ("sta_id") and make a inque id ("id")

nodes <- trans_ID %>% 
  distinct(sta_id) %>% 
  rename(label=sta_id)

nodes <- nodes %>% 
  rowid_to_column("id")

#Create a "weight column" that *should* weight interactions between "id" (fish) and "sta_id" (individual stations)
edge_list <- trans_ID %>% 
  group_by(sta_id, id) %>% 
  summarise(weight = n()) %>% 
  ungroup()

view(edge_list)

#Now make an edge list in the correct nomenclature
edges <- edge_list %>% 
  left_join(nodes, by = c("sta_id" = "label")) %>% 
  rename(trans=id.x) %>% 
  rename(id=id.y) %>% 
  rename(label=sta_id)

view(edges)
view(nodes)
#Make some network objects
library(network)
?network()

view(station_id)

island_network <- network(edges, 
                          vertex.attr = nodes, 
                          matrix.type = "edgelist", 
                          ignore.eval = FALSE)
class(island_network) #double check, is "island_network" a network? yes, yes it is!
print(island_network)

plot(island_network, vertex.cex = 3) #vert.cex increases the size of the nodes

#To explore these interactions in igraph, we'll need to detach the network package, presumably the language may interfere  
detach(package:network)
library(igraph)

nodes <- nodes %>% 
  relocate(where(is.numeric), .after = last_col())
view(nodes) #Because of dependencies, columns in "edges" and "nodes" should be in the same order
view(edges)



island_igraph <- graph_from_data_frame(d = edges, 
                                       vertices = nodes,
                                       directed = TRUE)
class(island_igraph)
plot(island_igraph, edge.arrow.size=0.2, layout = layout_with_graphopt) #this didn't work
