# reading in libraries

library(tidyverse) #SS
library(janitor) #SS
library(ggpubr) # DC
library(broom) # DC
library(AICcmodavg) # DC
library(here) # KA
library(leaflet) #KA

# Reading in data files

hospital_admissions_speciality <- read_csv(here("data/inpatient_and_daycase_by_nhs_board_of_treatment_and_specialty.csv"))

inpatient_data <- read_csv(here("data/inpatient_and_daycase_by_nhs_board_of_treatment.csv"))

admission_demographics <- read_csv(here("data/inpatient_and_daycase_by_nhs_board_of_treatment_age_and_sex.csv"))

admission_deprivation <- read_csv(here("data/activity_by_board_of_treatment_and_deprivation.csv"))

beds_data <- read_csv(here("data/beds_by_nhs_board_of_treatment_and_specialty.csv"))

hospital_locations <- read_csv(here("data/current_hospital_locations.csv"))

hospital_long_lat <- read_csv(here("data/hospital_long_lat.csv"), col_names = FALSE)


# David's cleaning starts here
clean_hosp_admissions <- inpatient_data %>% 
  clean_names() %>% 
  select(- quarter_qf, - hbqf, -location_qf, -admission_type_qf, 
         -average_length_of_episode_qf, -average_length_of_stay_qf, -location_qf,
         -admission_type_qf) %>% 
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
         hb = ifelse(hb == "RA2701", "No Fixed Abode", hb),
         hb = ifelse(hb == "RA2702", "Rest of the UK", hb),
         hb = ifelse(hb == "RA2703", "Outside the UK", hb),
         hb = ifelse(hb == "RA2704", "Unknown Residency", hb),
         hb = ifelse(hb == "S27000001", "Non-NHS Provider", hb),
         hb = ifelse(hb == "SB0801", "The Golden Jubilee National Hospital", hb),
         hb = ifelse(hb == "SN0811", "National Facility NHS Louisa Jordan", hb)
  ) %>%
  rename(nhs_health_board = hb) %>% 
  separate(quarter,into = c("year", "quarter"), sep = "Q" ) %>% 
  mutate(pre_post_covid = ifelse(year %in% c("2017", "2018", "2019"), "pre", "post")) 


# quarter and year combined data cleaning

clean_hosp_admissions_qyear <- inpatient_data %>% 
  clean_names() %>% 
  select(- quarter_qf, - hbqf, -location_qf, -admission_type_qf, 
         -average_length_of_episode_qf, -average_length_of_stay_qf, -location_qf,
         -admission_type_qf) %>% 
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
         hb = ifelse(hb == "RA2701", "No Fixed Abode", hb),
         hb = ifelse(hb == "RA2702", "Rest of the UK", hb),
         hb = ifelse(hb == "RA2703", "Outside the UK", hb),
         hb = ifelse(hb == "RA2704", "Unknown Residency", hb),
         hb = ifelse(hb == "S27000001", "Non-NHS Provider", hb),
         hb = ifelse(hb == "SB0801", "The Golden Jubilee National Hospital", hb),
         hb = ifelse(hb == "SN0811", "National Facility NHS Louisa Jordan", hb),
  ) %>%
  rename(nhs_health_board = hb) 


# speciality_cleaning

clean_hospital_admissions_speciality <- hospital_admissions_speciality %>% 
  clean_names() %>% 
  select(- quarter_qf, - hbqf, -location_qf, -admission_type_qf, 
         -average_length_of_episode_qf) %>% 
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
         hb = ifelse(hb == "RA2701", "No Fixed Abode", hb),
         hb = ifelse(hb == "RA2702", "Rest of the UK", hb),
         hb = ifelse(hb == "RA2703", "Outside the UK", hb),
         hb = ifelse(hb == "RA2704", "Unknown Residency", hb)
  ) %>%
  rename(nhs_health_board = hb) %>% 
  separate(quarter,into = c("year", "quarter"), sep = "Q" ) %>% 
  mutate(pre_post_covid = ifelse(year %in% c("2017", "2018", "2019"), "pre", "post")) 



#stuarts cleaning starts here

admission_deprivation_clean <- admission_deprivation %>% clean_names()

admission_deprivation_clean <- admission_deprivation_clean %>% 
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

# demographics data cleaning

admission_demographics_clean <- admission_demographics %>% clean_names()

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
  mutate(pre_post_2020 = ifelse(year %in% c("2017", "2018", "2019"), "pre 2020", "post 2020")) %>% 
  mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020")))

admission_demographics_clean <- admission_demographics_clean %>% 
  mutate(age = str_remove(age, "years"),
         age = str_remove(age, "and over"),
         age = str_trim(age),
         age = recode(age, "90" = "90 Plus"))

admission_demographics_all <- admission_demographics_clean %>%
  filter(nhs_health_board == "All of Scotland",
         admission_type == "All Inpatients")

# deprivation data cleaning
admission_deprivation_clean <- admission_deprivation_clean %>% 
  separate(quarter,into = c("year", "quarter"), sep = "Q" )

admission_deprivation_clean <- admission_deprivation_clean %>%
  drop_na(simd)

admission_deprivation_clean <- admission_deprivation_clean %>%
  mutate(simd = factor(simd, levels = c(1, 2, 3, 4, 5)))

admission_deprivation_clean <- admission_deprivation_clean %>% 
  mutate(pre_post_2020 = ifelse(year %in% c("2017", "2018", "2019"), "pre 2020", "post 2020")) %>% 
  mutate(pre_post_2020 = factor(pre_post_2020, levels = c("pre 2020", "post 2020")))

admission_deprivation_all <- admission_deprivation_clean %>%
  filter(nhs_health_board == "All of Scotland",
         admission_type == "All Inpatients")

# Kirsty's cleaning starts here

# 1. clean occupancy data 

beds_data <- beds_data %>% 
  clean_names() %>% 
  # change health board codes to health board names
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
         hb = ifelse(hb == "RA2702", "Rest of UK (Outside of Scotland)", hb),
         hb = ifelse(hb == "RA2703", "Outside the UK", hb),
         hb = ifelse(hb == "RA2704", "Unknown Residency", hb),
         hb = ifelse(hb == "S27000001", "Non-NHS Provider", hb),
         hb = ifelse(hb == "SB0801", "Greater Glasgow and Clyde", hb),
         hb = ifelse(hb == "SN0811", "Greater Glasgow and Clyde", hb),
         hb = ifelse(hb == "Golden Jubilee National Hospital", "Greater Glasgow and Clyde", hb),
         hb = ifelse(hb == "The Golden Jubilee National Hospital", "Greater Glasgow and Clyde", hb),
         ) %>%
  rename(nhs_health_board = hb) %>% 
# change location codes to location names
  mutate(location = ifelse(location == "A210H", "University Hospital Ayr", location),
         location = ifelse(location == "A111H", "University Hospital Crosshouse", location),
         location = ifelse(location == "B120H", "Borders General Hospital", location),
         location = ifelse(location == "Y146H", "Dumfries & Galloway Royal Infirmary", location),
         location = ifelse(location == "Y144H", "Galloway Community Hospital", location),
         location = ifelse(location == "F805H", "Queen Margaret Hospital", location),
         location = ifelse(location == "F704H", "Victoria Hospital", location),
         location = ifelse(location == "N101H", "Aberdeen Royal Infirmary", location),
         location = ifelse(location == "N411H", "Dr Gray's Hospital", location),
         location = ifelse(location == "G107H", "Glasgow Royal Infirmary", location),
         location = ifelse(location == "C313H", "Inverclyde Royal Hospital", location),
         location = ifelse(location == "G306H", "New Victoria Hospital", location),
         location = ifelse(location == "G405H", "Queen Elizabeth University Hospital", location),
         location = ifelse(location == "C418H", "Royal Alexandra Hospital", location),
         location = ifelse(location == "G207H", "Stobhill Hospital", location),
         location = ifelse(location == "C206H", "Vale of Leven General Hospital", location),
         location = ifelse(location == "G516H", "Gartnavel Royal Hospital", location),
         location = ifelse(location == "H212H", "Belford Hospital", location),
         location = ifelse(location == "H103H", "Caithness General Hospital", location),
         location = ifelse(location == "C121H", "Lorn & Islands Hospital", location),
         location = ifelse(location == "H202H", "Raigmore Hospital", location),
         location = ifelse(location == "L302H", "University Hospital Hairmyres", location),
         location = ifelse(location == "L106H", "University Hospital Monklands", location),
         location = ifelse(location == "L308H", "University Hospital Wishaw", location),
         location = ifelse(location == "S314H", "Royal Infirmary of Edinburgh at Little France", location),
         location = ifelse(location == "S308H", "St John's Hospital", location),
         location = ifelse(location == "S116H", "Western General Hospital", location),
         location = ifelse(location == "R103H", "The Balfour", location),
         location = ifelse(location == "T101H", "Ninewells Hospital", location),
         location = ifelse(location == "T202H", "Perth Royal Infirmary", location),
         location = ifelse(location == "T312H", "Stracathro Hospital", location),
         location = ifelse(location == "W107H", "Western Isles Hospital", location),
         location = ifelse(location == "A101H", "Arran War Memorial Hospital", location),
         location = ifelse(location == "D102H", "Golden Jubilee National Hospital", location),
         location = ifelse(location == "A101H", "Arran War Memorial Hospital", location),
         location = ifelse(location == "V217H", "Forth Valley Royal Hospital", location),
         location = ifelse(location == "Z102H", "Gilbert Bain Hospital", location),
         location = ifelse(location == "SB0801", "Golden Jubilee National Hospital", location),
         location = ifelse(location == "SN0811", "National Facility NHS Louisa Jordan", location),
         location = ifelse(location == "G101Z", "National Facility NHS Louisa Jordan", location),
         ) %>% # remove locations that are actually health board codes
  filter(!(location %in% c("S08000015", "S08000016", "S08000017", "S08000029", 
                           "S08000019", "S08000020", "S08000031", "S08000022", 
                           "S08000032", "S08000024", "S08000025", "S08000026", 
                           "S08000030", "S08000028", "S27000001", "S92000003")))

 # separate date column into year & quarter, 

beds_data_year_quart <- beds_data %>% 
  drop_na(percentage_occupancy) %>% 
  separate(quarter, c("year", "quarter"),"Q", remove = FALSE) %>% 
  mutate(quarter = paste0("Q", quarter)) %>% 
  mutate(three_yr_avg = ifelse(year %in% c(2017:2019), "17_19_avg", year))

# find average occupancy before covid (per quarter)
three_year_avg_occupancy <- beds_data_year_quart %>% 
  filter(three_yr_avg == "17_19_avg") %>% # data set only goes 17-19
  group_by(nhs_health_board,year, quarter) %>% 
  summarise(percentage_occupancy = mean(percentage_occupancy)) %>% 
  group_by(nhs_health_board, quarter) %>% # lump all years together and just focus on quarters
  summarise(percentage_occupancy = mean(percentage_occupancy)) %>% 
  mutate(year = "pre 2020")


# find average occupancy after covid (per quarter)
avg_occupancy_after_2020 <- beds_data_year_quart %>% 
  filter(three_yr_avg != "17_19_avg") %>% # data set only goes 17-19
  group_by(nhs_health_board,year, quarter) %>% 
  summarise(percentage_occupancy = mean(percentage_occupancy)) %>% 
  group_by(nhs_health_board, quarter) %>% # lump all years together and just focus on quarters
  summarise(percentage_occupancy = mean(percentage_occupancy)) %>% 
  mutate(year = "post 2020")

# find average occupancy after covid (per quarter per year)
full_avg_occupancy_post_2020 <- beds_data_year_quart %>% 
  filter(three_yr_avg != "17_19_avg") %>% 
  group_by(nhs_health_board,year, quarter) %>% 
  summarise(percentage_occupancy = mean(percentage_occupancy)) 

# join average occupancy tables for pre and post 2020, write this to CSV
pre_post_2020_avg_occupancy <- rbind(three_year_avg_occupancy, avg_occupancy_after_2020) %>% 
  mutate(year = factor(year, levels = c("pre 2020", "post 2020")))

# 2. clean location data

# XY coordinates given by NHS:
hospital_locations <- hospital_locations %>%  clean_names() %>%  drop_na(x_coordinate)
# drops 1 location as don't have coordinate - fill in later? (Royal Hospital for Children and Young People S320H)

# Long/Lat coordinates calculated from XY using https://gridreferencefinder.com/batchConvert/batchConvert.php
hospital_long_lat <- hospital_long_lat %>% 
  rename("x_coordinate" = X1,
         "y_coordinate" = X2,
         "grid_reference" = X3,
         "latitude" = X4,
         "longitude" = X5)

# join long lat back with original XY table 
hospital_locations_all <- left_join(hospital_locations, hospital_long_lat, by = "x_coordinate") %>% 
  select(-c(y_coordinate.y, grid_reference)) %>% 
  rename("y_coordinate" = y_coordinate.x)

# Join occupancy data with full location data, save to new variable, write this to CSV
locations_occupancy_full <-
  hospital_locations_all %>% 
  rename(location_code = location, location = location_name) %>% 
  full_join(beds_data_year_quart, hospital_locations_all, by = "location")


locations_occupancy_full_combine_year_quarter <- hospital_locations_all %>%
  rename(location_code = location, location = location_name) %>% 
  inner_join(beds_data_year_quart, hospital_locations_all, by = "location") %>% 
  unite(year_quarter, c("year","quarter"), sep = "")
  

# writing CSV files

write_csv(clean_hosp_admissions, here("app/clean_data/clean_hosp_admissions.csv"))

write_csv(clean_hosp_admissions_qyear, here("app/clean_data/clean_hosp_admissions_qyear.csv"))

write_csv(clean_hospital_admissions_speciality, here("app/clean_data/clean_hospital_admissions_speciality.csv"))

write_csv(admission_deprivation_all, here("app/clean_data/admission_deprivation_all.csv"))

write_csv(admission_demographics_all, here("app/clean_data/admission_demographics_all.csv"))

write_csv(pre_post_2020_avg_occupancy, here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

write_csv(locations_occupancy_full, here("app/clean_data/locations_occupancy_full.csv"))

write_csv(beds_data_year_quart, here("app/clean_data/beds_data_year_quart.csv"))
