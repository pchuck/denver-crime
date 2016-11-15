## cobble together a static leaflet map
## for a dynamic version of the same using shiny, see ./denver-bike-theft-map/
##
library("leaflet")
library("htmlwidgets")

source(file="denver-bike-theft-map/global.R")
map <- createCrimeMap_YearOverlay(bikesub, groups, pal,
                                  RADIUS, OPACITY, ZOOM_LEVEL)
saveWidget(map, 'denver-bike-theft-map.html', selfcontained=TRUE)
