library(tidyverse)
library(here)
library(janitor)

 test_data <- read_csv(here("data/hospital_admissions_hb_agesex_20230504.csv"))

 test_data_year <- test_data %>%
   mutate(date = ymd(WeekEnding), .after = WeekEnding) %>%
   mutate(year = year(date),.after = date)

 year_choice <- test_data_year %>%
   distinct(year)

clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

pre_post_2020_avg_occupancy <- read_csv(here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

age_choices <- admission_demographics_all %>% distinct(age)



admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board)
