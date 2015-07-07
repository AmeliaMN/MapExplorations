makePolys <- function(lat, lon, howmany){
  # Find the perimeter of the data
  latrange <- range(lat)
  lonrange <- range(lon)
  
  #start the boxes
  latitudes <- latrange[1]
  longitudes <- lonrange[1]
  
  #make breakpoints
  for (i in 1:(howmany)){
    latitudes[i+1] <- latitudes[i] + (latrange[2]-latrange[1])/howmany
    longitudes[i+1] <- longitudes[i] + (lonrange[2]-lonrange[1])/howmany
  }
  
  #build the boxes
  polys <- list()
  a <- 1
  for (i in 1:howmany){
    for (j in 1:howmany){
      polytmp <- data.frame(lon=c(longitudes[i], longitudes[i], longitudes[i+1], longitudes[i+1], longitudes[i]), lat=c(latitudes[j], latitudes[j+1], latitudes[j+1], latitudes[j], latitudes[j]))
      polytmp <- Polygon(polytmp)
      polys[a] <- Polygons(list(polytmp), letters[a])
      a <- a+ 1 
    }
  }
  return(polys)  
}