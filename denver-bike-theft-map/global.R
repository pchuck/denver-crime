## denver-bike-theft-map, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(RColorBrewer)
library(leaflet)

# various constants
TITLE <- "Denver Bike Thefts"
SOURCE <- "data/denver_crime.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data
MAP_TYPE <- "Stamen.TonerLite" # underlying map tile source/type
BAD_LON <- -100 # consider datapoints outside this longitude invalid
COLOR <- "red"
RADIUS <- 5
OPACITY <- 0.5

# read and transform the Denver open data crime dataset
crime <- read.csv(SOURCE,
    sep=",", header=TRUE, stringsAsFactors=FALSE, 
    colClasses=c("OFFENSE_CODE"="factor",
                 "OFFENSE_CODE_EXTENSION"="factor",
                 "OFFENSE_TYPE_ID"="factor",
                 "OFFENSE_CATEGORY_ID"="factor",
                 "INCIDENT_ADDRESS"="character",
                 "DISTRICT_ID"="factor",
                 "PRECINCT_ID"="factor",
                 "NEIGHBORHOOD_ID"="factor")
)

# discard wildly inconsistent geo points
crime <- crime[!(crime$GEO_LON > BAD_LON), ]

# transform the date fields
crime$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(crime$FIRST_OCCURRENCE_DATE, format=DATE_FORMAT)

# create a new column with the year component
crime$OCCURRENCE_HOUR <-
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%H")) +
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%M")) / 60
crime$OCCURRENCE_DAY <- 
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%u"))
crime$OCCURRENCE_MONTH <- 
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%m"))
crime$OCCURRENCE_YEAR <- 
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%Y"))
crime$OCCURRENCE_YEAR_STRING <-
    format(crime$FIRST_OCCURRENCE_DATE, "%Y")

# separate traffic crimes. there's some overlap here, e.g. vehicular assault
full <- crime
traffic <- crime[crime$IS_TRAFFIC %in% c(1), ]
crime <- crime[crime$IS_CRIME %in% c(1), ]
biketheft <- crime[crime$OFFENSE_CATEGORY_ID == "larceny" &
                   crime$OFFENSE_TYPE_ID == "theft-bicycle", ]

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

plot <- TRUE
