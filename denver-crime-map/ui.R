## denver-crime, R/Shiny App - ui
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(shiny)

shinyUI(
    fluidPage(titlePanel(paste(TITLE, ": ", minYear, "-", maxYear, sep="")),
              fluidRow(
                  tags$style(type = "text/css",
                  "#map {height: calc(100vh - 150px) !important;}"),
                  leafletOutput("map")))
)
