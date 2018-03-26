install.packages("quantmod")
library(quantmod)

getSymbols("AAPL")
dim(AAPL)
head(AAPL)

chartSeries(AAPL,theme="white")

getSymbols("AAPL",from="2005-01-02", to="2010-12-31")
head(AAPL)

#Download monthly unemployment rate from FRED.
getSymbols("UNRATE",src="FRED")
dim(UNRATE)
head(UNRATE)
chartSeries(UNRATE,theme="white")

#Download CBOE 10-year Treasures Notes
getSymbols("^TNX")
chartSeries(TNX,theme="white",TA=NULL)
