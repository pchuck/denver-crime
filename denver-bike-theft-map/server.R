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
        createCrimeMap_YearOverlay(bikesub, groups, pal,
                                   RADIUS, OPACITY, ZOOM_LEVEL)
    })
    output$hourPlot <- renderPlot({
        ggplot(data=bikesub, aes(OCCURRENCE_HOUR)) +
        geom_histogram(breaks=seq(0, 24, by=1), color="black", fill="gray") + 
        labs(x="Hour of Day", y="Number of Thefts")
    })
    output$dayPlot <- renderPlot({
        ggplot(data=bikesub, aes(factor(OCCURRENCE_DAY))) +
        geom_bar(color="black", fill="gray") + 
        labs(x="Day of Week", y="Number of Thefts") + 
        scale_x_discrete(labels=c("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"))
    })
    output$monthPlot <- renderPlot({
        ggplot(data=bikesub, aes(factor(OCCURRENCE_MONTH))) +
        geom_bar(color="black", fill="gray") +
        labs(x="Month of Year", y="Number of Thefts") +
        scale_x_discrete(labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
    })
    output$yearPlot <- renderPlot({ # use 'biketheft' set here for yearly stats
        ggplot(data=biketheft, aes(factor(OCCURRENCE_YEAR))) +
        geom_bar(color="black", fill="gray") +
        labs(x="Year", y="Number of Thefts")
    })
    output$neighborhoodPlot <- renderPlot({
        ggplot(bikesub) + geom_bar(aes(x=NEIGHBORHOOD_ID, fill=DISTRICT_ID)) +
            scale_x_discrete(limits = (bikesub %>%
                                       count(NEIGHBORHOOD_ID) %>%
                                       arrange(n))$NEIGHBORHOOD_ID) +
        coord_flip() +
        labs(title="Thefts by Neighborhood and District",
             x="Neighborhood", y="Count", fill="District")
    })
}

