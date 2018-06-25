# Set working directory
setwd("~/Desktop")

# Install necessary packages and open them
# If running multiple times, comment out the installs on subsequent runs
install.packages("d3Network")
install.packages("networkD3")
install.packages("rprojroot")
install.packages("rmarkdown")
library("d3Network")
library("networkD3")
library("rprojroot")
library("rmarkdown")

# Pull in json data generated from City of Chicago budget
# Data source = https://data.cityofchicago.org/Administration-Finance/Budget-2014-Budget-Ordinance-Appropriations/ub6s-xy6e/data/
# Json file prepared by K. Daugherty using https://shancarter.github.io/mr-data-converter/
budget <- paste0("chicago_budget.json")
chi_budget <- jsonlite::fromJSON(budget)

# Examine the data to make sure it's ready for visualization
print(chi_budget)

# Plot sankey network diagram
sankeyNetwork(Links = chi_budget$links, Nodes = chi_budget$nodes, 
              Source = "source", Target = "target", 
              Value = "value", NodeID = "name",
              units = "USD($)", fontSize = 12, 
              nodeWidth = 30)

# Using RStudio, export as a webpage (.html) to view in a web browser
# To include in a static visualization, export as an image file

# End