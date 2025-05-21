explore_plot3 <- function(opacity_value) {
  forceNetwork(Links = force_graph$links, Nodes = force_graph$nodes, 
               Source = "source", Target = "target", Value = "value", 
               NodeID = "name", Group = "group", opacity = opacity_value, 
               zoom = TRUE, legend = TRUE, 
               colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10)"))
}
