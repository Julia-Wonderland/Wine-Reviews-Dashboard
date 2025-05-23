library(shiny)

shinyServer(function(input, output, session) {
  
  # Overview visualizations
  output$overview_plot1 <- renderPlot({ plot(cars) })
  output$overview_plot2 <- DT::renderDataTable({overview_plot2(input$aggregations,
                                                               input$table_colors)})
  # Exploration visualizations
  output$explore_plot1 <- renderPlot({ plot(iris[, 1:2]) })
  output$explore_plot2 <- renderPlot({ boxplot(iris$Sepal.Length ~ iris$Species) })
  output$explore_plot3 <- renderForceNetwork({ explore_plot3(input$opacity_slider) })
  
  # Comparison plot
  output$comparison_plot <- renderPlot({ plot(mtcars$mpg, mtcars$hp) })
  
  # Fullscreen modal logic
  observeEvent(input$fullscreen1, {
    showModal(modalDialog(
      title = "Explore Plot 1 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      plotOutput("explore_plot1", height = "600px")
    ))
  })
  
  observeEvent(input$fullscreen2, {
    showModal(modalDialog(
      title = "Explore Plot 2 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      plotOutput("explore_plot2", height = "600px")
    ))
  })
  
  observeEvent(input$fullscreen3, {
    showModal(modalDialog(
      title = "Explore Plot 3 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      plotOutput("explore_plot3", height = "600px")
    ))
  })
  
})
