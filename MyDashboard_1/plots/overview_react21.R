library(dplyr)

filter_wine_data <- function(wine_data, selected_winery = NULL) {
  if (is.null(selected_winery) || selected_winery == "") return(wine_data)
  dplyr::filter(wine_data, winery == selected_winery)
}

prepare_table_data <- function(grouped_wine_data, aggregations) {
  display_data <- grouped_wine_data
  mapping <- c("aggregate_wineries" = "winery", "aggregate_varieties" = "variety")
  
  if (length(aggregations) == 1) {
    agg_name <- mapping[aggregations]
    first_row <- display_data %>%
      group_by(across(all_of(agg_name))) %>%
      filter(row_number() == 1) %>%
      select(all_of(agg_name), description)
    
    display_data <- display_data %>%
      group_by(across(all_of(agg_name))) %>%
      summarise(points = mean(points, na.rm = TRUE), 
                price = mean(price, na.rm = TRUE), 
                amount_of_wines = sum(amount_of_wines, na.rm = TRUE), 
                .groups = "drop")
    
    display_data <- merge(display_data, first_row, by = agg_name)
  }
  
  display_data$points <- round(display_data$points, 2)
  display_data$price <- round(display_data$price, 2)
  
  display_data
}
