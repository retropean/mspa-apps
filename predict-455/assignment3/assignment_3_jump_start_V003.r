# Week 6
# Individual Assignment 3
# Jump Start Code v3



# Set working directory
# The below references the Desktop on my Mac
setwd("C:/Users/00811289/Desktop/assignment3")

# Visualizing Time Jump-Start Code for Financial Time Series

# begin by installing the packages quantmod, lubridate, latticeExtra, and zoo
# install.packages("quantmod")
# install.packages("lubridate")
# install.packages("latticeExtra")
# install.packages("zoo")
library(quantmod) # use for gathering and charting economic data
library(lubridate) # date functions
library(latticeExtra) # package used for horizon plot
library(zoo) # utilities for working with time series


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



# University of Michigan: Consumer Sentiment, not seasonally adjusted (monthly, 1966 = 100)
getSymbols("UMCSENT",src="FRED",return.class = "xts")
print(str(UMCSENT)) # show the structure of this xtx time series object
# plot the series
chartSeries(UMCSENT,theme="white")

# Additional plot
getSymbols("CPIAUCNS",src="FRED",return.class = "xts")
print(str(CPIAUCNS)) # show the structure of this xtx time series object
# plot the series
chartSeries(CPIAUCNS,theme="white")

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

