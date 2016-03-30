install.packages('pycno')
install.packages("rgeos")
require(rgeos)
require(pycno)
require(sp)
# Read in data for North Carolina as a SpatialPolygonsDataFrame (Don't understand this code!)
nc.sids <- readShapeSpatial(system.file("shapes/sids.shp", package="maptools")[1],
                            IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
nc.sids <- spTransform(nc.sids, CRS("+proj=longlat +datum=WGS84"))

# Compute the pycnophylactic surface for 1974 births as a SpatialGridDataFrame
# Note probably shouldn't really base grid cells on Lat/Long coordinates
# This example just serves to illustrate the use of the function
births74 <- pycno(nc.sids,nc.sids$BIR74,0.05, converge=3)
# Draw it
library(RColorBrewer)
image(births74, col=rev(brewer.pal(9, "Blues")))
# Overlay North Carolina county boundaries for reference
plot(nc.sids,add=TRUE)

library(ggmap)
map1 <- get_map(c(-80.793457, 35.782169), zoom = 6, maptype = "toner", source = "stamen")
map1 <- ggmap(map1)
map1


require(ggplot2)
require(dplyr)
nc.sids@data$id = rownames(nc.sids@data)
nc.sids.points = fortify(nc.sids, region="id")
nc.sids.df = inner_join(nc.sids.points,nc.sids@data, by="id")
nc.sids <- spTransform(nc.sids, CRS("+proj=longlat +datum=WGS84"))

plainpolys <- map1 + geom_polygon(aes(x=long, y=lat, group=id,fill=BIR74), size=.2, color='black', 
                                  data=nc.sids.df) + scale_fill_brewer(palette="Dark2")
plainpolys

# Read in data for North Carolina as a SpatialPolygonsDataFrame
nc.sids <- readShapeSpatial(system.file("shapes/sids.shp", package="maptools")[1],
                            IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
# Compute the pycnophylactic surface for 1974 births as a SpatialGridDataFrame
# Note probably shouldn't really base grid cells on Lat/Long coordinates
# This example just serves to illustrate the use of the functions
births74 <- pycno(nc.sids,nc.sids$BIR74,0.05,converge=1)
# Create a new 'blocky' set of zones
blocks <- gUnionCascaded(nc.sids,1*(coordinates(nc.sids)[,2] > 36) +
                           2*(coordinates(nc.sids)[,1] > -80))
# Plot the bloocky zones
plot(blocks)
# Aggregate data to them
estimates <- estimate.pycno(births74,blocks)
# Write the estimates on to the map
text(coordinates(blocks),as.character(estimates))


# Read in data for North Carolina as a SpatialPolygonsDataFrame
nc.sids <- readShapeSpatial(system.file("shapes/sids.shp", package="maptools")[1],
                            IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
# Compute the pycnophylactic surface for 1974 births as a SpatialGridDataFrame
# Note probably shouldn't really base grid cells on Lat/Long coordinates
# This example just serves to illustrate the use of the function
# It is suggested to use a higher value for 'converge' - this value justs speeds
# things up for the example.
births74 <- pycno(nc.sids,nc.sids$BIR74,0.05,converge=1)
# Draw it
image(births74)
# Overlay North Carolina county boundaries for reference
plot(nc.sids,add=TRUE)
