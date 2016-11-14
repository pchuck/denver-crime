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
        # add the background
        base <- leaflet(subset) %>%
        setView(lng=mean(subset$GEO_LON),
                lat=mean(subset$GEO_LAT), zoom=12) %>%
        addProviderTiles(MAP_TYPE, options = providerTileOptions(noWrap = TRUE))

        # add crime markers
        marked <- base %>%
        addCircleMarkers(lng=~GEO_LON, lat=~GEO_LAT,
                         color=~pal(OFFENSE_CATEGORY_ID),
                         radius=~OCCURRENCE_YEAR - minYear + 1,
                         group=~OFFENSE_CATEGORY_ID,
                         popup=paste(subset$FIRST_OCCURRENCE_DATE,
                                     subset$NEIGHBORHOOD_ID,
                                     subset$INCIDENT_ADDRESS,
                                     subset$OFFENSE_CATEGORY_ID, 
                                     subset$OFFENSE_TYPE_ID,
                                     sep="<br/>"), 
                         fillOpacity=0.8) %>%
        addLegend(pal=pal, values=groups) %>%
        addLayersControl(overlayGroups=groups,
                         options=layersControlOptions(collapsed=FALSE),
                         position="bottomright") %>%
        hideGroup(groups)

        # display the map
        marked
    })
}
