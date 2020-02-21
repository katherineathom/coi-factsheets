


library(tidyverse)
library(readxl)

# create an index
filepath <- here::here("/data/factsheet_who are-support_data_states_201718_varnames.xlsx")
index <- read_excel(filepath) %>% 
  select(statecode, StateName) %>%
  mutate(StateName = if_else(StateName == "Rhode island","Rhode Island",StateName)) %>%
  filter(StateName != "United States")

# create a data frame with parameters and output file names
runs <- tibble(
  # creates a string with output file names in the form <index>.pdf
  filename = str_c(index$StateName, ".pdf"),             
  # creates a nest list of parameters for each object in the index
  params = map2(.x = index$StateName, 
                .y = index$statecode,
                ~list(state = .x, 
                      state_abbrev = .y)))  

# iterate render() along the tibble of parameters and file names
runs %>%
  select(output_file = filename, params) %>%
  pwalk(rmarkdown::render, input = "simple-factsheet.Rmd", output_dir = "factsheets")


