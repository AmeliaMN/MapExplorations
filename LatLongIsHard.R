#trouble with coordinates()

# #Doesn't work
# babydata <- data.frame(latitude=c(-89, 89), longitude=c(-179, 179))
# coordinates(babydata) <-~latitude+longitude
# proj4string(babydata) <- CRS("+proj=longlat +datum=WGS84")

#Does work
babydata <- data.frame(latitude=c(-89, 89), longitude=c(-179, 179))
coordinates(babydata) <-~longitude+latitude
proj4string(babydata) <- CRS("+proj=longlat +datum=WGS84")


babydata <- data.frame(latitude=c(32, 36), longitude=c(-121, -114))
coordinates(babydata) <-~longitude+latitude
proj4string(babydata) <- CRS("+proj=longlat +datum=WGS84")

babydata <- data.frame(latitude=c(32, 36), longitude=c(-121, -114))


