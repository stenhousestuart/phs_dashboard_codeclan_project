library(shiny)

# This is where we'll source in data
source("example_data.R")

library(tidyverse)

ui <- fluidPage(
  titlePanel("Change me!"),
  tabsetPanel(
    tabPanel(
      title = "Temporal",
      plotOutput("temporal_out"),
      fluidRow(
        # These inputs will need to be altered to fit real data set
        # Currently allowing multiple inputs - might need changed
        selectInput(inputId = "year_input",
                    label = "Select Year",
                    choices = year_choice,
                    selected = "2020"),
        
      ),
      fluidRow(
          actionButton(inputId = "update_temporal",
                       label = "Update dashboard")
        ) 
      ),
      tabPanel(
        title = "Geographical",
        plotOutput("geo_output"),
        selectInput(inputId = "health_board_input",
                    label = "Select Health Board",
                    choices = health_board_choice,
                    multiple = TRUE,
                    selected = "S08000015"),
        fluidRow(
          actionButton(inputId = "update_geo",
                       label = "Update dashboard")
        )

      ),
      tabPanel(
         title = "Demographic"
      )
    )
  )
# )

server <- function(input, output, session) {
  
  # These are test outputs - must be altered to fit real data set
  filtered_temporal <- eventReactive(eventExpr = input$update_temporal,
                                     valueExpr = {
                                       test_data_year %>% 
                                         filter(year == input$year_input)
                                     })
  
  filtered_geo <- eventReactive(eventExpr = input$update_geo,
                              valueExpr = {
                                test_data_year %>% 
                                  filter(HB %in% input$health_board_input)
                              })
  
  
  output$temporal_out <- renderPlot(
    filtered_temporal() %>% 
      ggplot(aes(x = WeekEnding, y = NumberAdmissions)) +
      geom_line(aes(colour = HB))
  )
  output$geo_output <- renderPlot(
    filtered_geo() %>% 
      ggplot(aes(x = WeekEnding, y = NumberAdmissions)) +
      geom_line(aes(colour = HB))
  )
}

shinyApp(ui, server)
