# Load Libraries

library(tidyverse)
library(here)
library(janitor)
library(leaflet)
library(DT)
library(shinyWidgets)


# Read In Data
clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

pre_post_2020_avg_occupancy <- read_csv(here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

admission_deprivation_all <- read_csv(here("app/clean_data/admission_deprivation_all.csv"))

locations_occupancy_full <- read_csv(here("app/clean_data/locations_occupancy_full.csv"))

clean_hospital_admissions_speciality <- read_csv(here("app/clean_data/clean_hospital_admissions_speciality.csv"))

# Set Input Choices
age_choice <- admission_demographics_all %>% 
  distinct(age)

admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board)

deprivation_choice <- admission_deprivation_all %>% 
  distinct(simd)

geo_year_choice <- locations_occupancy_full %>% 
  arrange(year) %>% 
  distinct(year) %>%
  drop_na(year)
  

geo_quarter_choice <- locations_occupancy_full %>% 
  arrange(quarter) %>% 
  distinct(quarter) %>% 
  drop_na(quarter)

geo_healthboard_choice <- pre_post_2020_avg_occupancy %>% 
  distinct(nhs_health_board)

speciality_choice <- clean_hospital_admissions_speciality %>% 
  distinct(specialty_name)
