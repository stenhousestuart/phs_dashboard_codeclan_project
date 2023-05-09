
server <- function(input, output, session) {

  # These are test outputs - must be altered to fit real data set!
  # WARNING! THESE LOOK TERRIBLE!
  
  filtered_temporal <- eventReactive(eventExpr = input$update_temporal,
                                     valueExpr = {
                                       clean_hosp_admissions_qyear %>% 
                                         filter(admission_type %in% input$admission_input_tempo,
                                                nhs_health_board %in% input$health_board_input_tempo) %>%
                                         group_by(quarter)
                                         
                                     })

  
  
  filtered_geo <- eventReactive(eventExpr = input$update_geo,
                                valueExpr = {
                                  pre_post_2020_avg_occupancy %>% 
                                    filter(nhs_health_board %in% input$health_board_input_geo) %>% 
                                    mutate(year = factor(year, levels = c("pre 2020", "post 2020")))
                                           
                                })
  
  filtered_age_gender_demo <- eventReactive(eventExpr = input$update_demo_gender_age,
                                             valueExpr = {
                                               
                                               if (input$age_gender_plot_type_input == "No. of Admissions") {
                                               
                                               admission_demographics_all %>%
                                                 mutate(year = factor(year, levels = c("2017", "2018", "2019", "2020", "2021", "2022")),
                                                        season = ifelse(quarter %in% c(2,3), "Spring/Summer", "Autumn/Winter")) %>% 
                                                 filter(age %in% input$gender_age_input,
                                                        year != "2017",
                                                        year != "2022") %>% 
                                                 group_by(sex, age, year, season) %>% 
                                                 summarise(total_admissions = sum(episodes)) %>% 
                                                 ggplot(aes(x = age, y = total_admissions, fill = year)) +
                                                 geom_col(aes(x = age, y = total_admissions, fill = year), position = "dodge") +
                                                 facet_grid(sex~season) +
                                                 labs(
                                                   x = "\n Age",
                                                   y = "Number of Admissions \n",
                                                   title = "Number of Admissions by Age, Gender & Season") +
                                                 theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
                                                 scale_y_continuous(labels = scales::comma)
                                               
                                             }
                                            
                                            else {
                                              
                                              admission_demographics_all %>%
                                                mutate(year = factor(year, levels = c("2017", "2018", "2019", "2020", "2021", "2022")),
                                                       season = ifelse(quarter %in% c(2,3), "Spring/Summer", "Autumn/Winter")) %>%
                                                filter(age %in% input$gender_age_input,
                                                       year != "2017",
                                                       year != "2022") %>% 
                                                group_by(sex, age, year, season) %>% 
                                                ggplot(aes(x = age, y = average_length_of_stay, fill = year)) +
                                                geom_col(aes(x = age, y = average_length_of_stay, fill = year), position = "dodge") +
                                                facet_grid(sex~season) +
                                                labs(
                                                  x = "\n Age",
                                                  y = "Average Length of Stay \n",
                                                  title = "Average Length of Stay by Age, Gender & Season") +
                                                theme(axis.text.x = element_text(angle = 45, vjust = 0.5))
                                              
                                              
                                            }
                                            })
  
  
  filtered_deprivation_demo <- eventReactive(eventExpr = input$update_demo_deprivation,
                                 valueExpr = {
                                  
                                   if (input$deprivation_plot_type_input == "Mean No. of Admissions") {
                                     
                                     admission_deprivation_all %>%
                                       mutate(simd = factor(simd, levels = c("1", "2", "3", "4", "5"))) %>%
                                       filter(simd %in% input$deprivation_input) %>%
                                       mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>% 
                                       group_by(quarter, simd, pre_post_2020) %>% 
                                       summarise(mean_episodes = mean(episodes)) %>% 
                                       ggplot(aes(x = quarter, y = mean_episodes)) +
                                       geom_point(aes(colour = simd)) +
                                       geom_line(aes(group = simd, colour = simd)) +
                                       facet_wrap(~pre_post_2020) +
                                       labs(
                                         x = "\n Quarter",
                                         y = "Mean Episodes of Care \n",
                                         title = "Mean Episodes of Care by SIMD & Quarter",
                                         colour = "SIMD:")
                                   
                                   }
                                   
                                   else {
                                    
                                     admission_deprivation_all %>%
                                       mutate(simd = factor(simd, levels = c("1", "2", "3", "4", "5"))) %>%
                                       filter(simd %in% input$deprivation_input) %>% 
                                       mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>% 
                                       group_by(quarter, simd, pre_post_2020) %>% 
                                       summarise(mean_length_of_stay = mean(average_length_of_stay)) %>% 
                                       ggplot(aes(x = quarter, y = mean_length_of_stay)) +
                                       geom_point(aes(colour = simd)) +
                                       geom_line(aes(group = simd, colour = simd)) +
                                       facet_wrap(~pre_post_2020) +
                                       labs(
                                         x = "\n Quarter",
                                         y = "Mean Length of Stay \n",
                                         title = "Mean Length of Stay by SIMD & Quarter",
                                         colour = "SIMD:")
                                     
                                     
                                   }
                                     })
  

  filtered_age_demo <- eventReactive(eventExpr = input$update_demo_age,
                                     valueExpr = {
                                       
                                       if (input$age_plot_type_input == "Mean No. of Admissions") {
                                         
                                         admission_demographics_all %>%
                                           filter(age %in% input$age_input) %>% 
                                           mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>% 
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
                                         
                                       }
                                       
                                       else {
                                         
                                         admission_demographics_all %>%
                                           filter(age %in% input$age_input) %>%
                                           mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>% 
                                           group_by(quarter, age, pre_post_2020) %>% 
                                           summarise(mean_length_of_stay = mean(average_length_of_stay)) %>% 
                                           ggplot(aes(x = quarter, y = mean_length_of_stay)) +
                                           geom_point(aes(colour = age)) +
                                           geom_line(aes(group = age, colour = age)) +
                                           facet_wrap(~pre_post_2020) +
                                           labs(
                                             x = "\n Quarter",
                                             y = "Mean Length of Stay \n",
                                             title = "Mean Length of Stay by Age & Quarter",
                                             colour = "Age:")  
                                         
                                         
                                       }
                                     })
                                       
    
  
# finds the highest value for total episodes to position labels correctly
  max_total_episodes <- eventReactive(eventExpr = input$update_temporal,
                                      valueExpr = {
                                        clean_hosp_admissions_qyear %>%
                                          filter(admission_type %in% input$admission_input_tempo,
                                                 nhs_health_board %in% input$health_board_input_tempo) %>%
                                          group_by(quarter) %>%
                                          summarise(total_episodes = sum(episodes)) %>%
                                          select(total_episodes) %>%
                                          slice_max(total_episodes, n = 1) %>% 
                                          pull()
                                      })
  
  # finds lowest percentage occupancy to set min limit for Y axis  
  min_beds <- eventReactive(eventExpr = input$update_geo,
                            valueExpr = {
                              pre_post_2020_avg_occupancy %>% 
                                filter(nhs_health_board %in% input$health_board_input_geo) %>% 
                                select(percentage_occupancy) %>% 
                                slice_min(percentage_occupancy, n = 1) %>% 
                                pull()
                              })
  
# finds highest percentage occupancy to set max limit for Y axis
 max_beds <- eventReactive(eventExpr = input$update_geo,
                            valueExpr = {
                              pre_post_2020_avg_occupancy %>% 
                                filter(nhs_health_board %in% input$health_board_input_geo) %>% 
                                select(percentage_occupancy) %>% 
                                slice_max(percentage_occupancy, n = 1) %>% 
                                pull()
                            })
  
  
  output$temporal_out_total_episodes <- renderPlot(
    filtered_temporal() %>% 
      summarise(total_episodes = sum(episodes)) %>% 
      ggplot() +
      aes(x = quarter, y = total_episodes) +
      geom_line(aes(group = 1, colour = "red"),show.legend = FALSE) +
      geom_point(size = 4, shape = 17, colour = "red") +
      geom_line(aes(group = quarter)) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))+
      scale_colour_brewer(palette = "Dark2") +
      geom_label(
        label = "Pre-2020",
         x = 2.5,
         y = max_total_episodes(),
        label.padding = unit(0.15, "lines"),
        label.size = 0.15,
        color = "black"
      ) +
      geom_label(
        label = "Post-2020",
         x = 20,
         y = max_total_episodes(),
        label.padding = unit(0.15, "lines"),
        label.size = 0.15,
        color = "black"
      ) +
      geom_vline(xintercept = 10.5, linetype = "dashed") +
      labs(
        title = "Total Number of Hospital Admissions",
        subtitle = "Quarterly Data from Q3 2017-Q3 2022\n",
        x = "Quarter",
        y = "Hospital Admissions")
  )
  
  output$temporal_out_length_stay <- renderPlot(
   filtered_temporal() %>% 
      summarise(average_length_of_stay = mean(average_length_of_stay)) %>% 
      ggplot() +
      aes(x = quarter, y = average_length_of_stay) +
      geom_line(aes(group = 1, colour = "red")) +
      geom_point(size = 4, shape = 17, colour = "red") +
      geom_line(aes(group = quarter)) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust = 0.5)) +
      scale_colour_brewer(palette = "Dark2") +
      geom_label(
        label = "Pre-Pandemic",
        x = 2.5,
        y = 140000,
        label.padding = unit(0.15, "lines"),
        label.size = 0.15,
        color = "black"
      ) +
      geom_label(
        label = "Pandemic",
        x = 20,
        y = 140000,
        label.padding = unit(0.15, "lines"),
        label.size = 0.15,
        color = "black"
      ) +
      geom_vline(xintercept = 11.5, linetype = "dashed") +
      # geom_vline(xintercept = 3.5, linetype = "dashed") +
      labs(
        title = "Total Number of Hospital Admissions",
        subtitle = "Quarterly Data from Q3 2017-Q3 2022\n",
        x = "Quarter",
        y = "Mean of Average Length of Stay") 
  )
  
  output$geo_output <- renderPlot(
    filtered_geo() %>% 
      ggplot(aes(x = factor(quarter, 
                            level = c("Q3", "Q4", "Q1", "Q2")), 
                 y = percentage_occupancy, 
                 group = nhs_health_board, 
                 colour = nhs_health_board)) + 
      geom_line() +
      facet_wrap(~year) +
      labs(
        x = "Quarter", 
        y = "Percentage of Occupied Beds",
        title = "Average Hospital Bed Occupancy per Location and Quarter",
        colour = "NHS Health Board"
      ) +
      ylim(min_beds(),max_beds())
  )
  
  output$demo_age_output <- renderPlot(
    filtered_age_demo()
  )
  
  output$demo_deprivation_output <- renderPlot(
    filtered_deprivation_demo()
  )
  
  output$demo_age_gender_output <- renderPlot(
    filtered_age_gender_demo()
  )
  
  output$stats_table_output <- renderDataTable(
    
    clean_hosp_admissions_qyear %>% 
      filter(nhs_health_board != "All of Scotland",
             nhs_health_board != "Non-NHS Provider",
             admission_type == "All Inpatients") %>% 
      group_by(quarter) %>%
      summarise(mean_hospital_admissions = mean(episodes),
                median_hospital_admissions = median(episodes),
                sd_hospital_admissions = sd(episodes),
                iqr_hospital_admissions = IQR(episodes)) %>% 
      separate(quarter,into = c("year", "quarter"), sep = "Q" )
  )
  
}