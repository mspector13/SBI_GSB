#Let's see if the Capture-Mark-Recapture approach will work with these data. 
#Enter: CMRnet (doi: 10.1111/2041-210X.13502)

#To install the package via github
remotes::install_github("matthewsilk/CMRnet") #(build_vignettes = TRUE) if desired

library(CMRnet)
#Because the vignettes won't load
#https://matthewsilk.github.io/CMRnet/articles/CMRnet.html

#For this example we're going to use CMRnet's packaged data: 
data(cmrData)

data(cmrData3)

# Set parameters for the function ####

# Start Date
mindate <- "2010-01-01"
# End Date
maxdate <- "2015-01-01"
# Length of time in days within which individuals are considered to be co-captured
intwindow <- 60
# Length of each network window in months. We will use 5 12-month windows in this example
netwindow <- 12
# Overlap between network windows in months (we have no overlap in this example)
overlap <- 0
# Spatial tolerance for defining co-captures. Captures within a threshold distance (rather than simply at the same location) are considered when this is set to be greater than zero
spacewindow <- 0

# Create co-capture (social) networks ####
# index=FALSE indicates that we want edges to be weighted by the number of movements (see help pages for the alternative)
netdat <- DynamicNetCreate(
  data = cmrData,
  intwindow = intwindow,
  mindate = mindate,
  maxdate = maxdate,
  netwindow = netwindow,
  overlap = overlap,
  spacewindow = spacewindow,
  index=FALSE
)




#The high resolution DynamicNetCreateHi sets the interval window in minutes. ####
# Set parameters for the function
mindate <- "2019-12-01 00:00:00"
maxdate <- "2020-07-01 00:00:00"
# The interaction window is now in minutes. We set it to be one day here.
intwindow <- 24*60
# The network window is now in days
netwindow <- 20
# The overlap is now also in days
overlap <- 2
spacewindow <- 0

## Create high-resolution co-capture (social) networks
netdat_hi<-DynamicNetCreateHi(
  data=cmrData3,
  intwindow=intwindow,
  mindate=mindate,
  maxdate=maxdate,
  netwindow=netwindow,
  overlap=overlap,
  spacewindow=spacewindow,
  index=FALSE)

#Again the high resolution MoveNetCreateHi defines the interval window in minutes. ####
# Set parameters for the function
mindate <- "2019-12-01 00:00:00"
maxdate <- "2020-07-01 00:00:00"
# Interaction window is now in minutes
intwindow <- 30*24*60
# The network window is now in days
netwindow <- 60
#The overlap is now also in days
overlap <- 0
spacewindow <- 0

# Generate movement network
# nextonly=TRUE indicates that only direct movements between groups should be considered (see help pages)
movenetdat_hi <- CMRnet::MoveNetCreateHi(
  data = cmrData3,
  intwindow = intwindow,
  mindate = mindate,
  maxdate = maxdate,
  netwindow = netwindow,
  overlap = overlap,
  nextonly = TRUE,
  index=FALSE)

# 2: Conversion to igraph objects and plotting####
##Convert social networks into a list of igraph networks
cc_nets<-CMRnet::cmr_igraph(netdat_hi,type="social")

#Now we can plot the networks produced
#Setting fixed_locs to TRUE means nodes have the same coordinates in each plot
#Setting dynamic to FALSE and rows to 2 means we produce a multipanelled figure with 2 rows
#We can use additional arguments from the plot.igraph function. Here we suppress node labels as an example.
CMRnet::cmrSocPlot(nets=cc_nets,fixed_locs=TRUE,dynamic=FALSE,rows=4,vertex.label=NA)

##Convert social networks into a list of igraph networks (movement) 
m_nets<-CMRnet::cmr_igraph(movenetdat_hi,type="movement")
##Now we can plot the networks produced
#Setting fixed_locs to TRUE means nodes have the same coordinates in each plot
#Setting dynamic to FALSE and rows to 2 means we produce a multipanelled figure with 2 rows
#We can use additional arguments from the plot.igraph function. Here we suppress node labels as an example.
CMRnet::cmrMovPlot(nets=m_nets,fixed_locs=TRUE,dynamic=FALSE,rows=2,edge.arrow.size=0.5)
