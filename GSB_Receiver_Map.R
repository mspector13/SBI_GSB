##Wonky Map
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(ggspatial)


#Load in the "World" as a data frame
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

#Load centroids 
world_points<- st_centroid(world)
world_points <- cbind(world, st_coordinates(st_centroid(world$geometry)))

#Make a figure of a map in ggplot
#There *may* be a simpler way of doing this, 
#but for now set the limts of the figure using limits of an x-y plane 

SB_Island <- ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(-119.6, -119.4), ylim = c(33.2, 33.3), expand = FALSE) +
  theme(legend.position = "none", axis.title.x = element_blank(), 
        axis.title.y = element_blank(), 
        panel.border = element_rect(fill = NA)) +
  annotation_scale(location = "bl", width_hint = 0.2, 
                   pad_x = unit(0.1, "in"), pad_y = unit(0.1, "in")) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.01, "in"), pad_y = unit(0.15, "in"),
                         style = north_arrow_fancy_orienteering) +
  annotate(geom = "text", x = -119.51, y = 33.25, label = "Santa Barbara Island", 
           fontface = "italic", color = "grey22", size = 5)

SB_Island

#Add in receiver location (for those recievers that have lat/longs)
SB_Island <- ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(-119.8, -119.0), ylim = c(33.1, 33.5), expand = FALSE) +
  theme(legend.position = "none", axis.title.x = element_blank(), 
        axis.title.y = element_blank(), 
        panel.border = element_rect(fill = NA)) +
  annotation_scale(location = "bl", width_hint = 0.2, 
                   pad_x = unit(0.1, "in"), pad_y = unit(0.1, "in")) +
  annotate(geom = "text", x = -119.51, y = 33.25, label = "Santa Barbara Island", 
           fontface = "italic", color = "grey22", size = 5) +
  annotate(geom = "text", x = -119.02488, y = 33.48818, label = "SB-1", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.0228, y = 33.48382, label = "SB-10", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.03173, y = 33.490633, label = "SB-2", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04056, y = 33.48695, label = "SB-3", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04763, y = 33.47595, label = "SB-5", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04572, y = 33.468, label = "SB-6", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04183, y = 33.46367, label = "SB-7", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.0348, y = 33.46065, label = "SB-8", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.02602, y = 33.47087, label = "SB-9", 
           fontface = "italic", color = "grey22", size = 2)
SB_Island

## Receiver locations, no island 
ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(-119.1, -119.0), ylim = c(33.45, 33.5), expand = FALSE) +
  theme(legend.position = "none", axis.title.x = element_blank(), 
        axis.title.y = element_blank(), 
        panel.border = element_rect(fill = NA)) +
  annotation_scale(location = "bl", width_hint = 0.2, 
                   pad_x = unit(0.1, "in"), pad_y = unit(0.1, "in")) +
  annotate(geom = "text", x = -119.51, y = 33.25, label = "Santa Barbara Island", 
           fontface = "italic", color = "grey22", size = 5) +
  annotate(geom = "text", x = -119.02488, y = 33.48818, label = "SB-1", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.0228, y = 33.48382, label = "SB-10", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.03173, y = 33.490633, label = "SB-2", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04056, y = 33.48695, label = "SB-3", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04763, y = 33.47595, label = "SB-5", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04572, y = 33.468, label = "SB-6", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.04183, y = 33.46367, label = "SB-7", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.0348, y = 33.46065, label = "SB-8", 
           fontface = "italic", color = "grey22", size = 2) +
  annotate(geom = "text", x = -119.02602, y = 33.47087, label = "SB-9", 
           fontface = "italic", color = "grey22", size = 2)