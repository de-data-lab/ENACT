library(shiny)
library(leaflet)
library(sf)
library(here)
library(tidyverse)

source(here("R/utils.R"))

# Default anchor for the leaflet view
default_lat <- 39.1824
default_lng <- -75.4

# Get DE shape
de_shape <- get_de_shape()

# Load data 
tracts <- read_csv(here("data/raw/DE_tracts_codes.csv"))
tracts <- tracts %>% 
    select(GEOID_20, `Area Name`, `Secondary Review`)
tracts <- tracts %>% 
    rename("area_name" = `Area Name`,
           "area_name2" = `Secondary Review`) %>% 
    mutate(GEOID = as.character(GEOID_20))

# Function to create leaflet labels
render_label <- function(census_tract, GEOID, name1, name2){
    # Only render the secondary suggested name when it's present
    alternate_name_div <- NULL
    if(!is.na(name2)) alternate_name_div <- div("Or,", name2,
                                        style = "color: grey; font-size: 1.5rem")
    
    withTags(
        div(style = "width: 20rem; white-space: normal; overflow-wrap: break-word",
            div(name1,
                style = "font-size: 1.5rem; font-weight: bold"),
            alternate_name_div,
            div("Census Tract", census_tract),
            div("GEOID", GEOID),
            div(a("View on Census Reporter",
                  href = paste0("https://censusreporter.org/profiles/14000US", GEOID),
                  target = "_blank"))
        )
    ) %>% htmltools::doRenderTags()
}

# Combine with DE-shape
de_map_data <- de_shape %>% 
    left_join(tracts, by = "GEOID")

# Add labels
de_map_data <- de_map_data %>% 
    rowwise() %>%
    mutate(leaflet_label = render_label(NAME, GEOID, area_name, area_name2)) %>% 
    ungroup()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$map <- renderLeaflet({
        de_map_data %>%
        leaflet() %>% 
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(lng = default_lng,
                    lat = default_lat,
                    zoom = 9) %>%
            addPolygons(highlight = highlightOptions(fillOpacity = 0.8, weight = 1),
                        label = ~leaflet_label,
                        popup = ~leaflet_label)
    })
})
