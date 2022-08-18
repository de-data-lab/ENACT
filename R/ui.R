library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
bootstrapPage(
    tags$div(
        leafletOutput("map", height = "100vh")
    )
)
