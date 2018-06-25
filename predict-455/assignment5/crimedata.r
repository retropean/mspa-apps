library(plyr)
library(ggplot2)
library(rworldmap)
library(googleVis)
library(ggmap)

setwd("C:/Users/00811289/Desktop/Assignment_5_googleVis")
crimedata <- read.csv("crimedata2017.csv", header = TRUE)

summary(crimedata)

# Focus on top 5 in crimedata$OFFENSE: THEFT/OTHER, THEFT F/AUTO, MOTOR VEHICLE THEFT, ROBBERY, ASSAULT W/DANGEROUS WEAPON, BURGLARY
crimedata_top5 <- subset(crimedata, (OFFENSE == "THEFT/OTHER" | 
                                       OFFENSE == "THEFT F/AUTO" | 
                                       OFFENSE == "MOTOR VEHICLE THEFT" | 
                                       OFFENSE == "ROBBERY" |
                                       OFFENSE == "ASSAULT W/DANGEROUS WEAPON" |
                                       OFFENSE == "BURGLARY" ))

map <- get_map(location = "washington dc", zoom = 11, maptype="toner-lite")
mapPoints <- ggmap(map) + 
  geom_point(aes(x = LONGITUDE, y = LATITUDE, color=OFFENSE), data = crimedata_top5, alpha = .05) +
  scale_x_continuous(limits = c(-77.15,-76.90), expand = c(0, 0)) +
  scale_y_continuous(limits = c(38.80,39.00), expand = c(0, 0)) + 
  ggtitle("DC Crime Map") +
  theme(legend.position="none")
mapPoints


maptest <- get_map(location = "washington dc", zoom = 12, maptype="toner-lite")
ggmap(maptest)

map <- get_map(location = c(-124.85,24.39,-66.88,49.39), zoom = 2)

mapPoints <- ggmap(map) + geom_point(aes(x = LONGITUDE, y = LATITUDE, color=storm_year), data = locations, alpha = .2) +
  scale_x_continuous(limits = c(-124.85,-50), expand = c(0, 0)) +
  scale_y_continuous(limits = c(15,49.39), expand = c(0, 0))
mapPoints