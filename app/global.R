library(tidyverse)
library(here)
library(janitor)
library(shinyWidgets)


clean_hosp_admissions_qyear <- read_csv(here("app/clean_data/clean_hosp_admissions_qyear.csv"))

admission_demographics_all <- read_csv(here("app/clean_data/admission_demographics_all.csv"))

pre_post_2020_avg_occupancy <- read_csv(here("app/clean_data/pre_post_2020_avg_occupancy.csv"))

age_choice <- admission_demographics_all %>% distinct(age)


admission_choice <- clean_hosp_admissions_qyear %>% 
  distinct(admission_type)

health_board_choice <- clean_hosp_admissions_qyear %>% 
  distinct(nhs_health_board)

# this is an attempt to get either or both plots to display based on the "temporal_checkbox_input"
# as seen in ui.R
temporal_checkbox_tabs <- tabsetPanel(
  id = "temporal_graphs",
  type = "hidden", 
  
  tabPanelBody(
    
    "Total Admissions",
    fluidRow(
    plotOutput("temporal_out_total_episodes")
    )
  ),
  
  tabPanelBody(
    "Average Length of Stay",
    fluidRow(
           plotOutput("temporal_out_length_stay")
    )
  )
)

# on pressing update_temporal, check which checkboxes are selected t
# eventReactive(eventExpr = input$update_temporal,
#               valueExpr = {
#                 temporal_checkbox_tabs
#               })
              