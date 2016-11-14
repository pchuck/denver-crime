## denver-bike-theft-map, R/Shiny App - ui
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)

shinyUI(
    fluidPage(
        titlePanel(paste(TITLE, ": ", minYear, "-", maxYear, sep="")),
        sidebarLayout(
            sidebarPanel(
                tabsetPanel(
                    tabPanel("Hour", plotOutput('hourPlot')),
                    tabPanel("Day", plotOutput('dayPlot')),
                    tabPanel("Month", plotOutput('monthPlot'))
                )
            ),
            mainPanel(
                tabsetPanel(
                    tabPanel("Map", leafletOutput("map"))
                )
            )
        )
    )
)
