library(shiny)

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
                 column(6,
                        div(class = "card", 
                            actionButton("fullscreen1", "Fullscreen"),
                            plotOutput("explore_plot1", height = "250px")
                        ),
                        br(),
                        div(class = "card", 
                            actionButton("fullscreen2", "Fullscreen"),
                            plotOutput("explore_plot2", height = "250px")
                        )
                 ),
                 column(6,
                        div(class = "card", 
                            actionButton("fullscreen3", "Fullscreen"),
                            sliderInput("opacity_slider", "Set opacity", min = 0.0, max = 1.0,
                                        value = 0.5),
                            forceNetworkOutput("explore_plot3", height = "520px")
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
