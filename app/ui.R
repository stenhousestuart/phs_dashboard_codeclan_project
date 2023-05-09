ui <- fluidPage(
  titlePanel("Change me!"),
  tabsetPanel(
    
    tabPanel(
      title = ".README",
      
      fluidRow(
        tags$br(),
        print("This is space for us to put some introductory text - explaining the 
              purpose of the app, a short description of each tab along with details and rational
              behind any assumptions/decisions.")
      ),
      
    ),  
    
    tabPanel(
      title = "Stats",
      dataTableOutput("stats_table_output"),
      
    ),  
    tabPanel(
      title = "Temporal",
      
      fluidRow(
        column(width = 6,
               selectInput(inputId = "admission_input_tempo",
                           label = "Select Admission Type",
                           choices = admission_choice,
                           selected = "All Inpatients")
        ),
        column(width = 6,
               selectInput(inputId = "health_board_input_tempo",
                           label = "Select Health Board",
                           choices = health_board_choice,
                           selected = "All of Scotland")
        ),
      ),
      fluidRow(
        actionButton(inputId = "update_temporal",
                     label = "Update dashboard")
      ),
      plotOutput("temporal_out_length_stay"),
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
             selectInput(inputId = "health_board_input_geo",
                         label = "Select Health Board",
                         choices = health_board_choice,
                         multiple = TRUE,
                         selected = "All of Scotland")
      ),
      # column(width = 6,
      #        selectInput(inputId = "year_input_geo",
      #                    label = "Select Year",
      #                    choices = year_choice,
      #                    selected = "2020"),
      # ),
      fluidRow(
        actionButton(inputId = "update_geo",
                     label = "Update dashboard")
      ),
      plotOutput("geo_output"),
      fluidRow(
        print("Some NA's were dropped as the data was not available - 20 rows were lost, most pertaining to Dr Gray's Hospital in Grampian")
      )
    ),
    
    
    # using age for the demographic for testing purposes
    tabPanel(
      title = "Demographics",
      tabsetPanel(
        tabPanel(
          title = "Age",
          
          fluidRow(
            tags$br(),
            column(width = 4,
                   
                   selectInput(inputId = "age_input",
                               label = "Select Age Range",
                               choices = age_choice,
                               multiple = TRUE,
                               selected = "All ages"),
            ),
            
            column(width = 4,
                   radioButtons(inputId = "age_plot_type_input",
                                label = "View:",
                                choices = c("Mean No. of Admissions", "Mean Length of Stay")),
            ),
            
            column(width = 4,
                   actionButton(inputId = "update_demo_age",
                                label = "Update Dashboard"),
            ),
          ),
          fluidRow(
            plotOutput("demo_age_output"),
          ),
          
          fluidRow(
            print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs"),
            
          ),
        ),
        
        tabPanel(
          title = "Deprivation",
          
          fluidRow(
            tags$br(),
            column(width = 4,
                   
                   selectInput(inputId = "deprivation_input",
                               label = "Select Deprivation Index",
                               choices = deprivation_choice,
                               multiple = TRUE),
            ),
            
            column(width = 4,
                   radioButtons(inputId = "deprivation_plot_type_input",
                                label = "View:",
                                choices = c("Mean No. of Admissions", "Mean Length of Stay")),
            ),
            
            column(width = 4,
                   actionButton(inputId = "update_demo_deprivation",
                                label = "Update Dashboard"),
            ),
          ),
          
          fluidRow(
            plotOutput("demo_deprivation_output"),
          ),
          
          fluidRow(
            print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
            
          ),
        ),
      ),
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
  