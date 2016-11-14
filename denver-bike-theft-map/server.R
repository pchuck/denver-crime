## denver-bike-theft-map, R/Shiny App - server
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)
library(dplyr)
library(ggplot2)

# main shiny server function
function(input, output, session) {
    # render the main map
    output$map <- renderLeaflet({
        # add the background
        base <- leaflet(bikesub) %>%
            setView(lng=mean(bikesub$GEO_LON), lat=mean(bikesub$GEO_LAT),
                    zoom=12) %>%
            addTiles(group="OSM") %>%
            addProviderTiles("CartoDB.DarkMatter", group="Dark") %>%
            addProviderTiles("Thunderforest.OpenCycleMap", group="Cycle") %>%
            addProviderTiles(MAP_TYPE, group="Toner")

        # add crime markers and display the map
        marked <- base %>%
            addCircleMarkers(lng=~GEO_LON, lat=~GEO_LAT,
                             color=~pal(OCCURRENCE_YEAR_STRING),
                             radius=RADIUS,
                             group=~OCCURRENCE_YEAR_STRING,
                             popup=paste(bikesub$FIRST_OCCURRENCE_DATE,
                                         bikesub$NEIGHBORHOOD_ID,
                                         bikesub$INCIDENT_ADDRESS,
                                         sep="<br/>"), 
                             fillOpacity=OPACITY) %>%
            addLegend(pal=pal, values=groups) %>%
            addLayersControl(overlayGroups=groups,
                             baseGroups=c("Dark", "Cycle", "Toner", "OSM"), 
                             options=layersControlOptions(collapsed=TRUE),
                             position="bottomright")

        marked
    })
#    output$table <- renderDataTable({
#        bikesub %>% count(OCCURRENCE_YEAR) %>% arrange(desc(n))
#    })
    output$hourPlot <- renderPlot({
        ggplot(data=bikesub, aes(bikesub$OCCURRENCE_HOUR)) +
        geom_histogram(breaks=seq(0, 24, by=1), color="black",
        fill="gray", alpha=0.4) + 
        labs(x="Hour of Day", y="Number of Thefts")
    })
    output$dayPlot <- renderPlot({
        ggplot(data=bikesub, aes(bikesub$OCCURRENCE_DAY)) +
        geom_histogram(breaks=seq(0, 7, by=1), color="black", 
        fill="gray", alpha=0.4) + 
        labs(x="Day of Week (Mon-Sun)", y="Number of Thefts")
    })
    output$monthPlot <- renderPlot({
        ggplot(data=bikesub, aes(bikesub$OCCURRENCE_MONTH)) +
        geom_histogram(breaks=seq(0, 13, by=1), color="black",
        fill="gray", alpha=0.4) + 
        labs(x="Month of Year (Jan-Dec)", y="Number of Thefts")
    })
    
}
