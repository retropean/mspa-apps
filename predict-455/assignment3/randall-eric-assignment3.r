library(ggplot2)
library(zoo)
library(ggthemes)

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
print(plotting_object)