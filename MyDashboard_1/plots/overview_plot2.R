overview_plot2 <- function(aggregations, colors) {
  display_data <- wine_data
  color_names_list <- c("color_points" = "points", "color_price" = "price",
                        "color_amount" = "amount_of_wines")
  names <- c("aggregate_wineries" = "winery", "aggregate_varieties" = "variety")
  if(length(aggregations) == 1){
    my_str = toString(names[aggregations[0:1]])
      first_row <- display_data %>% group_by(across(all_of(my_str))) %>% 
          filter(row_number()==1) %>% select(my_str, "description")
      display_data <- display_data %>% group_by(across(all_of(my_str))) %>% 
        summarise(points = mean(points), price = mean(price), 
                  amount_of_wines = sum(amount_of_wines))
      display_data <- merge(display_data, first_row, by = my_str)
  }
  
  display_data$points <- round(display_data$points, 2)
  display_data$price <- round(display_data$price, 2)
  final <- DT::datatable(display_data, rownames = F, style = 'bootstrap', filter = 'top',
                         caption = "Interactive table of points and price by winery and variety",
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

  for( color in colors){
    my_str = toString(color_names_list[color])
    clrs <- color_scale_1
    brks <-quantile(display_data[[my_str]], probs = seq(.15, .85, .14))
    print(brks)
    final <- final %>% formatStyle(my_str, 
                                   backgroundColor = styleInterval(brks, clrs))
    
  }
  final
}
#overview_plot2()
