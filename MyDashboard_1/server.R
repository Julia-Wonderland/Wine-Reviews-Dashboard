shinyServer(function(input, output, session) {
  wine_data_sample <- reactive({
  req(input$sample_size)
  sample_n <- min(input$sample_size, nrow(wine_data)) # safeguard
  
  wine_data[sample(nrow(wine_data), sample_n), ]
})
  
  url <- a("Dataset Source", href = "https://www.kaggle.com/datasets/zynicide/wine-reviews")
  output$dataset_source <- renderUI(tagList(url))
  # Overview visualizations
  
  # Reactive to prepare table data
  filtered_table_data <- reactive({
    prepare_table_data(grouped_wine_data, input$aggregations)
  })
  
  # Reactive to get selected winery from the table
  filtered_table_data <- reactive({
    prepare_table_data(grouped_wine_data, input$aggregations)
  })
  
  selected_winery <- reactive({
    sel <- input$overview_plot2_rows_selected
    if (length(sel) == 0) return(NULL)
    tbl <- filtered_table_data()
    
    # Defensive check: if winery column exists in filtered table
    if ("winery" %in% colnames(tbl)) {
      return(tbl$winery[sel])
    } else {
      return(NULL)
    }
  })
  
  output$overview_plot1 <- renderPlot({
    data_to_plot <- filter_wine_data(wine_data, selected_winery())
    overview_plot1(data_to_plot, input$hist_var, input$hist_binwidth)
  })
  output$designation_treemap <- renderHighchart({
    selected <- selected_winery()
    if (is.null(selected)) return(NULL)
    explore_designation_treemap(wine_data, selected)
  })
  
  
  output$overview_plot2 <- DT::renderDataTable({
    display_data <- filtered_table_data()
    overview_plot2(input$aggregations, input$table_colors, display_data)
  }, selection = "single")
  observeEvent(input$aggregations, {
    DT::dataTableProxy("overview_plot2") %>% selectRows(NULL)
  })
  
  
  
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
  output$comparison_plot_3 <- renderPlot({ comparison_plot_3(input$reviewer_select_1, 
                                                                      input$reviewer_select_2)})
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
