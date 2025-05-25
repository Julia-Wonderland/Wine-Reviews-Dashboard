library(ggplot2)
library(dplyr)

overview_plot1 <- function(wine_data, var = "price", binwidth = 5) {
  wine_data_clean <- wine_data %>%
    filter(!is.na(.data[[var]]))
  
  ggplot(wine_data_clean, aes(x = .data[[var]])) +
    geom_histogram(binwidth = binwidth, fill = "#4682B4", color = "white") +
    labs(
      title = paste("Histogram of", tools::toTitleCase(var)),
      x = tools::toTitleCase(var),
      y = "Count"
    ) +
    coord_cartesian(xlim = c(0, ifelse(var == "price", 300, 100))) +
    theme_minimal()
}
