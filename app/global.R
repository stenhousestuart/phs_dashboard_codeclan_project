# Load Libraries

library(tidyverse)
library(here)
library(janitor)
library(leaflet)
library(DT)
library(bslib)
library(shinyWidgets)
library(leafpop)
library(phsstyles)
library(infer)


# Read In Data
clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

pre_post_2020_avg_occupancy <- read_csv(here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

admission_deprivation_all <- read_csv(here("app/clean_data/admission_deprivation_all.csv"))

locations_occupancy_full <- read_csv(here("app/clean_data/locations_occupancy_full.csv"))

clean_hospital_admissions_speciality <- read_csv(here("app/clean_data/clean_hospital_admissions_speciality.csv"))

hosp_adm_q_split <- read_csv(here("app/clean_data/clean_hosp_admissions.csv")) 

beds_data_year_quart <- read_csv(here("app/clean_data/beds_data_year_quart.csv"))

# Set Input Choices
age_choice <- admission_demographics_all %>% 
  distinct(age) %>%
  rename("Age" = age)

admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type) %>% 
  arrange(admission_type) %>% 
  rename("Admission Type" = admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board) %>% 
  arrange(nhs_health_board) %>% 
  rename("NHS Health Board" = nhs_health_board)

deprivation_choice <- admission_deprivation_all %>% 
  distinct(simd) %>% 
  rename("SIMD" = simd)

geo_year_choice <- locations_occupancy_full %>% 
  arrange(year) %>% 
  distinct(year) %>%
  drop_na(year) %>% 
  rename("Year" = year)

geo_quarter_choice <- locations_occupancy_full %>% 
  arrange(quarter) %>% 
  distinct(quarter) %>% 
  drop_na(quarter) %>% 
  rename("Quarter" = quarter)

geo_healthboard_choice <- pre_post_2020_avg_occupancy %>% 
  distinct(nhs_health_board) %>% 
  arrange(nhs_health_board) %>% 
  rename("NHS Health Board" = nhs_health_board)

speciality_choice <- clean_hospital_admissions_speciality %>% 
  drop_na(specialty_name) %>% 
  distinct(specialty_name) %>% 
  arrange(specialty_name) %>% 
  rename("Specialty Name" = specialty_name)

speciality_choice_longer <- locations_occupancy_full %>% 
  distinct(specialty_name) %>% 
  arrange(specialty_name) %>% 
  rename("Specialty Name" = specialty_name)

phs_colour_scheme <- c("#3F3685", "#9B4393", "#0078D4", "#83BB26", "#948DA3",
                                "#1E7F84", "#C73918", "#E1C7DF",
                                "#B3D7F2", "#DAEBBE", "#8073AC", "#853F36", 
                                "#367C85", "#D6604D")


