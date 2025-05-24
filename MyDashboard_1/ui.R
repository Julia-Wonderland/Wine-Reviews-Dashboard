library(shiny)
library(highcharter)

source("plots/overview_plot1.R")

shinyUI(
  navbarPage(
    title = div(
      tags$img(src = "logo.png", height = "40px", style = "border-radius: 50%; margin-right: 10px;"),
      "My Dashboard", tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Lato&display=swap")
      )
    ),
    id = "main_navbar",
    inverse = TRUE,
    collapsible = TRUE,
    
    # --- 1. ABOUT PAGE ---
    tabPanel("About",
             fluidPage(
               h2("Welcome to the Dashboard"),
               p("This is the top description text."),
               
               fluidRow(
                 column(4,
                        div(class = "card", 
                            tags$video(src = "video1.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Feature 1"),
                            p("Short description of feature 1.")
                        )
                 ),
                 column(4,
                        div(class = "card", 
                            tags$video(src = "video2.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Feature 2"),
                            p("Short description of feature 2.")
                        )
                 ),
                 column(4,
                        div(class = "card", 
                            tags$video(src = "video3.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Feature 3"),
                            p("Short description of feature 3.")
                        )
                 )
               ),
               
               p("This is the bottom text providing more context or notes.")
             )
    ),
    
    # --- 2. OVERVIEW PAGE ---
    tabPanel("Overview",
             fluidPage(
               h2("Overview"),
               fluidRow(
                 column(12,
                        div(class = "card", 
                            plotOutput("overview_plot1", height = "300px")
                        )
                 )
               ),
               br(),
               div(class = "card", 
               fluidRow(
                 column(12,
                      column(5, checkboxGroupInput("aggregations", "aggregations", 
                                                   choices = c("aggregate_wineries", 
                                                               "aggregate_varieties"),
                                                   inline = T)),
                      column(5,checkboxGroupInput("table_colors", "colors", 
                                                   choices = c("color_points", 
                                                               "color_price",
                                                               "color_amount"),
                                                   inline = T)),
                      br(),
                      column(12, DT::dataTableOutput("overview_plot2"))
                 )
               )
               )
             )
    ),
    
    # --- 3. EXPLORATION PAGE ---
    tabPanel("Exploration",
             fluidPage(
               h2("Data Exploration"),
               fluidRow(
                 # Top row: explore_plot1 and explore_plot3 side-by-side, equal height
                 column(6,
                        div(class = "card",
                            actionButton("fullscreen1", "Fullscreen"),
                            selectInput("color_by", "Color by:", 
                                        choices = c("price", "points", "province","taster_name"),
                                        selected = "price"),
                            selectInput("color_low", "Low Color", choices = colors(), selected = "blue"),
                            selectInput("color_high", "High Color", choices = colors(), selected = "red"),
                            sliderInput("sample_size", "Sample size for exploration:", 
                                        min = 100, max = nrow(wine_data), value = 1000, step = 100),
                            plotOutput("explore_plot1", height = "320px", click = "plot_click"),
                            verbatimTextOutput("point_info")
                        )
                 ),
                 column(6,
                        div(class = "card",
                            actionButton("fullscreen3", "Fullscreen"),
                            sliderInput("opacity_slider", "Set opacity", min = 0.0, max = 1.0, value = 0.5),
                            forceNetworkOutput("explore_plot3", height = "542px")
                        )
                 )
               ),
               br(),
               fluidRow(
                 # Bottom full width row: explore_plot2
                 column(12,
                        div(class = "card",
                            actionButton("fullscreen2", "Fullscreen"),
                            selectInput("color_metric", "Color treemap by:",
                                        choices = c("Average Points" = "points", "Average Price" = "price"),
                                        selected = "points"),
                            highchartOutput("explore_plot2", height = "300px")
                        )
                 )
               )
             )
    ),
    
    # --- 4. COMPARISON PAGE ---
    tabPanel("Comparison",
             fluidPage(
               h2("Comparison View"),
               div(class = "card", 
                   plotOutput("comparison_plot", height = "600px")
               )
             )
    )
  )
)
