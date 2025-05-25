overview_plot2 <- function(aggregations, colors, display_data) {
  # Do NOT override display_data here
  
  color_names_list <- c("color_points" = "points", "color_price" = "price",
                        "color_amount" = "amount_of_wines")
  mapping <- c("aggregate_wineries" = "winery", "aggregate_varieties" = "variety")
  
  if(length(aggregations) == 1){
    my_str <- toString(mapping[aggregations])
    first_row <- display_data %>% group_by(across(all_of(my_str))) %>% 
      filter(row_number()==1) %>% select(all_of(my_str), "description")
    
    display_data <- display_data %>% group_by(across(all_of(my_str))) %>% 
      summarise(points = mean(points, na.rm=TRUE), price = mean(price, na.rm=TRUE), 
                amount_of_wines = sum(amount_of_wines, na.rm=TRUE))
    display_data <- merge(display_data, first_row, by = my_str)
  }
  
  display_data$points <- round(display_data$points, 2)
  display_data$price <- round(display_data$price, 2)
  
  final <- DT::datatable(display_data, rownames = FALSE, style = 'bootstrap', filter = 'top',
                         caption = "Interactive table of points and price by winery and variety",
                         selection = list(mode = "single"),
                         options = list(columnDefs = list(list(
                           visible = FALSE, targets = (ncol(display_data)-1))),
                           scrollX = TRUE,
                           scrollY = '400px', pageLength = 50, lengthMenu = c(20, 50, 100)),
                         callback = JS(
                           "
                          table.column(0).nodes().to$().css({cursor: 'pointer'});
                          table.on('click', 'td', function() {
                            var tr = $(this).closest('tr');
                            var row = table.row(tr);
                            if (row.child.isShown()) {
                              row.child.hide();
                              tr.removeClass('shown');
                            } else {
                              var name = row.data()[0] + row.data()[1];
                              row.child('<div>' + 'example review: ' +
                                  row.data()[row.data().length-1] + '</div>').show();
                              tr.addClass('shown');
                            }
                          });
                          "
                         ))
  
  for(color in colors){
    my_str <- color_names_list[color]
    clrs <- color_scale_1
    brks <- quantile(display_data[[my_str]], probs = seq(.15, .85, .14), na.rm = TRUE)
    final <- final %>% formatStyle(my_str, 
                                   backgroundColor = styleInterval(brks, clrs))
  }
  
  final
}
