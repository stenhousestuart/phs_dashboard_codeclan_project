library(tidyverse)
library(here)
library(janitor)

 test_data <- read_csv(here("data/hospital_admissions_hb_agesex_20230504.csv"))

 test_data_year <- test_data %>%
   mutate(date = ymd(WeekEnding), .after = WeekEnding) %>%
   mutate(year = year(date),.after = date)

 year_choice <- test_data_year %>%
   distinct(year)

 health_board_choice <- test_data_year %>%
   distinct(HB) %>%
   drop_na()

 age_choice <- test_data_year %>%
   distinct(AgeGroup)

# This will be moved to the cleaning script - Will only contain calls for clean data in final  
admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

age_choices <- admission_demographics_all %>% distinct(age)