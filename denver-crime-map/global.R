## denver-crime, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(RColorBrewer)
library(leaflet)

# various constants
TITLE <- "Denver Crime"
SOURCE <- "data/denver_crime.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data
MAP_TYPE <- "Stamen.TonerLite" # underlying map tile source/type
BAD_LON <- -100 # consider datapoints outside this longitude invalid

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
crime$OCCURRENCE_YEAR <- 
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%Y"))

# separate traffic crimes. there's some overlap here, e.g. vehicular assault
full <- crime
traffic <- crime[crime$IS_TRAFFIC %in% c(1), ]
crime <- crime[crime$IS_CRIME %in% c(1), ]

# ignore some types to make the interactive display more responsive
groups_all <- unique(crime$OFFENSE_CATEGORY_ID)
groups_ignore <- c("public-disorder", 
                   "white-collar-crime",
                   "all-other-crimes",
                   "other-crimes-against-persons",
                   "theft-from-motor-vehicle",
                   "auto-theft")
groups <- groups_all[! groups_all %in% groups_ignore]

# remove data missing geotags, dates or in the ignored groups
subset <- crime[!crime$OFFENSE_CATEGORY_ID %in% groups_ignore &
                !is.na(crime$GEO_LON) & !is.na(crime$GEO_LAT) &
                !is.na(crime$OCCURRENCE_YEAR), ]

# time range
minYear <- min(subset$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(subset$OCCURRENCE_YEAR, na.rm=TRUE)

# color scheme for groups
colors <- brewer.pal(length(groups), "Paired")
pal <- colorFactor(colors, subset$OFFENSE_CATEGORY_ID)
