library(shiny)

# This is where we'll source in data
source("example_data.R")


ui <- fluidPage(
  titlePanel("Change me!"),
  tabsetPanel(
    tabPanel(
      title = "Temporal",
      
      fluidRow(
        # These inputs will need to be altered to fit real data set
        # Currently allowing single input - might need changed
        selectInput(inputId = "year_input",
                    label = "Select Year",
                    choices = year_choice,
                    selected = "2020"),
        
      ),
      fluidRow(
        actionButton(inputId = "update_temporal",
                     label = "Update dashboard")
      ),
      plotOutput("temporal_out")
    ),
    # this allows for multiple inputs for Health Board - Actual data set
    # will probably need more human readable choice names
    tabPanel(
      title = "Geographical",
      
      column(width = 6,
             selectInput(inputId = "health_board_input",
                         label = "Select Health Board",
                         choices = health_board_choice,
                         multiple = TRUE,
                         selected = "S08000015"),
      ),
      column(width = 6,
             selectInput(inputId = "year_input_geo",
                         label = "Select Year",
                         choices = year_choice,
                         selected = "2020"),
      ),
      fluidRow(
        actionButton(inputId = "update_geo",
                     label = "Update dashboard")
      ),
      plotOutput("geo_output")
      
    ),
    # using age for the demographic for testing purposes
    tabPanel(
      title = "Demographic",
      column( width = 6,
              selectInput(inputId = "age_input",
                          label = "Select Age Range",
                          choices = age_choice,
                          multiple = TRUE,
                          selected = "All ages")
      ),
      column(width = 6,
             selectInput(inputId = "year_input_demo",
                         label = "Select Year",
                         choices = year_choice,
                         selected = "2020")
      ),
      
      fluidRow(
        actionButton(inputId = "update_demo",
                     label = "Update dashboard"),
        fluidRow(   
          plotOutput("demo_output")
        )
      )
    )
  ),
  # Testing a "footer" that mentions where data was taken from
  # Will need to alter link and title for actual dataset used
  hr(),
  print("Data taken from "),
  tags$a(href = "https://www.opendata.nhs.scot/dataset/covid-19-wider-impacts-hospital-admissions/resource/f8f3a435-1925-4c5a-b2e8-e58fdacf04bb", 
         "Public health Scotland")
)


server <- function(input, output, session) {
  
  # These are test outputs - must be altered to fit real data set!
  # WARNING! THESE LOOK TERRIBLE!
  
  filtered_temporal <- eventReactive(eventExpr = input$update_temporal,
                                     valueExpr = {
                                       test_data_year %>% 
                                         filter(year == input$year_input)
                                     })
  
  filtered_geo <- eventReactive(eventExpr = input$update_geo,
                                valueExpr = {
                                  test_data_year %>% 
                                    filter(HB %in% input$health_board_input,
                                           year == input$year_input_geo)
                                })
  
  filtered_demo <- eventReactive(eventExpr = input$update_demo,
                                 valueExpr = {
                                   test_data_year %>% 
                                     filter(AgeGroup == input$age_input,
                                            year == input$year_input_demo)
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
  
  output$demo_output <- renderPlot(
    filtered_demo() %>% 
      ggplot(aes(x = WeekEnding, y = NumberAdmissions)) +
      geom_line(aes(colour = HB))
  )
}

shinyApp(ui, server)
