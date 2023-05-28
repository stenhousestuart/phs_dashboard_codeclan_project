
server <- function(input, output, session) {
  
  
  
  
  
  
  filtered_temporal <- eventReactive(eventExpr = input$update_temporal,
                                     valueExpr = {
                                       clean_hosp_admissions_qyear %>% 
                                         filter(admission_type %in% input$admission_input_tempo,
                                                nhs_health_board %in% input$health_board_input_tempo) %>%
                                         group_by(quarter, nhs_health_board)
                                       
                                     })
  
  
  
  filtered_geo <- eventReactive(eventExpr = input$update_geo,
                                valueExpr = {
                                  pre_post_2020_avg_occupancy %>% 
                                    mutate(year = if_else(year == "post 2020", "2020 - 2022", "2017 - 2019")) %>% 
                                    filter(nhs_health_board %in% input$health_board_input_geo) %>% 
                                    mutate(year = factor(year, levels = c("2017 - 2019", "2020 - 2022"))) %>% 
                                    ggplot(aes(x = factor(quarter, 
                                                          level = c("Q1", "Q2", "Q3", "Q4")), 
                                               y = percentage_occupancy, 
                                               group = nhs_health_board, 
                                               colour = nhs_health_board)) + 
                                    geom_point(size = 6, shape = 17) +
                                    geom_line(size = 1)+
                                    facet_wrap(~year) +
                                    labs(
                                      x = "Quarter", 
                                      y = "Percentage of Occupied Beds",
                                      title = "Mean Hospital Bed Occupancy per Location and Quarter",
                                      colour = "NHS Health Board"
                                    ) +
                                    theme_light() +
                                    scale_colour_manual(values = phs_colour_scheme) +
                                    theme(plot.title = element_text(size = 18, face = "bold"),
                                          plot.subtitle = element_text(size = 17),
                                          axis.title.x = element_text(size = 16),
                                          axis.title.y = element_text(size = 16))
                                  
                                })
  
  filtered_geo_date <- eventReactive(eventExpr = input$update_geo_date,
                                     valueExpr = {
                                       
                                       geo_year <- input$year_input_geo
                                       geo_quart <- input$quarter_input_geo
                                       title <- HTML("<h6>Percentage Occupancy by NHS Location</h6")
                                       
                                       validate(need(!(geo_year %in% 2017 & geo_quart %in% c("Q1", "Q2")), "There is no data for the date range you have selected, please reselect."))
                                       validate(need(!(geo_year %in% 2022 & geo_quart %in% "Q4"), "There is no data for the date range you have selected, please reselect."))
                                       
                                       locations_occupancy_full %>% 
                                         group_by(location, year, quarter) %>% 
                                         mutate(mean_occ = round(mean(percentage_occupancy), digits = 2), 
                                                mean_beds = floor(mean(average_occupied_beds))) %>% 
                                         ungroup() %>%  # adds columns for mean % occ and mean occ beds for each location, year, quarter
                                         filter(year == input$year_input_geo & quarter == input$quarter_input_geo) %>% 
                                         leaflet() %>% 
                                         addTiles() %>% 
                                         addCircleMarkers(lng = ~longitude,
                                                          lat = ~latitude,
                                                          color = ~geo_palette(mean_occ),
                                                          stroke = FALSE,
                                                          label = ~location,
                                                          popup = ~paste(location, "<br> Average Occupied beds:", mean_beds, "<br> Average Percentage Occupied:", mean_occ)) %>% 
                                         addLegend(position = "bottomright", pal = geo_palette, values = ~percentage_occupancy, opacity = 2, title = "Average Percentage Occupied") %>% 
                                         addControl(position = "topright", html = title)
                                       
                                       
                                       
                                       
                                     })
  
  # filtered_geo <- eventReactive(eventExpr = input$update_geo,
  #                               valueExpr = {
  #                                 pre_post_2020_avg_occupancy %>% 
  #                                   filter(nhs_health_board %in% input$health_board_input_geo) %>% 
  #                                   mutate(year = factor(year, levels = c("pre 2020", "post 2020"))) %>% 
  #                                 ggplot(aes(x = factor(quarter, 
  #                                                       level = c("Q1", "Q2", "Q3", "Q4")), 
  #                                            y = percentage_occupancy, 
  #                                            group = nhs_health_board, 
  #                                            colour = nhs_health_board)) + 
  #                                   geom_line() +
  #                                   facet_wrap(~year) +
  #                                   labs(
  #                                     x = "Quarter", 
  #                                     y = "Percentage of Occupied Beds",
  #                                     title = "Average Hospital Bed Occupancy per Location and Quarter",
  #                                     colour = "NHS Health Board"
  #                                   ) #+
  #                                 #ylim(min_beds, max_beds)
  #                                          
  #                               })
  # filtered_geo_date <- eventReactive(eventExpr = input$update_geo_date,
  #                                    valueExpr = {
  #                                        locations_occupancy_full %>% 
  #                                        filter(year == input$year_input_geo & quarter == input$quarter_input_geo) %>% 
  #                                        leaflet() %>% 
  #                                        addTiles() %>% 
  #                                        addCircleMarkers(lng = ~longitude,
  #                                                         lat = ~latitude,
  #                                                         color = ~geo_palette(percentage_occupancy),
  #                                                         stroke = FALSE)
  #                                      
  #                                    })
  
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
                                                  labs(x = "\n Age",
                                                       y = "Number of Admissions \n",
                                                       title = "Number of Admissions by Age, Gender & Season") +
                                                  theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
                                                  scale_y_continuous(labels = scales::comma) + 
                                                  theme_light() +
                                                  scale_fill_discrete_phs(palette = "main-blues") +
                                                  theme(plot.title = element_text(size = 18, face = "bold"),
                                                        plot.subtitle = element_text(size = 17),
                                                        axis.title.x = element_text(size = 16),
                                                        axis.title.y = element_text(size = 16))
                                                
                                              }
                                              
                                              else {
                                                
                                                admission_demographics_all %>%
                                                  mutate(year = factor(year, levels = c("2017", "2018", "2019", "2020", "2021", "2022")),
                                                         season = ifelse(quarter %in% c(2,3), "Spring/Summer", "Autumn/Winter")) %>%
                                                  filter(age %in% input$gender_age_input,
                                                         year != "2017",
                                                         year != "2022") %>% 
                                                  group_by(year, sex, age, season) %>%
                                                  select(year, sex, age, season, average_length_of_stay) %>% 
                                                  summarise(mean_length_of_stay = mean(average_length_of_stay)) %>% 
                                                  ggplot(aes(x = age, y = mean_length_of_stay, fill = year)) +
                                                  geom_col(aes(x = age, y = mean_length_of_stay, fill = year), position = "dodge") +
                                                  facet_grid(sex~season) +
                                                  labs(x = "\n Age",
                                                       y = "Average Length of Stay \n",
                                                       title = "Average Length of Stay by Age, Gender & Season") +
                                                  theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
                                                  theme_light() +
                                                  scale_fill_discrete_phs(palette = "main-blues") +
                                                  theme(plot.title = element_text(size = 18, face = "bold"),
                                                        plot.subtitle = element_text(size = 17),
                                                        axis.title.x = element_text(size = 16),
                                                        axis.title.y = element_text(size = 16))
                                                
                                                
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
                                                   # stat_summary(fun.data = "mean_se",
                                                   #              mult = 1,
                                                   #              geom = "errorbar",
                                                   #              width = .1,
                                                   #              aes(colour = simd),
                                                   #              alpha = 0.6) +
                                                   # stat_summary(fun = "mean", geom = "point", size = 4, aes(colour = simd)) +
                                                   geom_point(aes(colour = simd),
                                                              size = 6,
                                                              shape = 17) +
                                                   geom_line(aes(group = simd, colour = simd),
                                                             size = 1) +
                                                   # stat_summary(fun = "mean",
                                                   #              geom = "line",
                                                   #              aes(group = simd, colour = simd)) +
                                                   facet_wrap(~pre_post_2020) +
                                                   labs(
                                                     x = "\n Quarter",
                                                     y = "Mean Admissions \n",
                                                     title = "Mean Admissions by SIMD & Quarter",
                                                     colour = "SIMD:",
                                                     subtitle = "2017 Q3 to 2022 Q3") +
                                                   theme_light() +
                                                   scale_colour_manual(values = phs_colour_scheme) +
                                                   theme(plot.title = element_text(size = 18, face = "bold"),
                                                         plot.subtitle = element_text(size = 17),
                                                         axis.title.x = element_text(size = 16),
                                                         axis.title.y = element_text(size = 16))
                                                 
                                               }
                                               
                                               else {
                                                 
                                                 admission_deprivation_all %>%
                                                   mutate(simd = factor(simd, levels = c("1", "2", "3", "4", "5"))) %>%
                                                   filter(simd %in% input$deprivation_input) %>% 
                                                   mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>%
                                                   group_by(quarter, simd, pre_post_2020) %>%
                                                   summarise(mean_length_of_stay = mean(average_length_of_stay)) %>%
                                                   ggplot(aes(x = quarter, y = mean_length_of_stay)) +
                                                   # stat_summary(fun.data = "mean_se",
                                                   #              mult = 1,
                                                   #              geom = "errorbar",
                                                   #              width = .1,
                                                   #              aes(colour = simd),
                                                   #              alpha = 0.6) +
                                                   # stat_summary(fun = "mean", geom = "point", size = 4, aes(colour = simd)) +
                                                   geom_point(aes(colour = simd),
                                                              size = 6,
                                                              shape = 17) +
                                                   geom_line(aes(group = simd, colour = simd),
                                                             size = 1) +
                                                   # stat_summary(fun = "mean",
                                                   #              geom = "line",
                                                   #              aes(group = simd, colour = simd)) +
                                                   facet_wrap(~pre_post_2020) +
                                                   labs(
                                                     x = "\n Quarter",
                                                     y = "Mean Length of Stay \n",
                                                     title = "Mean Length of Stay by SIMD & Quarter",
                                                     colour = "SIMD:",
                                                     subtitle = "2017 Q3 to 2022 Q3") +
                                                   theme_light() +
                                                   scale_colour_manual(values = phs_colour_scheme) +
                                                   theme(plot.title = element_text(size = 18, face = "bold"),
                                                         plot.subtitle = element_text(size = 17),
                                                         axis.title.x = element_text(size = 16),
                                                         axis.title.y = element_text(size = 16))
                                                 
                                                 
                                                 
                                               }
                                             })
  
  
  filtered_age_demo <- eventReactive(eventExpr = input$update_demo_age,
                                     valueExpr = {
                                       
                                       if (input$age_plot_type_input == "Mean No. of Admissions") {
                                         
                                         admission_demographics_all %>%
                                           filter(age %in% input$age_input) %>% 
                                           mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>%
                                           group_by(year, quarter, age, pre_post_2020) %>%
                                           summarise(total_admissions_year_quarter = sum(episodes)) %>% 
                                           ungroup() %>%
                                           group_by(quarter, age, pre_post_2020) %>% 
                                           summarise(mean_admissions_quarter = mean(total_admissions_year_quarter)) %>%
                                           ggplot(aes(x = quarter, y = mean_admissions_quarter)) +
                                           geom_line(aes(group = age, colour = age),
                                                     size = 1) +
                                           geom_point(aes(colour = age),
                                                      size = 6,
                                                      shape = 17) +
                                           facet_wrap(~pre_post_2020) +
                                           labs(
                                             x = "\n Quarter",
                                             y = "Mean No. of Admissions \n",
                                             title = "Mean No. of Admissions by Age & Quarter",
                                             colour = "Age:",
                                             subtitle = "2017 Q3 to 2022 Q3") +
                                           theme_light() +
                                           scale_colour_manual(values = phs_colour_scheme) +
                                           theme(plot.title = element_text(size = 18, face = "bold"),
                                                 plot.subtitle = element_text(size = 17),
                                                 axis.title.x = element_text(size = 16),
                                                 axis.title.y = element_text(size = 16))
                                         
                                         
                                       }
                                       
                                       else {
                                         
                                         admission_demographics_all %>%
                                           filter(age %in% input$age_input) %>%
                                           mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020"))) %>% 
                                           group_by(quarter, age, pre_post_2020) %>%
                                           summarise(mean_average_length_of_stay = mean(average_length_of_stay)) %>%
                                           ggplot(aes(x = quarter, y = mean_average_length_of_stay)) +
                                           geom_point(aes(colour = age),
                                                      size = 6,
                                                      shape = 17) +
                                           geom_line(aes(group = age, colour = age),
                                                     size = 1) +
                                           facet_wrap(~pre_post_2020) +
                                           labs(
                                             x = "\n Quarter",
                                             y = "Mean Length of Stay \n",
                                             title = "Mean Length of Stay by Age & Quarter",
                                             colour = "Age:",
                                             subtitle = "2017 Q3 to 2022 Q3") +
                                           theme_light() +
                                           scale_colour_manual(values = phs_colour_scheme) +
                                           theme(plot.title = element_text(size = 18, face = "bold"),
                                                 plot.subtitle = element_text(size = 17),
                                                 axis.title.x = element_text(size = 16),
                                                 axis.title.y = element_text(size = 16))
                                         
                                         
                                         
                                       }
                                     })
  
  
  
  # finds the highest value for total episodes to position labels correctly
  max_total_episodes <- eventReactive(eventExpr = input$update_temporal,
                                      valueExpr = {
                                        clean_hosp_admissions_qyear %>%
                                          filter(location != "A101H") %>% 
                                          filter(admission_type %in% input$admission_input_tempo,
                                                 nhs_health_board %in% input$health_board_input_tempo) %>%
                                          group_by(nhs_health_board, quarter) %>%
                                          summarise(total_episodes = sum(episodes)) %>%
                                          select(total_episodes) %>%
                                          slice_max(total_episodes, n = 1) %>% 
                                          ungroup() %>% 
                                          slice_max(total_episodes, n = 1) %>% 
                                          pull()
                                      })
  
  # finds the highest value for average length of stay to position labels correctly 
  max_length_stay <- eventReactive(eventExpr = input$update_temporal,
                                   valueExpr = {
                                     clean_hosp_admissions_qyear %>%
                                       filter(admission_type %in% input$admission_input_tempo,
                                              nhs_health_board %in% input$health_board_input_tempo) %>%
                                       group_by(quarter) %>%
                                       summarise(average_length_of_stay = mean(average_length_of_stay)) %>% 
                                       select(average_length_of_stay) %>%
                                       slice_max(average_length_of_stay, n = 1) %>% 
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
  
  
  output$geo_output <- renderPlot(
    filtered_geo()
  )
  
  geo_palette <- colorNumeric(
    palette = "Blues",
    domain = locations_occupancy_full$percentage_occupancy)
  
  output$geo_map_output <- renderLeaflet(
    filtered_geo_date()
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
  
  
  filtered_temporal_output <- eventReactive(eventExpr = input$update_temporal,
                                            valueExpr = {
                                              
                                              if (input$temporal_plot_type_input == "Total Number of Admissions") {
                                                
                                                filtered_temporal() %>% 
                                                  summarise(total_episodes = sum(episodes)) %>% 
                                                  ggplot() +
                                                  aes(x = quarter, y = total_episodes) +
                                                  geom_line(aes(group = nhs_health_board, colour = nhs_health_board),
                                                            show.legend = FALSE,
                                                            size = 1) +
                                                  geom_point(aes(colour = nhs_health_board), 
                                                             size = 6,
                                                             shape = 17) +
                                                  #+
                                                  # geom_line(aes(group = quarter)) 
                                                  
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
                                                    x = "\nQuarter",
                                                    y = "Hospital Admissions\n",
                                                    col = "NHS Health Board") +                                           
                                                  theme_light() +
                                                  scale_colour_manual(values = phs_colour_scheme) +
                                                  theme(plot.title = element_text(size = 18, face = "bold"),
                                                        plot.subtitle = element_text(size = 17),
                                                        axis.title.x = element_text(size = 16),
                                                        axis.title.y = element_text(size = 16))
                                                
                                              }
                                              
                                              else {
                                                
                                                filtered_temporal() %>% 
                                                  summarise(average_length_of_stay = mean(average_length_of_stay)) %>% 
                                                  ggplot() +
                                                  aes(x = quarter, y = average_length_of_stay) +
                                                  geom_line(aes(group = nhs_health_board, colour = nhs_health_board),
                                                            show.legend = FALSE,
                                                            size = 1) +
                                                  geom_point(aes(colour = nhs_health_board),
                                                             size = 6,
                                                             shape = 17) +
                                                  theme_bw() +
                                                  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) +
                                                  scale_colour_brewer(palette = "Dark2") +
                                                  geom_label(
                                                    label = "Pre-2020",
                                                    x = 2.5,
                                                    y = max_length_stay(),
                                                    label.padding = unit(0.15, "lines"),
                                                    label.size = 0.15,
                                                    color = "black"
                                                  ) +
                                                  geom_label(
                                                    label = "Post-2020",
                                                    x = 20,
                                                    y = max_length_stay(),
                                                    label.padding = unit(0.15, "lines"),
                                                    label.size = 0.15,
                                                    color = "black"
                                                  ) +
                                                  geom_vline(xintercept = 10.5, linetype = "dashed") +
                                                  
                                                  labs(
                                                    title = "Average Length of Stay by Quarter",
                                                    subtitle = "Quarterly Data from Q3 2017-Q3 2022\n",
                                                    x = "\nQuarter",
                                                    y = "Mean of Average Length of Stay (Days)\n",
                                                    col = "NHS Health Board") +
                                                  theme_light() +
                                                  scale_colour_manual(values = phs_colour_scheme) +
                                                  theme(plot.title = element_text(size = 18, face = "bold"),
                                                        plot.subtitle = element_text(size = 17),
                                                        axis.title.x = element_text(size = 16),
                                                        axis.title.y = element_text(size = 16))
                                              }
                                            })
  
  output$temporal_output <- renderPlot(
    filtered_temporal_output()
  )
  
  output$stats_table_output <- renderDataTable(
    
    colnames = c('Quarter', 'Mean', 'Median', 'Standard Deviation', 'IQR'),
    options = list(dom = 't'),
    
    clean_hosp_admissions_qyear %>% 
      separate(quarter, into = c("year", "quarter"), sep = "Q") %>% 
      filter (year == input$stats_year_input) %>% 
      filter(nhs_health_board != "All of Scotland",
             nhs_health_board != "Non-NHS Provider",
             admission_type == "All Inpatients") %>%
      group_by(quarter) %>%
      summarise(mean_hospital_admissions = mean(episodes),
                median_hospital_admissions = median(episodes),
                sd_hospital_admissions = sd(episodes),
                iqr_hospital_admissions = IQR(episodes))
  )
  
  filtered_speciality <- eventReactive(eventExpr = input$update_speciality,
                                       valueExpr = {
                                         clean_hospital_admissions_speciality %>% 
                                           filter(specialty_name %in% input$speciality_input) %>% 
                                           mutate(pre_post_covid = case_when(
                                             pre_post_covid == "pre" ~ "Pre-2020",
                                             pre_post_covid == "post" ~ "Post-2020",
                                             TRUE ~ ""
                                           ))
                                       })
  
  speciality_output_selection <- eventReactive(eventExpr = input$update_speciality,
                                               valueExpr = {

                                                 filtered_speciality() %>% 
                                                   group_by(quarter, specialty_name, pre_post_covid) %>% 
                                                   drop_na(average_length_of_spell) %>% 
                                                   summarise(avg_length_of_stay = mean(average_length_of_spell)) %>% 
                                                   ggplot(aes(x = quarter, y = avg_length_of_stay, colour = specialty_name)) +
                                                   geom_line() +
                                                   geom_point(aes(colour = specialty_name), size = 6, shape = 17) +
                                                   facet_wrap(~factor(pre_post_covid, level = c("Pre-2020", "Post-2020"))) +
                                                   labs(
                                                     title = "Mean Length of Stay by Quarter for Specialities",
                                                     x = "Quarter",
                                                     y = "Mean of Average Length of Stay (In Days)",
                                                     col = "Speciality Name",
                                                     subtitle = "2017 Q3 to 2022 Q3"
                                                   ) +
                                                   theme_light() +
                                                   scale_colour_manual(values = phs_colour_scheme) +
                                                   theme(plot.title = element_text(size = 18, face = "bold"),
                                                         plot.subtitle = element_text(size = 17),
                                                         axis.title.x = element_text(size = 16),
                                                         axis.title.y = element_text(size = 16))
                                               })
  
  output$speciality_output <-renderPlot(
    speciality_output_selection()
  )
  
  speciality_occupancy_filter <- eventReactive(eventExpr = input$update_speciality_means,
                                               valueExpr = {
                                                 locations_occupancy_full %>% 
                                                   mutate(year = case_when(
                                                     year >= 2020 ~ "Post-2020",
                                                     year < 2020 ~ "Pre-2020",
                                                     TRUE ~ "")) %>% 
                                                   drop_na(percentage_occupancy) %>% 
                                                   filter(specialty_name %in% input$speciality_input_longer) %>% 
                                                   group_by(quarter, specialty_name, year)
                                               })
  
  output$speciality_occupancy <- renderPlot(
    speciality_occupancy_filter() %>% 
      ggplot() +
      aes(x = quarter, y = percentage_occupancy, colour = specialty_name) + 
      stat_summary(fun.data = "mean_cl_normal",
                   geom = "errorbar",
                   width = .1) +
      stat_summary(fun = "mean", geom = "point", size = 4, shape = 17) +
      stat_summary(fun = "mean",
                   geom = "line",
                   color = "black") +
      facet_wrap(~factor(year, level = c("Pre-2020", "Post-2020"))) +
      labs(
        title = "Mean Hospital Admissions by Quarter for Specialities",
        x = "Quarter",
        y = "Hospital Admissions",
        col = "Speciality Name",
        subtitle = "2017 Q3 to 2022 Q3"
      ) + 
      theme_light() +
      scale_colour_manual(values = phs_colour_scheme) +
      theme(plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 17),
            axis.title.x = element_text(size = 16),
            axis.title.y = element_text(size = 16))
  )
  
  
  
  
  
  #filtering hospital_admission_stats_split
  hospital_admission_stats_split_filtered <- eventReactive(eventExpr = input$hospital_admission_stat_update,
                                                           valueExpr = {
                                                             hosp_adm_q_split %>%
                                                               filter(!is.na(episodes)) %>%
                                                               group_by(nhs_health_board, quarter, year) %>%
                                                               filter(nhs_health_board %in% input$hospital_admission_stats_health_board_input,
                                                                      quarter %in% input$hospital_admission_stats_quarter_input,
                                                                      year %in% input$hospital_admission_stats_year_input)
                                                             
                                                           }
  )
  
  output$hospital_admission_stats_split_output <- renderDataTable(
    hospital_admission_stats_split_filtered() %>% 
      summarise(mean_hosp_adm = mean(episodes),
                median_hosp_adm = median(episodes),
                sd_hosp_adm = sd(episodes),
                sem_hosp_adm = sd(episodes)/sqrt(length(episodes)),
                ci_hosp_adm = 2 * sd(episodes))
  )
  
  # filtering length_of_stay stats
  length_of_stay_stats_filtered <- eventReactive(eventExpr = input$length_of_stay_stat_update,
                                                 valueExpr = {
                                                   hosp_adm_q_split %>% 
                                                     filter(!is.na(average_length_of_stay)) %>% 
                                                     group_by(nhs_health_board, quarter, year) %>% 
                                                     filter(nhs_health_board %in% input$length_of_stay_stats_health_board_input,
                                                            quarter %in% input$length_of_stay_stats_quarter_input,
                                                            year %in% input$length_of_stay_stats_year_input)
                                                 })
  
  output$length_of_stay_stats_output <- renderDataTable(
    length_of_stay_stats_filtered() %>% 
      summarise(mean_avlos = mean(average_length_of_stay),
                median_avlos = median(average_length_of_stay),
                sd_hosp_avlos = sd(average_length_of_stay),
                sem_hosp_avlos = sd(average_length_of_stay)/sqrt(length(average_length_of_stay)),
                ci_hosp_avlos = 2 * sd(average_length_of_stay)
      )
  )
  
  beds_stats_filtered <- eventReactive(eventExpr = input$beds_stat_update,
                                       valueExpr = {
                                         beds_data_year_quart %>% 
                                           filter(!is.na(percentage_occupancy)) %>% 
                                           group_by(nhs_health_board, quarter, year) %>% 
                                           filter(nhs_health_board %in% input$beds_stats_health_board_input,
                                                  quarter %in% input$beds_stats_quarter_input,
                                                  year %in% input$beds_stats_year_input)
                                       })
  
  output$beds_stats_output <- renderDataTable(
    beds_stats_filtered() %>% 
      summarise(mean_per_occ = mean(percentage_occupancy),
                median_per_occ = median(percentage_occupancy),
                sd_hosp_per_occ = sd(percentage_occupancy),
                sem_hosp_per_occ = sd(percentage_occupancy)/sqrt(length(percentage_occupancy)),
                ci_hosp_per_occ= 2 * sd(percentage_occupancy),
      ))
}