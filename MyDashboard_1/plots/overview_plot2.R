overview_plot2 <- function(aggregations, colors) {
  display_data <- wine_data
  color_names_list <- c("color_points" = "points", "color_price" = "price",
                        "color_amount" = "amount_of_wines")
  names <- c("aggregate_wineries" = "winery", "aggregate_varieties" = "variety")
  
  if(length(aggregations) == 1){
    my_str = toString(names[aggregations[0:1]])
      display_data <- display_data %>% group_by(across(all_of(my_str))) %>% 
        summarise(points = mean(points), price = mean(price), 
                  amount_of_wines = sum(amount_of_wines))
  }
  
  round(display_data$points, 2)
  round(display_data$price, 2)
  
  final <- DT::datatable(display_data, rownames = F, style = 'bootstrap', filter = 'top',
                         caption = "Interactive table of points and price by winery and variety")

  for( color in colors){
    my_str = toString(color_names_list[color])
    clrs <- color_scale_1
    if(my_str != "price"){clrs <- rev(color_scale_1)}
    brks <-quantile(display_data[[my_str]], probs = seq(.2, 0.8, .2))
    print(brks)
    final <- final %>% formatStyle(my_str, 
                                   backgroundColor = styleInterval(brks, clrs))
    
  }
  final
}
#overview_plot2()
