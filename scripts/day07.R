################################################################################
# Day 07
################################################################################
# Maps in R
# There is a very good book for those interested in Spatial analyses and maps
## called Spatial Data Science. It is free: https://r-spatial.org/book/
install.packages("terra")
install.packages("geodata")
library(terra)
library(geodata)

# import a world countries map
countries <- world(resolution = 5, path = "maps")
head(countries)

plot(countries)

# import a table with country codes and continents
cntry.codes <- country_codes()
head(cntry.codes)

# add this table to the countries map attributes
?merge
countries <- merge(x = countries, 
                   y = cntry.codes, 
                   by.x = "GID_0", ## this info should be in the other df
                   by.y = "ISO3",  ## that means the GID_0 and ISO3 are the same
                   all.x = TRUE)

head(countries)

# plot the map of countries coloured according to "continent"
plot(x = countries, 
     y = "continent", 
     lwd = 0.2,  ## line width
     main = "Countries by continent")


# let's ignore the country borders
# dissolve (aggregate) countries into a continents map
continents <- aggregate(countries, by = "continent")
values(continents)
plot(continents, "continent", lwd = 0.2)

# note that each continent is a multi-part polygon including mainland and islands
## for example, let's look at Africa
plot(continents[1,])

# disaggregate continent polygons, to then separate islands and mainlands
?disagg
continents <- disagg(continents)
continents

# get a map of just the continent mainlands (largest polygons)
unique(continents$continent)
largest <- (order(expanse(continents), decreasing = TRUE))[1:length(unique(continents$continent))]
# keep only the largest element from each continent
mainlands <- continents[largest,]  ## combine them in a single object

plot(mainlands, "continent", lwd = 0.2, main = "Continent mainlands")

# now just get a map of just the islands
islands <- erase(continents, mainlands)  ## erase mainlands from continents
plot(islands, "continent", lwd = 0.2, main = "World islands")

# you can then crop and mask a raster map to given islands or continents
# get data from data elevation
?elevation_global
elevation <- elevation_global(res = 10, path = "maps")  ## resolution can be changed

# let's separate Africa
afr_mainland <- subset(mainlands, mainlands$continent == "Africa")
# crop the elevation dataset based on afr_mainland
elev_afr_mainland <- crop(elevation, afr_mainland, mask = TRUE)
# and now plot
elev_afr_plot <- plot(elev_afr_mainland, main = "Elevation in mainland Africa")

# you can also use different colors
# function gray()
plot(elev_afr_mainland, col = (gray(seq(0.1,0.9,length.out = 100))))
plot(elev_afr_mainland, col = (gray(seq(0.9,0.1,length.out = 100))))
# function map.pal
plot(elev_afr_mainland, col = (map.pal("elevation", n = 100)))
plot(elev_afr_mainland, col = (map.pal("haxby", n = 100)))


# you can also compute a buffer around a given continent, and use it to crop
## marine layers to get only the near-shore waters to that continent
afr <- subset(continents, continents$continent == "Africa")
afr_buff <- terra::buffer(afr, width = 200000)  ## 200km
afr_buff <- terra::buffer(afr_mainland, width = 200000)  ## 200km
plot(afr_buff, col = "darkblue", background = "lightblue")
plot(afr_mainland, col = "tan", add = TRUE)


# import a marine variable, e.g., bathymetry
bathy_source <- "https://gebco2023.s3.valeria.science/gebco_2023_land_cog.tif"
bathy <- terra::rast(bathy_source, vsi = TRUE)

afr_bathy <- terra::crop(bathy, afr_buff, mask = TRUE)
plot(afr_bathy, col = hcl.colors(100, "blues"))
plot(countries, col = "tan", add = TRUE)

plot(afr_bathy, col = hcl.colors(100, "blues"))
plot(elev_afr_mainland, col = (gray(seq(0.9,0.1,length.out = 100))), add = TRUE)

# most importantly, you can plot points on top of these maps
points(x = 0, y = 20, pch = 16, cex = 2, col = "pink")



################################################################################
# Palaeogeographic maps
# gplatesr downloads data from the GPlates Web Service and can reconstruct
## palaeocoordinates
# check here how to download: 
## https://gwsdoc.gplates.org/reconstruction/reconstruct-coastlines

# To download the maps we will use the function st_read
library(sf)
paleocoastlines.url <- "http://gws.gplates.org/reconstruct/coastlines/?time=72&model=GOLONKA"

paleocoastlines <- st_read(paleocoastlines.url)

# check it
plot(paleocoastlines)

# to plot the paleomap we will use ggplot because it has a function geom_sf
library(ggplot2)

ggplot() +
  geom_sf(data = paleocoastlines) +
  labs(title = "Maastrichtian Paleomap") 


# now let's download some data from the Maastrichtian

dinosaurs.maastr <- pbdb_occurrences(base_name = "Dinosauria",
                                     interval = "Maastrichtian",
                                     show = c("coords", "classext", "paleoloc"),
                                     limit = "all", 
                                     vocab = "pbdb",
                                     pgm = "gplates")

# now to plot the points using ggplot we include the geom_point() function
ggplot() +
  geom_sf(data = paleocoastlines) +
  labs(title = "Maastrichtian Paleomap") +
  geom_point(data = dinosaurs.maastr,
             aes(x = paleolng, y = paleolat))

# and we can modify the plot, for example
ggplot() +
  geom_sf(data = paleocoastlines, fill = "grey80", color = "black") +
  labs(title = "Maastrichtian Paleomap")+
  theme_minimal() +
  geom_point(data = dinosaurs.maastr,
             aes(x = paleolng, y = paleolat),
             colour = "purple",
             alpha = 0.3,
             show.legend = FALSE)


# we can also use base R to plot
plot(paleocoastlines$geometry)
points(x = dinosaurs.maastr$paleolng, 
       y = dinosaurs.maastr$paleolat, 
       pch = 16, 
       col = "#9a0aff8a")




################################################################################
# Project: Elevation map of the Americas (North and South) with 200 km sea line
## plotting the occurrences of Dinosauria
## TIP: you will need to use the OR operator | when subsetting the map



# you can also compute a buffer around a given continent, and use it to crop
## marine layers to get only the near-shore waters to that continent
sam <- subset(continents, continents$continent == "South America")
sam_buff <- terra::buffer(sam, width = 200000)  ## 200km
plot(sam_buff, col = "darkblue", background = "lightblue")
plot(sam, col = "tan", add = TRUE)


# import a marine variable, e.g., bathymetry
bathy_source <- "https://gebco2023.s3.valeria.science/gebco_2023_land_cog.tif"
bathy <- terra::rast(bathy_source, vsi = TRUE)

sam_bathy <- terra::crop(bathy, sam_buff, mask = TRUE)
plot(sam_bathy, col = hcl.colors(100, "blues"), xlim = c(-12, 53))
plot(countries, col = "tan", add = TRUE)

# you can then crop and mask a raster map to given islands or continents
elevation <- elevation_global(res = 10, path = "maps")
eurasia <- subset(continents, 
                  continents$continent == "Europe" | continents$continent == "Asia")
elev_eurasia <- crop(elevation, eurasia, mask = TRUE)
elev_eurasia_plot <- plot(elev_eurasia, 
                          main = "Elevation in Eurasia",
                          col = (gray(seq(0.9,0.1,length.out = 100))),
                          xlim = c(-12, 200))

elev_globe <- crop(elevation, continents, mask = TRUE)
plot(elev_globe,
     xlim = c(-12, 195),
     ylim = c(90, -5),
     main = "Testudinidae occurrences in Eurasia",
     col = (gray(seq(0.9, 0.1, length.out = 100))))

plot(countries, add = TRUE)
points(testudines$lng[which(testudines$family == "Testudinidae")], 
       testudines$lat[which(testudines$family == "Testudinidae")], 
       pch = 16,
       col = "purple")
plot(elev_afr_mainland, col = (gray(seq(0.9, 0.1, length.out = 100))),
     axes = FALSE, add = TRUE)
plot(countries[which(countries$continent == "Africa")], add = TRUE)





dim(testudines[which(testudines$family == "Testudinidae"),])
testudines.lookup <- look_up(testudines,
                             int_key = interval_key,
                             assign_with_GTS = "GTS2020")
as.factor(testudines.lookup$early_stage)
bins$interval_name


testudines.colored <- testudines 

names(testudines.colored)[10] <- "interval_name"
names(bins)
testudines.colored <- merge(testudines.colored, bins, by = "interval_name", all.x = TRUE)
names(testudines.colored)

names(testudines)

points(testudines$lng[which(testudines$family == "Testudinidae")], 
       testudines$lat[which(testudines$family == "Testudinidae")], 
       pch = 16,
       col = testudines.colored$colour)