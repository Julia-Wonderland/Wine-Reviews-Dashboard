library(dplyr)
library(highcharter)

explore_designation_treemap <- function(wine_data, selected_winery) {
  if (is.null(selected_winery)) return(NULL)
  
  data_filtered <- wine_data %>%
    filter(winery == selected_winery) %>%
    mutate(designation = ifelse(is.na(designation) | designation == "", "Unknown", designation)) %>%
    count(designation, name = "value") %>%
    arrange(desc(value))
  
  hc_data <- lapply(1:nrow(data_filtered), function(i) {
    list(
      id = data_filtered$designation[i],
      name = data_filtered$designation[i],
      value = data_filtered$value[i]
    )
  })
  
  highchart() %>%
    hc_chart(type = "treemap") %>%
    hc_title(text = paste("Top Designations for", selected_winery)) %>%
    hc_plotOptions(treemap = list(
      layoutAlgorithm = "squarified",
      dataLabels = list(enabled = TRUE, format = '{point.name}')
    )) %>%
    hc_series(list(
      type = "treemap",
      data = hc_data
    ))
}
