## denver-crime, R/Shiny App - ui
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)

shinyUI(
    fluidPage(titlePanel(paste(TITLE, ": ", minYear, "-", maxYear, sep="")),
        fluidRow(leafletOutput("map")))
)
