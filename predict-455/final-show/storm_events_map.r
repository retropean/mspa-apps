library(plyr)
library(ggplot2)
library(extrafont)
library(rworldmap)
Sys.setenv(R_GSCMD="C:/Program Files/gs/gs9.05/bin/gswin32c.exe")

# Hex codes according to our Style Guide as defined in Checkpoint B
HEX_BLUE <- "#17445F"
HEX_YELLOW <- "#F6F4C9"
HEX_TURQUOISE <- "#82BEB6"
HEX_EMERALD <- "#CCE6CB"
HEX_MENTHOL <- "#858A76"
HEX_LIGHT_BLUE <- "D6DDE8"

# Read files
setwd('C:/Users/00811289/Documents/github/pred-455/storm_events_data/locations/')
directory_location <- getwd()

file_names <- dir(directory_location)
locations <- NULL

for (file in file_names){
  temp_locations <-read.table(file, header=TRUE, sep=",")
  locations <- rbind(locations, temp_locations)
  rm(temp_locations)
}

summary(locations)
head(locations)
locations$storm_year <- substr(locations$YEARMONTH,0,4)

# First attempt with rworldmap
newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-120, -70), ylim = c(22, 50), asp = 1)
points(locations$LONGITUDE, locations$LATITUDE, col = locations$storm_year, cex = .6)

# Second attempt with ggmap
library(ggmap)
#map <- get_map(location = 'America', zoom = 1)
map <- get_map(location = c(-124.85,24.39,-66.88,49.39), zoom = 2)
  
mapPoints <- ggmap(map) + geom_point(aes(x = LONGITUDE, y = LATITUDE, color=storm_year), data = locations, alpha = .2) +
  scale_x_continuous(limits = c(-124.85,-50), expand = c(0, 0)) +
  scale_y_continuous(limits = c(15,49.39), expand = c(0, 0))
mapPoints

# Attempt 3, panel
locations1[locations$storm_year == 1996] <- locations
yr2017 <- subset(locations, storm_year == 2017)
yr2010 <- subset(locations, storm_year == 2010)
yr2000 <- subset(locations, storm_year == 2000)
plot_yrs <- rbind(yr2017, yr2010, yr2000)


map <- get_map(location = c(-124.85,-65,23,49.39), zoom = 5, maptype="toner-lines")
mapPoints <- ggmap(map) + 
  geom_point(aes(x = LONGITUDE, y = LATITUDE), color=HEX_MENTHOL, data = plot_yrs, alpha = .05) +
  scale_x_continuous(limits = c(-124.85,-65), expand = c(0, 0)) +
  scale_y_continuous(limits = c(23,49.39), expand = c(0, 0)) + 
  ggtitle("Storm Locations Over Time") +
  theme(legend.position="none",
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", linetype = 'solid', fill=NA, size=),
        panel.background = element_blank())
mapPointsFacets <- mapPoints +   facet_grid(. ~ storm_year)
# plot the map
mapPointsFacets

