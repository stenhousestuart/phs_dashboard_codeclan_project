
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
  
  filtered_age_demo <- eventReactive(eventExpr = input$update_demo,
                                 valueExpr = {
                                   admission_demographics_all %>%
                                     filter(age %in% input$age_input) %>% 
                                     group_by(quarter, age, pre_post_2020) %>% 
                                     summarise(mean_admissions = mean(episodes)) %>% 
                                     ggplot(aes(x = quarter, y = mean_admissions)) +
                                     geom_point(aes(colour = age)) +
                                     geom_line(aes(group = age, colour = age)) +
                                     facet_wrap(~pre_post_2020) +
                                     labs(
                                       x = "\n Quarter",
                                       y = "Mean Episodes of Care \n",
                                       title = "Mean Episodes of Care by Age & Quarter",
                                       colour = "Age:")
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
  
  output$demo_age_output <- renderPlot(
    filtered_age_demo()
  )
}