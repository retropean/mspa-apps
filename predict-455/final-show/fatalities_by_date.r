library(plyr)
library(ggplot2)
library(extrafont)
library(zoo)
library(Cairo)
library(scales)
loadfonts()
Sys.setenv(R_GSCMD="C:/Program Files/gs/gs9.05/bin/gswin32c.exe")

# Hex codes according to our Style Guide as defined in Checkpoint B
HEX_BLUE <- "#17445F"
HEX_YELLOW <- "#F6F4C9"
HEX_TURQUOISE <- "#82BEB6"
HEX_EMERALD <- "#CCE6CB"
HEX_MENTHOL <- "#858A76"
HEX_LIGHT_BLUE <- "D6DDE8"
# Fonts
#HEADER_FONT <- "Palatino Linotype"
#MAIN_FONT <- "Calibri"

# Read files
setwd('C:/Users/00811289/Documents/github/pred-455/storm_events_data/fatalities/')
directory_location <- getwd()

file_names <- dir(directory_location)
fatalities <- NULL

for (file in file_names){
  temp_fatalities <-read.table(file, header=TRUE, sep=",")
  fatalities<-rbind(fatalities, temp_fatalities)
  rm(temp_fatalities)
}


summary(fatalities)

fatalities$FATALITY_DATE_fix <- as.Date(fatalities$FATALITY_DATE, format='%m/%d/%Y')
fatalities$YEAR <- format(fatalities$FATALITY_DATE_fix,'%Y')

death_by_date <- aggregate(cbind(count = FATALITY_ID) ~ YEAR, 
                data = fatalities, 
                FUN = function(x){NROW(x)})

death_by_date2 <- death_by_date[death_by_date$YEAR > 1979,]
death_by_date2 <- death_by_date2[death_by_date2$YEAR < 2018,]

# Add Cairo window for anti-alias support
CairoWin()

plotting_object <- ggplot(death_by_date2, aes(x = as.numeric(YEAR), y = count, group=1)) +
  geom_line(color=HEX_MENTHOL, size=1) +
  geom_line(aes(y=rollmean(count, 6, na.pad=TRUE)), colour=HEX_TURQUOISE, size = 1, linetype='dashed') +
  ylab("Fatalities") +
  xlab("Date") +
  ggtitle("Fatalities by Storm Events") +
  scale_y_continuous(label=comma) +
  scale_colour_manual(name = "Legend",
                      breaks = c("Fatalities", "6 Year Moving Average"),
                      values = c(HEX_MENTHOL, HEX_TURQUOISE)) +
  theme(panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", linetype = 'solid', fill=NA),
        panel.background = element_blank()) +
  ylim(0,1500)

print(plotting_object)
#ggsave("font_ggplot.pdf", plot=plotting_object,  width=4, height=4)