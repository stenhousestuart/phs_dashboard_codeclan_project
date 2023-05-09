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
      )
      
    ),
    
    tabPanel(
      title = "Stats",
      tags$br(),
      tags$h3("Number of Hospital Admissions"),
      tags$br(),
      print("The below displays data from 2017Q3 - 2022Q3 and includes all available data."),
      tags$br(),
      tags$br(),
      fluidRow(
        selectInput(inputId = "stats_year_input",
                    label = "Select Year:",
                    choices = c("2017", "2018", "2019", "2020", "2021", "2022")
        ),
      ),    
      
      fluidRow(
        dataTableOutput("stats_table_output")
      ),
      
      
    ),
    tabPanel(
      title = "Temporal",
      fluidRow(
        radioButtons(inputId = "temporal_plot_type_input",
                     label = "View:",
                     choices = c("Total Number of Admissions", "Mean Length of Stay")
        )
      ),
      fluidRow(
        column(width = 3,
               selectInput(inputId = "admission_input_tempo",
                           label = "Select Admission Type",
                           choices = admission_choice,
                           selected = "All Inpatients")
        ),
        column(width = 3,
               selectInput(inputId = "health_board_input_tempo",
                           label = "Select Health Board",
                           choices = health_board_choice,
                           selected = "All of Scotland")
        ),
        
        column(width = 6,
               print("This is an example of the text that could go here! 
                            Just imagine."))
      ),
      fluidRow(
        actionButton(inputId = "update_temporal",
                     label = "Update dashboard")
      ),
      
      plotOutput("temporal_output"),
      
      
      fluidRow(
        print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
      )
    ),
    # this allows for multiple inputs for Health Board - Actual data set
    # will probably need more human readable choice names
    tabPanel(
      title = "Geographical",
      fluidRow(
        column(width = 6,
               selectInput(inputId = "health_board_input_geo",
                           label = "Select Health Board",
                           choices = geo_healthboard_choice,
                           multiple = TRUE,
                           selected = "All of Scotland")
        ),
        column(width = 6,
               print("This is another example. Can you picture yourself here?")),
        # column(width = 6,
        #        selectInput(inputId = "year_input_geo",
        #                    label = "Select Year",
        #                    choices = year_choice,
        #                    selected = "2020"),
        # ),
      ),
      fluidRow(
        actionButton(inputId = "update_geo",
                     label = "Update dashboard")
      ),
      plotOutput("geo_output"),
      fluidRow(
        print("Some NA's were dropped as the data was not available - 20 rows were lost, most pertaining to Dr Gray's Hospital in Grampian")
      ),
      fluidRow(
        column(width = 4,
               selectInput(inputId = "year_input_geo",
                           label = "Select Year",
                           choices = geo_year_choice,
                           selected = 2020)
        ),
        column(width = 4,
               selectInput(inputId = "quarter_input_geo",
                           label = "Select Quarter",
                           choices = geo_quarter_choice,
                           selected = "Q1")
        ),
        column(width = 4,
               actionButton(inputId = "update_geo_date",
                            label = "Update dashboard"))
      ),
      fluidRow(
        leafletOutput("geo_map_output"),
        print("We could put some analysis here. Or we could drop this part. Either or.")
      ),
    ),
    
    tabPanel(
      title = "Speciality",
      fluidRow(
        radioButtons(inputId = "speciality_plot_type_input",
                     label = "View:",
                     choices = c("Mean Admissions", "Mean Length of Stay"),
        ),
        
        column(width = 6,
               selectInput(
                 inputId = "speciality_input",
                 label = "Please select Speciality(s)",
                 choices = speciality_choice,
                 multiple = TRUE,
                 selected = "General Surgery"
               ),
        ),
        column(width = 6,
               print("I don't think you've considered the impact of being able to write text here."))
      ),
      actionButton(inputId = "update_speciality",
                   label = "Update Dashboard"),
      
      
      
      fluidRow(
        plotOutput("speciality_output"),
        plotOutput("testing_occupancy"),
        selectInput(
          inputId = "speciality_input_longer",
          label = "Please select Speciality(s)",
          choices = speciality_choice_longer,
          multiple = TRUE,
          selected = "General Surgery"
        ),
        
      ),
      fluidRow(
        print("Please note that in the dataset used to produce these visualisations, there were a number of NA values for length of stay - 
        These have been dropped, and therefore may affect results.")
      ),
    ),
    
    # using age for the demographic for testing purposes
    tabPanel(
      title = "Demographics",
      tabsetPanel(
        tabPanel(
          title = "Age",
          
          fluidRow(
            tags$br(),
            column(width = 3,
                   
                   selectInput(inputId = "age_input",
                               label = "Select Age Range(s) To Compare:",
                               choices = age_choice,
                               multiple = TRUE,
                               selected = "All ages")
            ),
            
            column(width = 3,
                   radioButtons(inputId = "age_plot_type_input",
                                label = "View:",
                                choices = c("Mean No. of Admissions", "Mean Length of Stay"))
            ),
            column(width = 6,
                   print("This is an example of putting text here. This shows the extent of the amount of text we can put in this part, please excuse the A's. AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, AAAAAAAAAAA
                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA , AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ,AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 
                         AAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAA ok so its basically as much space as the text needs, no worries.")
            )
          ),
          fluidRow(
            
            column(width = 4,
                   actionButton(inputId = "update_demo_age",
                                label = "Update Dashboard"))
          ),
          
          
          fluidRow(
            plotOutput("demo_age_output"),
            print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
          ),
          
          
        ),
        
        
        
        tabPanel(
          title = "Deprivation",
          
          fluidRow(
            tags$br(),
            column(width = 3,
                   
                   selectInput(inputId = "deprivation_input",
                               label = "Select Deprivation Categoris To Compare:",
                               choices = deprivation_choice,
                               multiple = TRUE)
            ),
            
            column(width = 3,
                   radioButtons(inputId = "deprivation_plot_type_input",
                                label = "View:",
                                choices = c("Mean No. of Admissions", "Mean Length of Stay"))
            ),
            
            column(width = 6,
                   print("This is another text space - But i'm running out of ideas for things to put in it.")
            ),
          ), 
          fluidRow(
            
            actionButton(inputId = "update_demo_deprivation",
                         label = "Update Dashboard")
          ),
          
          fluidRow(
            plotOutput("demo_deprivation_output")
          ),
          
          fluidRow(
            print("The above plots use the Scottish Index of Multiple Deprivation, where SIMD 1
                  is considered the most deprived and SIMD 5 being least deprived.")
            
          ),
        ),
        
        tabPanel(
          title = "Gender & Age",
          
          fluidRow(
            tags$br(),
            column(width = 3,
                   
                   selectInput(inputId = "gender_age_input",
                               label = "Select Age Range(s) To Compare:",
                               choices = age_choice,
                               multiple = TRUE),
            ),
            
            column(width = 3,
                   radioButtons(inputId = "age_gender_plot_type_input",
                                label = "View:",
                                choices = c("No. of Admissions", "Average Length of Stay")),
            ),
            
            
            column(width = 6,
                   print("This is the last one. Wasn't this fun?")  
            ),
          ),
          fluidRow(
            actionButton(inputId = "update_demo_gender_age",
                         label = "Update Dashboard"),
          ),
          fluidRow(
            plotOutput("demo_age_gender_output"),
          ),
          
          fluidRow(
            print("Only years where complete data is available have been included.")
            
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
