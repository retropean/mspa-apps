# Visualizing Time Jump-Start Code for Financial Time Series

# begin by installing the packages quantmod, lubridate, latticeExtra, and zoo 

library(quantmod) # use for gathering and charting economic data
library(lubridate) # date functions
library(latticeExtra) # package used for horizon plot
library(zoo)  # utilities for working with time series


# ---------------------------------------
# here we demonstrate the wonders of FRED 
# ---------------------------------------
# demonstration of R access to and display of financial data from FRED
# requires a connection to the Internet
# ecomonic research data from the Federal Reserve Bank of St. Louis 
# see documentation of tags at http://research.stlouisfed.org/fred2/
# if you choose a particular series and click on it a graph will be displayed
# in parentheses in the title of the graph will be the symbol 
# for the financial series some time series are quarterly, some monthly
# ... others weekly... so make sure the time series match up in time
# see the documentation for quantmod at
# <http://cran.r-project.org/web/packages/quantmod/quantmod.pdf>

# here we show how to download the Consumer Price Index
# for All Urban Consumers: All Items, Not Seasonally Adjusted, Monthly
getSymbols("CPIAUCNS",src="FRED",return.class = "xts")
print(str(CPIAUCNS)) # show the structure of this xtx time series object
# plot the series
chartSeries(CPIAUCNS,theme="white")

# M1 money stock time series not seasonally adjusted
getSymbols("M1NS",src="FRED",return.class = "xts")
print(str(M1NS)) # show the structure of this xtx time series object
# plot the series
chartSeries(M1NS,theme="white")

# Real Gross National Product in 2005 dollars
getSymbols("GNPC96",src="FRED",return.class = "xts")
print(str(GNPC96)) # show the structure of this xtx time series object
# plot the series
chartSeries(GNPC96,theme="white")

# National Civilian Unemployment Rate, not seasonally adjusted (monthly, percentage)
getSymbols("UNRATENSA",src="FRED",return.class = "xts")
print(str(UNRATENSA)) # show the structure of this xtx time series object
# plot the series
chartSeries(UNRATENSA,theme="white")

# Delinquency Rate On Credit Card Loans, All Commercial Banks, not seasonally adjusted (quarterly,percentage)
getSymbols("DRCCLACBN",src="FRED",return.class = "xts")
print(str(DRCCLACBN)) # show the structure of this xtx time series object
# plot the series
chartSeries(DRCCLACBN,theme="white")

# University of Michigan: Consumer Sentiment, not seasonally adjusted (monthly, 1966 = 100)
getSymbols("UMCSENT",src="FRED",return.class = "xts")
print(str(UMCSENT)) # show the structure of this xtx time series object
# plot the series
chartSeries(UMCSENT,theme="white")

# New Homes Sold in the US, not seasonally adjusted (monthly, thousands)
getSymbols("HSN1FNSA",src="FRED",return.class = "xts")
print(str(HSN1FNSA)) # show the structure of this xtx time series object
# plot the series
chartSeries(HSN1FNSA,theme="white")

# ---------------------------------------
# here we demonstrate Yahoo! finance 
# ---------------------------------------
# stock symbols for companies can be obtained from Yahoo! at
# <http://finance.yahoo.com/lookup>

# get Apple stock price data
getSymbols("AAPL",return.class = "xts")
print(str(AAPL)) # show the structure of this xtx time series object
# plot the series stock price
chartSeries(AAPL,theme="white")

# get IBM stock price data
getSymbols("IBM",return.class = "xts")
print(str(IBM)) # show the structure of this xtx time series object
# plot the series stock price
chartSeries(IBM,theme="white")

# get HP stock price data
getSymbols("HPQ",return.class = "xts")
print(str(HPQ)) # show the structure of this xtx time series object
# plot the series stock price
chartSeries(HPQ,theme="white")  

# ---------------------------------------
# Multiple time series plots 
# ---------------------------------------
# let's try putting consumer sentiment and new home sales on the same plot

# University of Michigan Index of Consumer Sentiment (1Q 1966 = 100)
getSymbols("UMCSENT", src="FRED", return.class = "xts")
ICS <- UMCSENT # use simple name for xts object
dimnames(ICS)[2] <- "ICS" # use simple name for index
chartSeries(ICS, theme="white")
ICS.data.frame <- as.data.frame(ICS)
ICS.data.frame$date <- ymd(rownames(ICS.data.frame))
ICS.time.series <- ts(ICS.data.frame$ICS, 
                      start = c(year(min(ICS.data.frame$date)), month(min(ICS.data.frame$date))),
                      end = c(year(max(ICS.data.frame$date)),month(max(ICS.data.frame$date))),
                      frequency=12)

# New Homes Sold in the US, not seasonally adjusted (monthly, millions)
getSymbols("HSN1FNSA",src="FRED",return.class = "xts")
NHS <- HSN1FNSA
dimnames(NHS)[2] <- "NHS" # use simple name for index
chartSeries(NHS, theme="white")
NHS.data.frame <- as.data.frame(NHS)
NHS.data.frame$date <- ymd(rownames(NHS.data.frame))
NHS.time.series <- ts(NHS.data.frame$NHS, 
                      start = c(year(min(NHS.data.frame$date)),month(min(NHS.data.frame$date))),
                      end = c(year(max(NHS.data.frame$date)),month(max(NHS.data.frame$date))),
                      frequency=12)

# define multiple time series object
economic.mts <- cbind(ICS.time.series,
                      NHS.time.series) 
dimnames(economic.mts)[[2]] <- c("ICS","NHS") # keep simple names 
modeling.mts <- na.omit(economic.mts) # keep overlapping time intervals only 

# examine the structure of the multiple time series object
# note that this is not a data frame object
print(str(modeling.mts))

# plot multiple time series using standard R graphics 
plot(modeling.mts,main="")

# -----------------------------------------
# Horizon plotting of multiple time series
# -----------------------------------------
# plot multiple economic time series as horizon plot
# use ylab rather than strip.left, for readability
# also shade any times with missing data values.
# latticeExtra package used for horizon plot
print(horizonplot(modeling.mts, colorkey = TRUE,
                  layout = c(1,2), strip.left = FALSE,  
                  ylab = list(rev(colnames(modeling.mts)), rot = 0, cex = 0.7)) +
        layer_(panel.fill(col = "gray90"), panel.xblocks(..., col = "white")))

# dump this plot to a pdf file in landscape orientation
pdf(file="fig_economic_time_series_horizon_plot.pdf",width = 11,height = 8.5)
print(horizonplot(modeling.mts, colorkey = TRUE,
                  layout = c(1,2), strip.left = FALSE,  
                  ylab = list(rev(colnames(modeling.mts)), rot = 0, cex = 0.7)) +
        layer_(panel.fill(col = "gray90"), panel.xblocks(..., col = "white")))
dev.off()

# -----------------------------------------
# Prepare data frame for ggplot2 work
# -----------------------------------------
# for zoo examples see vignette at
# <http://cran.r-project.org/web/packages/zoo/vignettes/zoo-quickref.pdf>
modeling_data_frame <- as.data.frame(modeling.mts)
modeling_data_frame$Year <- as.numeric(time(modeling.mts))

# examine the structure of the data frame object
# notice an intentional shift to underline in the data frame name
# this is just to make sure we keep our object names distinct
# also you will note that programming practice for database work
# and for work with Python is to utilize underlines in variable names
# so it is a good idea to use underlines generally
print(str(modeling_data_frame)) 
print(head(modeling_data_frame))

# -----------------------------------------
# ggplot2 time series plot
# -----------------------------------------
# with a data frame object in hand... we can go on to use ggplot2 
# and methods described in Chang (2013) R Graphics Cookbook
# note. attepting to use ggplot2 and latticeExtra in the same program
# can cause problems... due to problems with the layer() function
# so we will not use lattice after this point in our code
library(ggplot2)

# according to the National Bureau of Economic Research the Great Recession
# extended from December 2007 to June 2009
# using our Year variable this would be from 2007.917 to 2009.417
# let's highlight the Great Recession on our plot
plotting_object <- ggplot(modeling_data_frame, aes(x = Year, y = ICS)) +
  geom_line() +
  annotate("rect", xmin = 2007.917, xmax = 2009.417, 
           ymin = min(modeling_data_frame$ICS), ymax = max(modeling_data_frame$ICS), 
           alpha = 0.3, fill = "red") +
  ylab("Index of Consumer Sentiment") +
  ggtitle("Great Recession and Consumer Sentiment")
print(plotting_object)    


