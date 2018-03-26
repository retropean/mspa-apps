# Video 1 #
# Introduction to the R financial package fBasics #

# First, install the package.  Un-comment the following statement to do so.
install.packages("fBasics")
install.packages("sjPlot")
# Load the package.
library(fBasics)

# Several built-in data sets available:
## Plot DowJones30 Example Data Set
series <- as.timeSeries(DowJones30)
head(series)
plot(series[,1:8], type = "l")

# An ARIMA simulation
ts.sim <- arima.sim(list(order = c(1,1,0), ar = 0.7), n = 200)
ts.plot(ts.sim)

# ACF (Auto correlation function) and PACF (Partial Auto correlation function) plots
acfPlot(ts.sim)
pacfPlot(ts.sim)

# Some financial data S&P500 Index Fund
SPI <- LPP2005REC[, "SPI"]
plot(SPI, type = "l", col = "steelblue", main = "SP500")
abline(h = 0, col = "grey")
acfPlot(SPI)
pacfPlot(SPI)

# Simulated Monthly Return Data:
tS = timeSeries(matrix(rnorm(12)), timeCalendar())
basicStats(tS)

# Boxplots
LPP <- LPP2005REC[, 1:6]
plot(LPP, type = "l", col = "steelblue", main = "SP500")
abline(h = 0, col = "grey")
boxPlot(LPP)

# Histogram Plots
SPI <- LPP2005REC[, "SPI"]
plot(SPI, type = "l", col = "steelblue", main = "SP500")
abline(h = 0, col = "grey")
histPlot(SPI)
densityPlot(SPI)

# Quantile - Quantile Plots
SPI <- LPP2005REC[, "SPI"]
plot(SPI, type = "l", col = "steelblue", main = "SP500")
abline(h = 0, col = "grey")
qqnormPlot(SPI)

# Correlation testing
x = rnorm(50)
y = rnorm(50)
correlationTest(x, y, "pearson")
correlationTest(x, y, "kendall")
spearmanTest(x, y)

## Series:
x = rnorm(1000)
# Kolmogorov - Smirnov One-Sample Test
ksnormTest(x)
## shapiroTest - Shapiro-Wilk Test
shapiroTest(x)
