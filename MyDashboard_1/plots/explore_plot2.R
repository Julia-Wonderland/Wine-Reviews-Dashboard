explore_plot2 <- function(wine_data, color_by = "points") {
  library(dplyr)
  library(highcharter)
  library(scales)
  
  wine_data_clean <- wine_data %>%
    mutate(across(c(country, province, region_2, region_1), ~ ifelse(is.na(.), "Unknown", .)))
  
  # Compute average based on color_by
  if (color_by == "points") {
    avg_metric <- wine_data_clean %>%
      group_by(province, region_2, region_1) %>%
      summarise(avg_value = mean(points, na.rm = TRUE), .groups = "drop")
    
    min_color <- "#f7fbff"
    max_color <- "#08306b"
    title_color <- "Average Points"
    
    region_counts <- wine_data_clean %>%
      count(province, region_2, region_1, name = "value") %>%
      ungroup()
    
    data_joined <- region_counts %>%
      left_join(avg_metric, by = c("province", "region_2", "region_1"))
    
    # Use actual average points as colorValue (no rescaling)
    data_joined <- data_joined %>%
      mutate(colorValue = avg_value)
    
    # Set fixed color axis range for points (adjust if needed)
    color_axis_min <- 70
    color_axis_max <- 100
    
  } else if (color_by == "price") {
    avg_metric <- wine_data_clean %>%
      group_by(province, region_2, region_1) %>%
      summarise(avg_value = mean(price, na.rm = TRUE), .groups = "drop")
    
    min_color <- "#fff5f0"
    max_color <- "#67000d"
    title_color <- "Average Price"
    
    region_counts <- wine_data_clean %>%
      count(province, region_2, region_1, name = "value") %>%
      ungroup()
    
    data_joined <- region_counts %>%
      left_join(avg_metric, by = c("province", "region_2", "region_1"))
    
    # Rescale average price to 0-100 for colorValue
    all_avg_values <- data_joined$avg_value
    data_joined <- data_joined %>%
      mutate(colorValue = scales::rescale(avg_value, to = c(0, 100), from = range(all_avg_values, na.rm = TRUE)))
    
    # Set color axis range for price (0-100 because of rescaling)
    color_axis_min <- 0
    color_axis_max <- 100
    
    
    
  } else {
    stop("Unknown color_by argument")
  }
  
  hc_data <- list()
  ids_added <- character()
  
  for (i in seq_len(nrow(data_joined))) {
    row <- data_joined[i, ]
    id_province <- row$province
    id_region2 <- paste0(id_province, "_", row$region_2)
    id_region1 <- paste0(id_region2, "_", row$region_1)
    
    if (!(id_province %in% ids_added)) {
      hc_data <- append(hc_data, list(
        list(id = id_province, name = row$province, value = NULL, colorValue = NULL, level = 1)
      ))
      ids_added <- c(ids_added, id_province)
    }
    
    if (!(id_region2 %in% ids_added)) {
      hc_data <- append(hc_data, list(
        list(id = id_region2, name = row$region_2, parent = id_province, value = NULL, colorValue = NULL, level = 2)
      ))
      ids_added <- c(ids_added, id_region2)
    }
    
    hc_data <- append(hc_data, list(
      list(id = id_region1, name = row$region_1, parent = id_region2, value = row$value,
           colorValue = row$colorValue, level = 3)
    ))
  }
  
  highchart() %>%
    hc_chart(type = "treemap") %>%
    hc_title(text = paste("Explore Wine Regions (Province → Region 2 → Region 1) Colored by", title_color)) %>%
    hc_colorAxis(min = color_axis_min, max = color_axis_max,
                 minColor = min_color, maxColor = max_color) %>%
    hc_plotOptions(treemap = list(
      allowDrillToNode = TRUE,
      layoutAlgorithm = "squarified",
      interactByLeaf = FALSE,
      dataLabels = list(enabled = TRUE, format = '{point.name}')
    )) %>%
    hc_series(list(
      type = "treemap",
      layoutAlgorithm = "squarified",
      allowDrillToNode = TRUE,
      interactByLeaf = FALSE,
      data = hc_data,
      rootId = "root",
      levels = list(
        list(level = 1, dataLabels = list(enabled = TRUE), borderWidth = 3),
        list(level = 2, dataLabels = list(enabled = TRUE), borderWidth = 2),
        list(level = 3, dataLabels = list(enabled = TRUE), borderWidth = 1)
      )
    ))
}
