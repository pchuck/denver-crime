## denver-bike-theft-map, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(RColorBrewer)
library(leaflet)
source(file="functions.R")

# various constants
TITLE <- "Denver Bike Thefts"
BIKE_LOCAL <- "data/denver_bike_theft.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data
BAD_LON <- -100 # consider datapoints outside this longitude invalid
COLOR <- "red"
RADIUS <- 5
OPACITY <- 0.5
ZOOM_LEVEL = 14

# read and transform the Denver open data crime dataset
biketheft <- readDenverCrime(BIKE_LOCAL)

# convert the date fields
biketheft$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(biketheft$FIRST_OCCURRENCE_DATE, format=DATE_FORMAT)

# new columns with hour, day, month and year components
biketheft$OCCURRENCE_HOUR <-
    as.numeric(format(biketheft$FIRST_OCCURRENCE_DATE, "%H")) +
    as.numeric(format(biketheft$FIRST_OCCURRENCE_DATE, "%M")) / 60
biketheft$OCCURRENCE_DAY <- 
    as.numeric(format(biketheft$FIRST_OCCURRENCE_DATE, "%u"))
biketheft$OCCURRENCE_MONTH <- 
    as.numeric(format(biketheft$FIRST_OCCURRENCE_DATE, "%m"))
biketheft$OCCURRENCE_YEAR <- 
    as.numeric(format(biketheft$FIRST_OCCURRENCE_DATE, "%Y"))
biketheft$OCCURRENCE_YEAR_STRING <-
    format(biketheft$FIRST_OCCURRENCE_DATE, "%Y")


# remove data missing geotags, dates or in the ignored groups
bikesub <- biketheft[!is.na(biketheft$GEO_LON) & !is.na(biketheft$GEO_LAT) &
                     !is.na(biketheft$OCCURRENCE_YEAR), ]

# time range
minYear <- min(bikesub$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(bikesub$OCCURRENCE_YEAR, na.rm=TRUE)

# color scheme for groups
groups <- sapply(minYear:maxYear, toString)
colors <- brewer.pal(length(groups), "Purples")
pal <- colorFactor(colors, groups)

