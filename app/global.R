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

  
admission_demographics <- read_csv(here("data/inpatient_and_daycase_by_nhs_board_of_treatment_age_and_sex.csv"))

admission_demographics_clean <- admission_demographics %>% clean_names()

admission_demographics_clean <- admission_demographics_clean %>% 
  select(quarter, hb, location, admission_type, sex, age, episodes, 
         length_of_episode, average_length_of_episode, stays,
         length_of_stay, average_length_of_stay)

admission_demographics_clean <- admission_demographics_clean %>% 
  mutate(hb = ifelse(hb == "S08000015", "Ayrshire and Arran", hb),
         hb = ifelse(hb == "S08000016", "Borders", hb),
         hb = ifelse(hb == "S08000017", "Dumfries and Galloway", hb),
         hb = ifelse(hb == "S08000018", "Fife", hb),
         hb = ifelse(hb == "S08000019", "Forth Valley", hb),
         hb = ifelse(hb == "S08000020", "Grampian", hb),
         hb = ifelse(hb == "S08000021", "Greater Glasgow and Clyde", hb),
         hb = ifelse(hb == "S08000022", "Highland", hb),
         hb = ifelse(hb == "S08000023", "Lanarkshire", hb),
         hb = ifelse(hb == "S08000024", "Lothian", hb),
         hb = ifelse(hb == "S08000025", "Orkney", hb),
         hb = ifelse(hb == "S08000026", "Shetland", hb),
         hb = ifelse(hb == "S08000027", "Tayside", hb),
         hb = ifelse(hb == "S08000028", "Western Isles", hb),
         hb = ifelse(hb == "S08000029", "Fife", hb),
         hb = ifelse(hb == "S08000030", "Tayside", hb),
         hb = ifelse(hb == "S08000031", "Greater Glasgow and Clyde", hb),
         hb = ifelse(hb == "S08000032", "Lanarkshire", hb),
         hb = ifelse(hb == "S92000003", "All of Scotland", hb),
         hb = ifelse(hb == "S27000001", "Non-NHS Provider", hb),
         hb = ifelse(hb == "SB0801", "The Golden Jubilee National Hospital", hb),
         hb = ifelse(hb == "SN0811", "National Facility NHS Louisa Jordan", hb)
  ) %>%
  rename(nhs_health_board = hb)

admission_demographics_clean <- admission_demographics_clean %>% 
  separate(quarter,into = c("year", "quarter"), sep = "Q" )

admission_demographics_clean <- admission_demographics_clean %>% 
  mutate(age = str_remove(age, "years"),
         age = str_remove(age, "and over"),
         age = str_trim(age),
         age = recode(age, "90" = "90 Plus"))

admission_demographics_clean <- admission_demographics_clean %>% 
  mutate(pre_post_2020 = ifelse(year %in% c("2017", "2018", "2019"),
                                "pre 2020", "post 2020"),
         pre_post_2020 = factor(pre_post_2020, 
                                levels = c("pre 2020", 
                                           "post 2020")))

admission_demographics_all <- admission_demographics_clean %>%
  filter(nhs_health_board == "All of Scotland",
         admission_type == "All Inpatients")

age_choices <- admission_demographics_all %>% distinct(age)