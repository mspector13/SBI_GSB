#Dummy data selected for tutorial, thanks Kris! ####
#vector_lon<- c(-0.5485381346101759,-0.5482220594232723,-0.5482298619861881) # Sample
#vector_lat <- c(53.2285150736142, 53.22842450827133, 53.22841205254449) # Sample

#grid_zero_lat <- 53.2286160736142 # Sample
#grid_zero_lon <- -0.5486371346101759 # Sample

r_earth = 6371*1000 # Earth's radius in meters

# Convert latitude
m_per_deg_lat <- 111000 # Meters per degree of latitude
vector_lat_grid <- abs(vector_lat-grid_zero_lat)*m_per_deg_lat

# Convert longitude
vector_lon_grid <- (((2*pi)*(cos((pi/180)*vector_lat)*r_earth))/360)*abs(vector_lon-grid_zero_lon)
plot(vector_lat_grid, vector_lon_grid)

#GSB Data ####
#Make a new dataframe "Coords" from the x, y columns in Trans_ID
Coords <- Trans_ID %>% 
  dplyr::select(x, y)

Longs <- Coords$x
Lats <- Coords$y
zero_long <- -119.053803
zero_lat <- 33.462234
y1 <- abs(Lats-zero_lat)*m_per_deg_lat

x1<- (((2*pi)*(cos((pi/180)*Lats)*r_earth))/360)*abs(Longs-zero_long)
plot(y1, x1)

Coords1 <- cbind(x1,y1) 

Trans_ID <- Trans_ID %>% 
  add_column(x1, .after = "x") %>% 
  add_column(y1, .after = "y")



