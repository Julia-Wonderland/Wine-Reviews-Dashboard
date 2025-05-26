library(shiny)
library(highcharter)

#source("plots/overview_plot1.R")

shinyUI(
  navbarPage(
    title = div(
      tags$img(src = "logo.png", height = "30px", style = "border-radius: 50%; margin-right: 10px;"),
      "WineLens", tags$head(
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
               h2("Welcome to the WineLens"),
               p("We present vizualizations to show many interesting features of this dataset, as well us unable users to explore the data by themselves and discover new properties"),
               # First row: 2 videos
               fluidRow(
                 column(6,
                        div(class = "card", 
                            tags$video(src = "video1.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Overview of wine dataset"),
                            p("We present interactive datatable, treemap of designations in chosen winery
                               and barplot of price and points for selected winery and for for wineries together")
                        )
                 ),
                 column(6,
                        div(class = "card", 
                            tags$video(src = "video2.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Projection of reviews"),
                            p("We present t-sne projection of reviews - we obtained the embeddings via SentenceTransformer - all-MiniLM-L6-v2, latter we projected the embdding into 2D with t-SNE")
                        )
                 )
               ),
               
               # Second row: 2 videos
               fluidRow(
                 column(6,
                        div( class = "card", 
                            tags$video(src = "video3.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Exploration of important features"),
                            p("We present force-connected network showing varieties sold in similar wineries and treemap of provinces and regions
                              division")
                        )
                 ),
                 column(6,
                        div( class = "card",
                            tags$video(src = "video4.mp4", type = "video/mp4", controls = NA, width = "100%"),
                            h4("Simple comparer of reviewers"),
                            p("We may choose 2 reviewers, and we will see histogram of point reviews,
                              Similarity score between them and scatterplot of point/price relationship")
                        )
                 )
               ),
               p("dataset taken from kaggle, preprocessed by removing nan values
                 and embeddings creation"),
               uiOutput("dataset_source"),
               p("Authors (in alphabetical order):", tags$br(), 
                 "Julia Mirońska", tags$br(), "Igor Szymczak")
             )
    ),
    
    
    # --- 2. OVERVIEW PAGE ---
    tabPanel("Overview",
             fluidPage(
               h2("Overview"),
               fluidRow(
                 column(6,
                        div(class = "card",
                            selectInput("hist_var", "Variable to plot:",
                                        choices = c("Price" = "price", "Points" = "points"),
                                        selected = "price"),
                            
                            numericInput("hist_binwidth", "Bin width:", value = 5, min = 1, max = 50),
                            
                            plotOutput("overview_plot1", height = "400px")
                        )
                 ),
                 column(6,
                        div(class = "card",
                            highchartOutput("designation_treemap", height = "548px")
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
                      DT::dataTableOutput("overview_plot2")
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
               column(6, 
                 div(class = "card", 
                     column(6, selectInput("reviewer_select_1", "choose reviewer_1:",
                                  choices = reviewers, selected = "None")),
                     column(6, selectInput("reviewer_select_2", "choose reviewer_2:",
                                  choices = reviewers, selected = "None")),
                     DT::dataTableOutput("comparison_plot_1", height = "400px")
                 )
               ),
               column(6, 
                      div( class = "card",
                          plotlyOutput("comparison_plot_2", height = "400px"),
                          align = "center"
                      )
               ),
               column(6, 
                      div(class = "card", 
                          plotOutput("comparison_plot_3", height = "300px")
                      )
               ),
               column(6, 
                      div(class = "card", 
                          plotlyOutput("comparison_plot_4", height = "300px")
                      )
               )
             )
    )
  )
)
