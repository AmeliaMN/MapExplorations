library(rCharts)
map <- Leaflet$new()
map$setView(c(34.0500, -118.2500), zoom = 13)
map$tileLayer(provider = 'Stamen.Toner')
map$marker(
  'restaurants.json'
)
map


blocks <- readOGR("tl_2013_06_tabblock", "tl_2013_06_tabblock")
LAblocks <- blocks[blocks$COUNTYFP == "037",]
writeOGR(LAblocks, ".", "LAblocks", driver="ESRI Shapefile")
LAblocks <- readOGR(".", "LAblocks")
LAblocks$COUNTYFP <- factor(LAblocks$COUNTYFP)

blocks <- spTransform(LAblocks, CRS("+proj=longlat +datum=WGS84"))
mini <- blocks[blocks$BLOCKCE10 == "1000",]
mini <- fortify(mini)

library(ggplot2)
library(foreign)
library(RgoogleMaps)
library(ggmap)



map1 <- get_map(c(lon=CenterOfMap$lon, lat=CenterOfMap$lat), zoom = 12, maptype = "toner", source = "stamen")
map1 <- ggmap(map1)
map1


map1 <- map1 + geom_polygon(aes(x=long, y=lat, group=group), fill='grey', size=.2,color='green', data=mini, alpha=0)
map1

# What did I learn? Blocks are small. Too small. 