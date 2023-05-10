ui <- fluidPage( theme = phs_theme,
                 column(width = 5,
                        h1(id="big-heading", "Covid-19 Dashboard"),
                        tags$style(HTML("#big-heading{color: #948DA3;
                                 background-color: #80BCEA;
                                 border-style: solid;
                                 border-color: #0078D4}"))
                 ),
                 # titlePanel("Change me!", windowTitle = "Covid-19 Dashboard - DR20 group project"),
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
                     tabsetPanel(
                       tabPanel(
                         title = "Admissions",
                         tags$h3("Number of Hospital Admissions"),
                         tags$br(),
                         print("The below displays data from 2017Q3 - 2022Q3 and includes all available data."),
                         tags$br(),
                         tags$br(),
                         fluidRow(
                           column(width = 3,
                                  actionButton(inputId = "hospital_admission_stat_update",
                                               label = "Update Tables",
                                               icon = icon("refresh"))
                           )
                         ),
                         fluidRow(
                           column(width = 4,
                                  selectInput(inputId = "hospital_admission_stats_health_board_input",
                                              label = "Select Health Board(s):",
                                              choices = health_board_choice,
                                              multiple = TRUE
                                  )
                           ),
                           column(width = 4,
                                  selectInput(inputId = "hospital_admission_stats_quarter_input",
                                              label = "Select Quarter(s):",
                                              choices = c("1", "2", "3", "4"),
                                              multiple = TRUE
                                  ),
                           ),
                           column(width = 4,
                                  selectInput(inputId = "hospital_admission_stats_year_input",
                                              label = "Select Year:",
                                              choices = c("2017", "2018", "2019", "2020", "2021", "2022"),
                                              multiple = TRUE
                                  )
                           ),
                         ),
                         
                         
                         fluidRow(
                           column(width = 8,
                                  dataTableOutput("hospital_admission_stats_split_output")
                           ),
                           column(width = 1,
                                  img(src = "av_hosp_graph.png", style = "width: 800px"))
                         ),
                       ), # tab panel - admissions
                       tabPanel(
                         title = "LoS",
                         tags$h3("Length of Stay"),
                         tags$br(),
                         print("The below displays data from 2017Q3 - 2022Q3 and includes all available data."),
                         tags$br(),
                         tags$br(),
                         fluidRow(
                           column(width = 3,
                                  actionButton(inputId = "length_of_stay_stat_update",
                                               label = "Update Tables",
                                               icon = icon("refresh"))
                           )
                         ),
                         fluidRow(
                           column(width = 4,
                                  selectInput(inputId = "length_of_stay_stats_health_board_input",
                                              label = "Select Health Board(s):",
                                              choices = health_board_choice,
                                              multiple = TRUE
                                  )
                           ),
                           column(width = 4,
                                  selectInput(inputId = "length_of_stay_stats_quarter_input",
                                              label = "Select Quarter(s):",
                                              choices = c("1", "2", "3", "4"),
                                              multiple = TRUE
                                  ),
                           ),
                           column(width = 4,
                                  selectInput(inputId = "length_of_stay_stats_year_input",
                                              label = "Select Year:",
                                              choices = c("2017", "2018", "2019", "2020", "2021", "2022"),
                                              multiple = TRUE
                                  )
                           ),
                         ),
                         fluidRow(
                           column(width = 8,
                                  dataTableOutput("length_of_stay_stats_output")
                           ),
                           column(width = 1,
                                  img(src = "av_length_graph.png", style = "width: 800px"))
                         ),
                         
                       ), # tab panel length of stay
                       tabPanel(
                         title = "Beds",
                         tags$h3("Hospital beds occupancy"),
                         tags$br(),
                         print("The below displays data from 2017Q3 - 2022Q3 and includes all available data."),
                         tags$br(),
                         tags$br(),
                         fluidRow(
                           column(width = 3,
                                  actionButton(inputId = "beds_stat_update",
                                               label = "Update Tables",
                                               icon = icon("refresh"))
                           )
                         ),
                         fluidRow(
                           column(width = 4,
                                  selectInput(inputId = "beds_stats_health_board_input",
                                              label = "Select Health Board(s):",
                                              choices = health_board_choice,
                                              multiple = TRUE
                                  )
                           ),
                           column(width = 4,
                                  selectInput(inputId = "beds_stats_quarter_input",
                                              label = "Select Quarter(s):",
                                              choices = c("Q1", "Q2", "Q3", "Q4"),
                                              multiple = TRUE
                                  ),
                           ),
                           column(width = 4,
                                  selectInput(inputId = "beds_stats_year_input",
                                              label = "Select Year:",
                                              choices = c("2017", "2018", "2019", "2020", "2021", "2022"),
                                              multiple = TRUE
                                  )
                           ),
                         ),
                         fluidRow(
                           column(width = 8,
                                  dataTableOutput("beds_stats_output")
                           ),
                           column(width = 1,
                                  img(src = "av_bed_occ_graph.png", style = "width: 800px"))
                         ),
                       ) 
                     ) # tab set panel
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
                              pickerInput(inputId = "admission_input_tempo",
                                          label = "Select Admission Type",
                                          choices = admission_choice,
                                          pickerOptions(actionsBox = TRUE),
                                          selected = "All Inpatients",
                                          multiple = TRUE)
                              
                              
                       ),
                       column(width = 3,
                              
                              pickerInput(inputId = "health_board_input_tempo",
                                          label = "Select Health Board",
                                          choices = health_board_choice,
                                          selected = "All of Scotland",
                                          multiple = TRUE,
                                          pickerOptions(actionsBox = TRUE))
                       ),
                       
                       column(width = 6,
                              print("This is an example of the text that could go here! 
                            Just imagine."))
                     ),
                     fluidRow(
                       column(width = 3,
                              actionButton(inputId = "update_temporal",
                                           label = "Update dashboard",
                                           icon = icon("refresh"))
                       )
                     ),
                     
                     plotOutput("temporal_output"),
                     
                     
                     fluidRow(
                       print("This is space for us to put some analysis relating to the results of each graph - but for now it is just gonna have rubbish in it.
            This would be where some stats go, but good luck interpretting these nonsense graphs")
                     )
                   ),
                   
                   tabPanel(
                     title = "Geographical",
                     
                     
                       
                       
                       fluidRow(
                         
                         column(width = 3,
                                offset = 0,
                                selectInput(inputId = "year_input_geo",
                                            label = "Select Year",
                                            choices = geo_year_choice,
                                            selected = 2020)
                         ),
                         column(width = 3,
                                selectInput(inputId = "quarter_input_geo",
                                            label = "Select Quarter",
                                            choices = geo_quarter_choice,
                                            selected = "Q1")
                                ),
                         column(width = 6,
                                print("Textbox explaining this page?"))
                         ),
                         fluidRow(
                         column(width = 4,
                                actionButton(inputId = "update_geo_date",
                                             label = "Update map",
                                             icon = icon("map-location-dot")))
                         ),
                       
                       fluidRow(
                         column(offset = 1,
                                width = 10,
                                leafletOutput("geo_map_output")
                         ),
                         column(width = 6,
                                offset = 0,
                                pickerInput(inputId = "health_board_input_geo",
                                            label = "Select Health Board",
                                            choices = geo_healthboard_choice,
                                            selected = "All of Scotland",
                                            pickerOptions(actionsBox = TRUE),
                                            multiple = TRUE),
                                
                         ),
                         # column(width = 6,
                         #        selectInput(inputId = "year_input_geo",
                         #                    label = "Select Year",
                         #                    choices = year_choice,
                         #                    selected = "2020"),
                         # ),
                         
                         
                         fluidRow(
                           column(width = 3,
                                  actionButton(inputId = "update_geo",
                                               label = "Update dashboard",
                                               icon = icon("refresh")
                                  )
                           ),
                           plotOutput("geo_output"),
                           fluidRow(
                             column(width = 10,
                                    offset = 0,
                                    print("")
                             ),
                         
                       ),
                     ),
                   ),
                   ),
                   tabPanel(
                     title = "Speciality",
                     tabsetPanel(
                       tabPanel(
                         title = "Specialities by mean",
                     fluidRow(
                       radioButtons(inputId = "speciality_plot_type_input",
                                    label = "View:",
                                    choices = c("Mean Admissions", "Mean Length of Stay"),
                       ),
                       fluidRow( 
                         column(width = 6,
                                pickerInput(
                                  inputId = "speciality_input",
                                  label = "Please select Speciality(s)",
                                  choices = speciality_choice,
                                  multiple = TRUE,
                                  selected = "General Surgery",
                                  pickerOptions(actionsBox = TRUE)
                                ),
                         ),
                         column(width = 6,
                                print("I don't think you've considered the impact of being able to write text here."))
                       )
                     ),
                     actionButton(inputId = "update_speciality",
                                  label = "Update Dashboard",
                                  icon = icon("cat", class = "fa-bounce")),
                     fluidRow(
                       plotOutput("speciality_output"),
                        ),
                     ), # closes tabPanel for speciality by mean
                     tabPanel(
                       title = "Admissions by Speciality",
                     fluidRow(
                       column(width = 4,
                       pickerInput(
                         inputId = "speciality_input_longer",
                         label = "Please select Speciality(s)",
                         choices = speciality_choice_longer,
                         multiple = TRUE,
                         selected = "General Surgery",
                         pickerOptions(actionsBox = TRUE)
                       )
                       ),
                       column(width = 8,
                              print("We can put text here if we need to"))
                       ),
                       fluidRow(
                         column(width = 4,
                         actionButton(inputId = "update_speciality_means",
                                      label = "Update Dashboard",
                                      icon = icon("cat", class = "fa-bounce")),
                         )
                       ),
                       fluidRow(
                       plotOutput("speciality_occupancy"),
                       )
                   
                   ) # closes tabPanel
                   ) # closes tabSetPanel
                   ), # closes tabPanel for speciality
                   
                   
                   tabPanel(
                     title = "Demographics",
                     tabsetPanel(
                       tabPanel(
                         title = "Age",
                         
                         fluidRow(
                           tags$br(),
                           column(width = 4,
                                  
                                  radioButtons(inputId = "age_plot_type_input",
                                               label = "View:",
                                               choices = c("Mean No. of Admissions", "Mean Length of Stay"))
                           ),
                         ),
                         fluidRow(
                           column(width = 4,
                                  
                                  
                                  pickerInput(inputId = "age_input",
                                              label = "Select Age Range(s) To Compare:",
                                              choices = age_choice,
                                              multiple = TRUE,
                                              selected = "20-29",
                                              pickerOptions(actionsBox = TRUE))
                           ),
                           
                           
                           
                           
                           column(width = 8,
                                  print("This is a more sensible text box")
                                  
                           )
                         ),
                         fluidRow(
                           
                           column(width = 4,
                                  actionButton(inputId = "update_demo_age",
                                               label = "Update Dashboard",
                                               icon = icon("refresh"))
                           )
                         ),
                         
                         fluidRow(
                           plotOutput("demo_age_output"),
                           print("")
                           
                         ),
                         
                       ),
                       
                       tabPanel(
                         title = "Deprivation",
                         
                         fluidRow( 
                           column(width = 3,
                                  
                                  radioButtons(inputId = "deprivation_plot_type_input",
                                               label = "View:",
                                               choices = c("Mean No. of Admissions", "Mean Length of Stay"))
                           )
                         ),
                         # tags$br(),
                         fluidRow(
                           column(width = 4,
                                  
                                  
                                  pickerInput(inputId = "deprivation_input",
                                              label = "Select Deprivation Categories To Compare:",
                                              choices = deprivation_choice,
                                              multiple = TRUE,
                                              pickerOptions(actionsBox = TRUE),
                                              selected = 1)
                           ),
                           
                           
                           
                           
                           
                           column(width = 8,
                                  print("The plots below use the Scottish Index of Multiple Deprivation, where SIMD 1
                  is considered the most deprived and SIMD 5 being least deprived.")
                           ),
                         ), 
                         fluidRow(
                           column(width = 4,
                                  actionButton(inputId = "update_demo_deprivation",
                                               label = "Update Dashboard",
                                               icon = icon("refresh"))
                           )
                         ),
                         
                         fluidRow(
                           plotOutput("demo_deprivation_output")
                         ),
                         
                         fluidRow(
                           print("")
                           
                         ),
                       ),
                       
                       tabPanel(
                         title = "Gender & Age",
                         
                         fluidRow(
                           column(width = 4,
                                  radioButtons(inputId = "age_gender_plot_type_input",
                                               label = "View:",
                                               choices = c("No. of Admissions", "Average Length of Stay"))
                           ),  
                         ),
                         #tags$br(),
                         fluidRow(
                           column(width = 4,
                                  pickerInput(inputId = "gender_age_input",
                                              label = "Select Age Range(s) To Compare:",
                                              choices = age_choice,
                                              multiple = TRUE,
                                              pickerOptions(actionsBox = TRUE),
                                              selected = "20-29"),
                           ),
                           
                           column(width = 6,
                                  print("This is the last one. Wasn't this fun?")  
                           ),
                         ),
                         
                         fluidRow(
                           column(width = 4,
                                  actionButton(inputId = "update_demo_gender_age",
                                               label = "Update Dashboard",
                                               icon = icon("refresh")),
                           )
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
                 hr(),
                 print("Data taken from "),
                 tags$a(href = "https://www.opendata.nhs.scot/dataset?groups=covid-19",
                        "Public Health Scotland"),
                 tags$br(),
                 print("Icons taken from "),
                 tags$a(href = "https://fontawesome.com/icons",
                        "FontAwesome")
)

