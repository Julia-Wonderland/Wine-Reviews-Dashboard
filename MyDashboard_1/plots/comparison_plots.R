comparison_plot_1 <- function(reviewer_1, reviewer_2){
  names = c("attributes")
  if(reviewer_1 != "None"){
      names <- c(names, c(reviewer_1))
  }
  if(reviewer_2 != "None"){
    names <- c(names, c(reviewer_2))
  }
  if(length(names) != 1){
      DT::datatable(reviewers_data[, names], rownames = F,
                    options = list(lengthChange = F, dom = 't'))
  }
}
comparison_plot_3 <- function(reviewer_1, reviewer_2){
    if(reviewer_1 != "None" && reviewer_2 != "None"){
          
          review_amount_1 <- as.integer(reviewers_data[, c(reviewer_1)][3])
          review_amount_2 <- as.integer(reviewers_data[, c(reviewer_2)][3])
          reviewer_1 <- gsub(".", " ", reviewer_1, fixed = T)
          reviewer_2 <- gsub(".", " ", reviewer_2, fixed = T)
          reviewer_1 <- gsub("  ", ". ", reviewer_1, fixed = T)
          reviewer_2 <- gsub("  ", ". ", reviewer_2, fixed = T)
          
          data_1 <- wine_data %>% filter(taster_name %in% c(reviewer_1))
          data_1$points <- round(data_1$points, 0)
          data_1 <- data_1 %>% group_by(points) %>% 
            summarise(point_sum = n(), taster_name = nth(taster_name, 1)) %>%
            mutate_at(vars(point_sum), ~ . / review_amount_1)
          data_2 <- wine_data %>% filter(taster_name %in% c(reviewer_2))
          data_2$points <- round(data_2$points, 0)
          data_2 <- data_2 %>% group_by(points) %>% 
            summarise(point_sum = n(), taster_name = nth(taster_name, 1)) %>%
            mutate(point_sum = point_sum / review_amount_2)
          final <- bind_rows(data_1, data_2)
          ggplot(final, aes(x = points, y = point_sum, fill = taster_name)) + 
               geom_col() + scale_fill_brewer(palette = "Set1") + 
               ggtitle("Frequency histogram of reviewers scores") +
               theme_minimal()
    }
}

comparison_plot_4 <- function(reviewer_1, reviewer_2){
  reviewer_1 <- gsub(".", " ", reviewer_1, fixed = T)
  reviewer_2 <- gsub(".", " ", reviewer_2, fixed = T)
  reviewer_1 <- gsub("  ", ". ", reviewer_1, fixed = T)
  reviewer_2 <- gsub("  ", ". ", reviewer_2, fixed = T)
  if(reviewer_1 != "None" || reviewer_2 != "None"){
    data <- wine_data %>% filter(taster_name %in% c(reviewer_1, reviewer_2))
    fig <- plot_ly(data, x = ~points, y = ~price,
                   color = ~taster_name,
                   text = ~paste("winery: ", winery, "<br>variety: ", variety), 
                   mode = "markers", type = "scatter", colors = "Set1") %>%
              layout(title = "points vs price of wines colored by reviewers")
                  
    fig
  }
}

comparison_plot_2 <- function(reviewer_1, reviewer_2){
  reviewer_1 <- gsub(".", " ", reviewer_1, fixed = T)
  reviewer_2 <- gsub(".", " ", reviewer_2, fixed = T)
  reviewer_1 <- gsub("  ", ". ", reviewer_1, fixed = T)
  reviewer_2 <- gsub("  ", ". ", reviewer_2, fixed = T)
  if(reviewer_1 != "None" && reviewer_2 != "None"){
      data_1 <- wine_data %>% filter(taster_name %in% c(reviewer_1)) %>%
                group_by(variety) %>% summarise(points_rev_1 = mean(points)) %>%
                mutate(points_rev_1 = (points_rev_1 - 80)/20)
      data_2 <- wine_data %>% filter(taster_name %in% c(reviewer_2)) %>%
                group_by(variety) %>% summarise(points_rev_2 = mean(points)) %>%
                mutate(points_rev_2 = (points_rev_2 - 80)/20)
      final <- inner_join(data_1, data_2, by = "variety")
      size = min(nrow(data_1), nrow(data_2))
      similarity <- NULL
      my_color <- "red"
      if(nrow(final) != 0){
      similarity = sum(final$points_rev_1 * final$points_rev_2)
      similarity <- similarity / norm(final$points_rev_1, type = "2")
      similarity <- similarity / norm(final$points_rev_2, type = "2")
      similarity <- similarity / (size / nrow(final))
      my_color = if (similarity < 0.3) {"#D61F1F"} else if(similarity < 0.7) {"#FFD301"} 
                 else if(similarity < 0.9){"#7BB662"} else {"#006B3D"}
      }
      fig <- plot_ly(domain = list(x = c(0,1), y = c(0, 1)), value = similarity, 
              title = list(text = "similarity score between reviewers"
                           ),
              type = "indicator", mode = "gauge+number", 
              gauge = list( axis = list(range = list(0, 1)),
                            bar = list(color = my_color, thickness = 1)))
      fig <- fig %>% layout(margin = list(l = 20, r = 20, d = 0))
      fig
  }
}


