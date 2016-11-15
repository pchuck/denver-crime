## denver-crime, R/Shiny App - server
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)

# main shiny server function
function(input, output, session) {
    # render the main map
    output$map <- renderLeaflet({
        createCrimeMap_CatOverlay(subset, groups, pal,
                                  minYear, OPACITY, ZOOM_LEVEL) %>%
            # show by default a couple of groups..
            showGroup("murder") %>%
            showGroup("arson")
    })
}
