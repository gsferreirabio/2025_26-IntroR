################################################################################
# Day 06: Analysing fossil occurrences data

# Data derived from the Paleobiology Database https://paleobiodb.org/

# Let's use the package paleobioDB
## https://docs.ropensci.org/paleobioDB/index.html

install.packages("paleobioDB")
library(paleobioDB)

?pbdb_occurrences()  ## this function will download data from the PBDB
# look at the link to search for the variables we can download
testudines <- pbdb_occurrences(base_name = "Testudines",
                               interval = "Cenozoic",
                               show = c("coords", "classext", "paleoloc"),
                               limit = "all", 
                               vocab = "pbdb")  ## vocab makes better names

dim(testudines)  ## 5731 occurrences
head(testudines, 3)  ## let's look at the head of the dataframe
# max_ma & min_ma are the range in millions of years (annum)
# lng & lat are geographic coordinates


?pbdb_map  ## Map fossil records
pbdb_map(data = testudines)


# let's change the colors of the plots and the scale of occurrences
install.packages("viridisLite")
library(viridisLite)

testudines.map = pbdb_map(data = testudines,
                          col_int = "grey80",
                          pch = 16,
                          col_ocean = "lightblue",
                          col_point = viridis(5))

testudines.map

# This will map the richness of the occurrences using a raster (grid)
pbdb_map_richness(data = testudines, 
                  rank = "genus",
                  res = 5,
                  col_int = "grey80",
                  col_ocean = "lightblue",
                  col_rich = viridis(10),
                  title = "Genus richness")

# and we can plot by different ranks
pbdb_map_richness(data = testudines, 
                  rank = "species",
                  res = 5,
                  col_int = "grey80",
                  col_ocean = "lightblue",
                  col_rich = viridis(10),
                  title = "Species richness")

pbdb_map_richness(data = testudines, 
                  rank = "family",
                  res = 5,
                  col_int = "grey80",
                  col_ocean = "lightblue",
                  col_rich = viridis(10),
                  title = "Family richness")

# and also change the resolution of the raster grid
pbdb_map_richness(data = testudines, 
                  rank = "genus",
                  res = 2,
                  col_int = "grey80",
                  col_ocean = "lightblue",
                  col_rich = viridis(10),
                  title = "Family richness")

##############################################
## How to plot a specific region? did not work
pbdb_map_richness(data = testudines, 
                  rank = "family",
                  res = 10,
                  col_int = "grey80",
                  col_ocean = "lightblue",
                  col_rich = viridis(10), 
                  regions = "Europe")
##############################################
# Other nice features of the paleobioDB package

# Temporal range of taxa
pbdb_temp_range(testudines,
                rank = "family")

pbdb_temp_range(testudines,
                rank = "genus",
                col = "#0055AA")

# Richness through time
pbdb_richness(testudines, 
              rank = "species", 
              ylab = "Number of Species")


# define the temporal extent of the plot, default = 0:10
pbdb_richness(testudines, 
              rank = "species", 
              ylab = "Number of Species", 
              temporal_extent = c(0, 23))

# change the resolution, default = 1
pbdb_richness(testudines, 
              rank = "genus", 
              ylab = "Number of Species", 
              res = 0.5)  ## looks more detailed

pbdb_richness(testudines, 
              rank = "genus", 
              ylab = "Number of Species", 
              res = 0.1)  ## maybe too much

# and change the color
pbdb_richness(testudines, 
              rank = "genus", 
              ylab = "Number of Species", 
              res = 0.5,
              col = "#A0A00F30",
              bord = "#A0A00F")  ## looks more detailed



# Patterns of origination and extinction
pbdb_orig_ext(testudines,
              rank = "genus",
              temporal_extent = c(0, 66))

# change the resolution
pbdb_orig_ext(testudines,
              rank = "genus",
              temporal_extent = c(0, 66),
              orig_ext = 1,  ## this argument defines whether origination
              res = 2)

pbdb_orig_ext(testudines,
              rank = "genus",
              temporal_extent = c(0, 66),
              orig_ext = 2,  ## or extinction
              res = 2)



################################################################################
# Data analysis with Palaeoverse

# Let's download directly from github
install.packages("devtools")  ## devtools allows us to download from ext. source
devtools::install_github("palaeoverse/palaeoverse")
library(palaeoverse)

# Generate time bins
dev.off()  ## clear plot window

?time_bins()
time_bins(interval = "Cenozoic")
time_bins(interval = "Cenozoic", plot = TRUE)

# we can also save it to an object
bins <- time_bins(interval = c("Mesozoic", "Cenozoic"), plot = TRUE)

# then we can assign the fossil occurrences to those time bins
?bin_time

# the occurrences dataframe already contains this info
head(testudines)

#but with bin_time we can use different methods
testudines.binned <- bin_time(occdf = testudines, 
                              bins = bins,
                              method = "majority")


# Calculate and plot temporal range of fossil taxa by genus
?tax_range_time
tax_range_time(testudines, 
               name = "genus",
               plot = TRUE)
# some NAs

# remove NAs
testudines.nNAs <- subset(testudines, !is.na(genus))

tax_range_time(testudines.nNAs, 
               name = "genus",
               plot = TRUE)

# and now by family
testudines.nNAs <- subset(testudines, !is.na(family))
tax_range_time(testudines.nNAs, 
               name = "family",
               plot = TRUE,
               plot_args = list(ylab = "Families",
                                pch = 15,
                                col = "grey30",
                                lty = 2))


# Generate palaeocoordinates based on actual coordinates
?palaeorotate  
# again, the palaeocoordinates are contained in the original occurrences 
## dataframe (if selected), but with this function you can use different models
## and methods for rotating them

palaeorotate(testudines.binned, age = "bin_midpoint")  ## this uses an internet
# external connection and might not be available

testudines.palaeocoord <- palaeorotate(testudines.binned, age = "bin_midpoint")

names(testudines.palaeocoord)  ## rot_model, p_lng, p_lat

# the look_up function will convert the interval values derived from the pbdb
## dataframe into official numeric ages based on the intervals of the 
## International Comission on Stratigraphy (ICS). This is useful for 
## standardizing data from different sources.

# It will also calculate the midpoint of the temporal range for each occurrence
?look_up
testudines.palaeocoord <- look_up(testudines.palaeocoord, 
                                  early_interval = "early_interval", 
                                  late_interval = "late_interval", 
                                  int_key = interval_key)

# we can now plot those occurrences per time bin and per paleo_lat, for example
plot(x = testudines.palaeocoord$interval_mid_ma,
     y = testudines.palaeocoord$p_lat,
     xlab = "Time (Ma)",
     ylab = "Palaeolatitude (\u00B0)",
     xlim = c(66, 0), 
     xaxt = "n",
     pch = 20,
     cex = 1.5)

# let's change the points a bit
plot(x = testudines.palaeocoord$interval_mid_ma,
     y = testudines.palaeocoord$p_lat,
     xlab = "Time (Ma)",
     ylab = "Palaeolatitude (\u00B0)",
     xlim = c(66, 0), 
     xaxt = "n",
     pch = 20,
     col = rgb(0, 0, 0, 0.3),
     cex = 1.5)

# Add geological time scale
axis_geo(side = 1, 
         intervals = "epoch")


################################################################################
# Project: color the data points by family
# Plot occurrences per time bin highlighting the fossil record of three families 
## of turtles
# Look at the graph


che.col <- rgb(102/255, 194/255, 165/255, 0.8)
pod.col <- rgb(141/255, 160/255, 203/255, 0.8)
tri.col <- rgb(252/255, 141/255, 98/255, 0.8)

plot(x = testudines.palaeocoord$interval_mid_ma,
     y = testudines.palaeocoord$p_lat,
     xlab = "Time (Ma)",
     ylab = "Palaeolatitude (\u00B0)",
     xlim = c(66, 0), 
     xaxt = "n",
     pch = 20,
     col = rgb(0.8, 0.8, 0.8, 0.1),
     cex = 1.5)
points(x = testudines.palaeocoord$interval_mid_ma[which(testudines.palaeocoord$family == "Trionychidae")],
       y = testudines.palaeocoord$p_lat[which(testudines.palaeocoord$family == "Trionychidae")],
       pch = 20,
       col = tri.col,
       cex = 1.8)
points(x = testudines.palaeocoord$interval_mid_ma[which(testudines.palaeocoord$family == "Chelidae")],
       y = testudines.palaeocoord$p_lat[which(testudines.palaeocoord$family == "Chelidae")],
       pch = 20,
       col = che.col,
       cex = 1.8)
points(x = testudines.palaeocoord$interval_mid_ma[which(testudines.palaeocoord$family == "Podocnemididae")],
       y = testudines.palaeocoord$p_lat[which(testudines.palaeocoord$family == "Podocnemididae")],
       pch = 20,
       col = pod.col,
       cex = 1.8)


axis_geo(side = 1, 
         intervals = "epoch")
legend("topright", 
       legend = c("Chelidae", "Podocnemididae", "Trionychidae"),
       col = c(che.col, pod.col, tri.col),
       bty = "n",
       cex = 0.8,
       pt.cex = 1.8,
       pch = 20)
