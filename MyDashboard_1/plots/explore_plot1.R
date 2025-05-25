explore_plot1 <- function(data, color_by = "price", color_low = "blue", color_high = "red", alpha = 0.7) {
  p <- ggplot(data, aes_string(x = "tsne_x", y = "tsne_y", color = color_by)) +
    geom_point(size = 2, alpha = alpha) +
    labs(
      title = "Wine reviews descriptions visualization via t-SNE",
      x = "t-SNE X", y = "t-SNE Y",
      color = color_by
    ) +
    theme_minimal()
  
  if (is.numeric(data[[color_by]])) {
    p <- p + scale_color_gradient(low = color_low, high = color_high)
  } else {
    p <- p + scale_color_brewer(palette = "Set1")
  }
  return(p)
}
