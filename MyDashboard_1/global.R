# install.packages("jsonlite")
# install.packages("networkD3")
# install.packages("DT")

library(jsonlite)
library(networkD3)
library(DT)
library(dplyr)

source("plots/explore_plot3.R")
source("plots/overview_plot2.R")
#source("plots/comparison_plots.R")

color_scale_1 <- c("rgb(202, 240, 248)", "rgb(173, 232, 244)", "rgb(144, 224, 239)", 
                   "rgb(72, 202, 228)", "rgb(0, 180, 216)", "rgb(0, 150, 199)", 
                  "rgb(0, 119, 182)")
wine_data <- read.csv("data/wine_data_emb_smaller.csv")
grouped_wine_data <- read.csv("data/grouped_wine_df_nona.csv")
#reviewers_data <- read.csv("data/reviewers_aggregated_data.csv")
#reviewers <- c(colnames(reviewers_data) , c("None"))
force_graph <- jsonlite::fromJSON("data/force_graph.json")