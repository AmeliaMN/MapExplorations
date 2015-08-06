library(ggplot2)
library(foreign)
library(RgoogleMaps)
library(rgeos)
library(ggmap)
library(rgdal)
require(maptools)
require(dplyr)
source("makePolys.R")

earthquakes <- read.table("data/2014earthquakes.catalog", sep="")
names(earthquakes) <- c("Date", "Time", "ET", "MAG", "M", "lat", "long", "depth", "Q", "EVID", "NPH", "NGRM")
earthquakes <- filter(earthquakes, lat<36, lat>31, long<(-116), long>(-120))
rownames(earthquakes) <- NULL
coordinates(earthquakes) <-~long+lat
proj4string(earthquakes) <- CRS("+proj=longlat +datum=WGS84")

map1 <- get_map(c(-118.2500, 34.0500), zoom = 8, maptype = "toner", source = "stamen")
map1 <- ggmap(map1)
map1

colorscheme <- scale_fill_continuous(high="#FF0000", low="#4c0000")

shinyServer(
  function(input, output){
    output$map <- renderPlot({
      howmany <- input$howmany
      latitudes <- c(input$lat, range(earthquakes$lat)[2])
      longitudes <- c(input$lon, range(earthquakes$long)[2])
      polygons <- makePolys(latitudes, earthquakes$long, howmany)
      polygons = SpatialPolygons(polygons)
      proj4string(polygons) <- CRS("+proj=longlat +datum=WGS84")
          
      polydata <- data.frame(id=letters[1:(howmany*howmany)], index=c(1:howmany*howmany))
      rownames(polydata) <- letters[1:(howmany*howmany)]
      
      polygons2 <- SpatialPolygonsDataFrame(polygons, polydata)
      
      polygons2@data$id = rownames(polygons2@data)
      polygons2.points = fortify(polygons2, region="id")
      polygons2.df = inner_join(polygons2.points, polygons2@data, by="id")
      
      quakesBox <- over(y=polygons2, x=earthquakes)
      numQuakesBox <- summarise(group_by(quakesBox, id), numquakes=n())
      quakesBox2 <- left_join(polygons2.df,numQuakesBox, all.x=TRUE)
    

      quakemap <- map1 + geom_polygon(aes(x=long, y=lat, group=id, fill=numquakes), size=.2, data=quakesBox2[is.na(quakesBox2$numquakes)==FALSE,])
      print(quakemap + colorscheme)  
    })
    
  }
  )


