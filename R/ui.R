library(shiny)
library(leaflet)

bootstrapPage(
    tags$div("Everyone Names All Census Tracts",
             style = "z-index: 50; position: absolute; background: white; left: 5rem; top: 1rem; padding: 2rem;
                      font-weight: bold; border: solid 1px gray; border-radius: 5px"),
    tags$div(
        tags$a(
            icon("github"),
            href = "https://github.com/de-data-lab/ENACT",
            target = "_blank"
        ),
        style = "z-index: 50; position: absolute; top: 1rem; right: 2rem;
                 border-radius: 50%; background: white; width: 5rem; height: 5rem;
                 text-align: center; padding: 0.25rem 0; font-size: 3rem; border: solid 1px gray"
    ),
    tags$div(
        leafletOutput("map", height = "100vh")
    ),
)
