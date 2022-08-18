# Get the CB
get_de_shape <- function(geometry = TRUE){
    CB_DE_URL <- "https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_10_tract_500k.zip"
    temp <- tempfile()
    temp_dir <- tempdir()
    download.file(CB_DE_URL, destfile = temp)
    unzip(temp, exdir = temp_dir)
    de_shape <- st_read(temp_dir)
    if(geometry == FALSE) de_shape <- de_shape %>% st_drop_geometry() %>% as_tibble()
    return(de_shape)
}
