library(tidyverse)
library(here)
library(janitor)


clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

pre_post_2020_avg_occupancy <- read_csv(here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

age_choice <- admission_demographics_all %>% distinct(age)


admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board)
