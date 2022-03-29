library(tidyverse)
library(here)
library(sf)

# Read the list of GEOIDSs and join it with tigris
DE_tract_list_20 <- read_csv(here("data/raw/DE_tract_list_20.csv"))

# Convert the GEOID to string for joining later
DE_tract_list_20 <- DE_tract_list_20 %>% 
    mutate(GEOID_20 = as.character(GEOID_20))

# Drop the polygon
DE_tracts <- tigris::tracts(state = "DE", year = 2020)  %>%
    st_drop_geometry()

# Join the input csv file and tracts file
joined_df <- DE_tract_list_20 %>%
    left_join(DE_tracts, by = c("GEOID_20" = "GEOID")) 

# Write out the CSV file
write_csv(joined_df, here("data/processed/DE_tract_list_20_tigris.csv"))
