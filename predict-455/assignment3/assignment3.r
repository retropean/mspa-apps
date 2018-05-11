library(ggplot2)
library(zoo)

deaths <- Seatbelts
summary(deaths)
deaths_data_frame <- as.data.frame(deaths)
head(deaths_data_frame)
# add date back to data frame
deaths_data_frame$date <- as.Date(time(deaths))

# Plot drivers killed/kms driven over time with moving average and annotated section indicating seatbelt law
plotting_object <- ggplot(deaths_data_frame, aes(x = date, y = DriversKilled/kms)) +
  geom_line() +
  geom_line(aes(y=rollmean(DriversKilled/kms, 12, na.pad=TRUE)),colour="olivedrab") + # Rolling average
  annotate("rect", xmin = as.Date("1983-02-01", "%Y-%m-%d"), 
           xmax = as.Date("1984-12-01",  "%Y-%m-%d"), 
           ymin = min(deaths_data_frame$DriversKilled/deaths_data_frame$kms), ymax = max(deaths_data_frame$DriversKilled/deaths_data_frame$kms), 
           alpha = 0.3, fill = "lightgreen") +
  ylab("Drivers Killed / Kilometer Driven") +
  xlab("Date") +
  theme_classic() + 
  ggtitle("Drivers Killed Per Kilometer Driven Over Time")
(plotting_object)

require(lattice)
require(latticeExtra)

# First attempt kind of weird, since all data on a different scale
horizonplot(deaths, layout = c(1,8), horizonscale = 30, colorkey = TRUE)

# Do a YOY calculation (lag 12 because monthly)
deaths_yoy <- deaths/lag(deaths,-12) - 1
deaths_yoy_clean <- deaths_yoy[,c(1:7)]

horizonplot(deaths_yoy_clean, 
              layout = c(1,7), 
              main = "YOY Difference of variables from Seatbelts", 
              par.settings=theEconomist.theme(box="gray70"),  
              horizonscale = .3333333333, 
              colorkey = TRUE, 
              strip.left = FALSE,
              ylab = list(rev(colnames(deaths_yoy_clean)), rot = 0, cex = 0.8, pos = 3), 
              lattice.options=theEconomist.opts())