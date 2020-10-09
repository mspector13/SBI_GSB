## home range project ## Fall 2018 ## c.nasr ##

if(!require(rgdal)){
  install.packages("rgdal")
  require(rgdal)
}

if(!require(rgeos)){
  install.packages("rgeos")
  require(rgeos)
}

install.packages("adehabitatHR")
library(adehabitatHR)

#uninstall.packages("prettymapr")
#library(prettymapr)


if(!require(rgdal)){
  install.packages("rgdal")
}

require(adehabitatHR)
require(maptools)
require(raster)
require(rgdal)

# First, set your working directory so that the following line of code will work.

cn.pts <- read.csv(file.choose())
attach(cn.pts)
head(cn.pts)

#NOTE: cn.pts is Claire's dataset

# Okay so here's the first big trouble you'll need to deal with whenever working
# with time-based data in R. There's a special class of data called "POSIXct"

?POSIXct

# Basically, it's a fancy date field that lets R deal with data that is time-
# specific. As you get into your home range analysis, you may have to grapple
# with this. Our porcupine GPS data has date stored in one column and time
# stored in separate columns and, worse, they're both factors:

#these are names of columns in Claire's .csv file
class(Date)
class(Time)


cn.pts$realdate <- posix
head(cn.pts)

# Now I'm going to create a SpatialPointsDataFrame from that data.frame:
#Claire's original df: 
#Name	lat	long	
#CNS	39.811983	-121.906233
#in the GSB data frame: 
cn.sp <- SpatialPointsDataFrame(data.frame(long, lat), 
                                 proj4string = CRS("+proj=longlat +datum=WGS84"), data=cn.pts)


## subsetting the data
#GSB data could be subsetted for a particular TRANSMITTER
CNS.subset <- subset(cn.sp, Name=="CNS")



## plotting the data
plot(cn.sp, pch=16)
par(bg="honeydew")


## adding points to the orginal points too see all together
points(CNS.subset, pch=16, col="darkcyan")


## adding points individually to compare to arcmap 
plot(CNS.subset, pch=16, col="darkcyan")


## turning points from csv to shape so I can look at them  in ArcMap
writeOGR(cn.sp, ".", "spatialpoints", driver = "ESRI Shapefile")
writeOGR(CNS.subset, ".", "CNSspatialpoints", driver = "ESRI Shapefile")


#defining MCP's
#Columns needed = "name", "lat", "long"
CN.mcp <- mcp(cn.sp, percent=100) #percent =100, use 100 of the points
CNS.mcp <- mcp(CNS.subset, percent=100)

## turning mcp into a shape file:
writeOGR(CN.mcp, dsn= '.', "CNTOTALMCPnew", driver = "ESRI Shapefile")
writeOGR(CNS.mcp, dsn= '.', "CNSMCPnew", driver = "ESRI Shapefile")



## plotting the MCP's
plot(CN.mcp, add=TRUE, cex=1.5)
plot(CNS.mcp, add=TRUE, cex=1.5)

as.data.frame(CNS.mcp)

## creating KDE's of all points and the subsets
KDE.cn.allpoints <- kernelUD(cn.sp)
KDE.CNS <- kernelUD(CNS.subset)



## plotting all points and KDE's
plot(KDE.cn.allpoints)
plot(KDE.CNS)



## investigating information of h-ref
KDE.cn.allpoints@h ## looks like href is .2008727
KDE.CNS@h ## href is .3464335

#DO NOT ASSUME THE HREF IS CORRECT. NEEDS TO BE GROUNDTRUTHED FROM REAL DATA

## HOMERANGE FOR ALL BEHAVIORS ##

test.homerange <- kernelUD(cn.sp, extent=1, grid=100, h=.6) #h here = href, 
#extent has to do with raster data(?); google "what is extent in ArcMap"
#grid may have to do with pixelization 

print(test.homerange)
plot(test.homerange) ## rainbow, but not the vertices

cn.total.homerange <- getverticeshr(test.homerange, percent=95)
#plot(cn.total.homerange, col="aquamarine4", main="95% home range") ## boring, but matches arcmap

points(cn.sp, pch=16)
points(CNS.subset, pch=16, col="darkcyan")

