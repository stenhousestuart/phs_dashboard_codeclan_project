library(tidyverse)
library(here)
library(janitor)

 test_data <- read_csv(here("data/hospital_admissions_hb_agesex_20230504.csv"))

 test_data_year <- test_data %>%
   mutate(date = ymd(WeekEnding), .after = WeekEnding) %>%
   mutate(year = year(date),.after = date)

 year_choice <- test_data_year %>%
   distinct(year)


admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

age_choices <- admission_demographics_all %>% distinct(age)

clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board)
# 
# max_total_episodes <- clean_hosp_admissions_qyear %>% 
#   # filter(admission_type %in% input$admission_input_tempo,
#   #        nhs_health_board %in% input$health_board_input_tempo) %>%
#   group_by(quarter) %>% 
#   summarise(total_episodes = sum(episodes)) %>% 
#   max(total_episodes) %>% 
#   pull()