

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
      plotOutput("temporal_out"),
      fluidRow(
        print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
      )
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
      plotOutput("geo_output"),
      fluidRow(
        print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
      )
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
                     label = "Update dashboard")
      ),
      
      plotOutput("demo_output"),
      
      fluidRow(
        print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
        
      )
    ),
    
    
  ),  
  
  # WARNING: THIS MUST BE OUTSIDE tabSetPanel!
  # Testing a "footer" that mentions where data was taken from
  # Will need to alter link and title for actual dataset used
  # Could be shifted into individual tabs if we end up using different datasets for different outputs
  hr(),
  print("Data taken from "),
  tags$a(href = "https://www.opendata.nhs.scot/dataset/covid-19-wider-impacts-hospital-admissions/resource/f8f3a435-1925-4c5a-b2e8-e58fdacf04bb",
         "Public health Scotland")
)
  
