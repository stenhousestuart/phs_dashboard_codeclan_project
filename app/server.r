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