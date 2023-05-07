library(tidyverse)

test_data <- read_csv("test_data/hospital_admissions_hb_agesex_20230504.csv")

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
