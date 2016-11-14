## denver-bike-theft-map, R/Shiny App - ui
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)

shinyUI(
    fluidPage(
        titlePanel(paste(TITLE, ": ", minYear, "-", maxYear, sep="")),
        tabsetPanel(
            tabPanel("Map",
                     tags$style(type = "text/css",
                     "#map {height: calc(100vh - 80px) !important;}"),
                     leafletOutput("map")),
            tabPanel("Neighborhood",
                     tags$style(type = "text/css",
                     "#neighborhoodPlot {height: calc(100vh - 80px) !important;}"),
                     plotOutput('neighborhoodPlot')),
            tabPanel("Year", plotOutput('yearPlot')),
            tabPanel("Month", plotOutput('monthPlot')),
            tabPanel("Day", plotOutput('dayPlot')),
            tabPanel("Hour", plotOutput('hourPlot'))
        )
    )
)
