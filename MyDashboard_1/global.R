# install.packages("jsonlite")
# install.packages("networkD3")

library(jsonlite)
library(networkD3)
source("plots/explore_plot3.R")
#data <- read.csv("data/wine_df_emb_nona_nosam.csv")
force_graph <- jsonlite::fromJSON("data/force_graph.json")