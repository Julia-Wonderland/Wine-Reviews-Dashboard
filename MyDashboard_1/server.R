library(shiny)
library(shinyWidgets)
library(dplyr)
library(highcharter)
#highcharter::hc_add_dependency("modules/drilldown.js")


source("plots/explore_plot1.R")
#source("plots/overview_plot1.R")
source("plots/explore_plot2.R")





shinyServer(function(input, output, session) {
  wine_data_sample <- reactive({
  req(input$sample_size)
  sample_n <- min(input$sample_size, nrow(wine_data)) # safeguard
  
  wine_data[sample(nrow(wine_data), sample_n), ]
})
  
  # Overview visualizations
  
  output$overview_plot1 <- renderPlot({ plot(cars) })
  output$overview_plot2 <- DT::renderDataTable({overview_plot2(input$aggregations,
                                                               input$table_colors)})
  # Exploration visualizations
  output$explore_plot1 <- renderPlot({
    explore_plot1(
      wine_data_sample(),
      color_by = input$color_by,
      color_low = input$color_low,
      color_high = input$color_high
    )
  })
  
  output$explore_plot1_full <- renderPlotly({
    p <- explore_plot1(
      wine_data_sample(),
      color_by = input$color_by,
      color_low = input$color_low,
      color_high = input$color_high
    )
    ggplotly(p, source = "full_plot")
  })
  
  
  
  output$point_info_full <- renderText({
    click_data <- event_data("plotly_click", source = "full_plot")
    if (is.null(click_data)) {
      return("Click on a point to see details")
    }
    
    # Find nearest point by x and y
    clicked_point <- wine_data_sample()[
      which.min((wine_data_sample()$tsne_x - click_data$x)^2 + (wine_data_sample()$tsne_y - click_data$y)^2),
    ]
    
    
    paste0("Description: ", clicked_point$description)
  })
  
  
  
  output$explore_plot2 <- renderHighchart({
    explore_plot2(wine_data, color_by = input$color_metric)
  })
  
  
  output$explore_plot3 <- renderForceNetwork({ explore_plot3(input$opacity_slider) })
  
  # Comparison plot
  output$comparison_plot_1 <- DT::renderDataTable({ comparison_plot_1(input$reviewer_select_1, 
                                                             input$reviewer_select_2) })
  output$comparison_plot_3 <- renderPlotly({ comparison_plot_3(input$reviewer_select_1, 
                                                                      input$reviewer_select_2) })
  output$comparison_plot_4 <- renderPlotly({ comparison_plot_4(input$reviewer_select_1, 
                                                               input$reviewer_select_2) })
  output$comparison_plot_2 <- renderPlotly({ comparison_plot_2(input$reviewer_select_1, 
                                                               input$reviewer_select_2) })
  
  # Fullscreen modal logic
  observeEvent(input$fullscreen1, {
    showModal(modalDialog(
      title = "Explore Plot 1 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      tagList(
        plotlyOutput("explore_plot1_full", height = "600px"),
              verbatimTextOutput("point_info_full")
        
      )
    ))
  })
  
  
  output$explore_plot2_full <- renderHighchart({
    explore_plot2(wine_data)
  })
  
  
  observeEvent(input$fullscreen2, {
    showModal(modalDialog(
      title = "Explore Plot 2 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      highchartOutput("explore_plot2_full", height = "600px")
    ))
  })
  
  
  observeEvent(input$fullscreen3, {
    showModal(modalDialog(
      title = "Explore Plot 3 (Fullscreen)",
      size = "l",
      easyClose = TRUE,
      footer = NULL,
      forceNetworkOutput("explore_plot3", height = "600px")
    ))
  })
  
  
  
  output$point_info <- renderText({
    req(input$plot_click)  # only run if there's a click
    
    clicked_point <- nearPoints(
      wine_data_sample(),
      input$plot_click,
      xvar = "tsne_x",
      yvar = "tsne_y",
      threshold = 10,
      maxpoints = 1
    )
    
    
    if (nrow(clicked_point) == 0) {
      "Click on a point to see details"
    } else {
      paste0("Description: ", clicked_point$description)
    }
  })
  
  
})
