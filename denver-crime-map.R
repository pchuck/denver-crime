## cobble together a static leaflet map
## for a dynamic version of the same using shiny, see ./denver-crime-map/
##
library("leaflet")
library("htmlwidgets")

source(file="denver-crime-map/global.R")
map <- createCrimeMap_CatOverlay(subset, groups, pal,
                                 minYear, OPACITY, ZOOM_LEVEL)

# show by default a couple of groups..
initial <- map %>%
    showGroup("murder") %>%
    showGroup("arson")

saveWidget(initial, 'denver-crime-map.html', selfcontained=TRUE)
