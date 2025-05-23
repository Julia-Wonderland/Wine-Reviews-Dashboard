# install.packages("jsonlite")
# install.packages("networkD3")
# install.packages("DT")

library(jsonlite)
library(networkD3)
library(DT)
library(dplyr)

source("plots/explore_plot3.R")
source("plots/overview_plot2.R")
color_scale_1 <- c("rgb(68,206,27)", "rgb(187,219,68)", "rgb(247,227,121)", 
                   "rgb(242,161,52)", "rgb(229,31,31)")
wine_data <- read.csv("data/grouped_wine_df_nona.csv")
force_graph <- jsonlite::fromJSON("data/force_graph.json")