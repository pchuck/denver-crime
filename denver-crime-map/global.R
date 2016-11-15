## denver-crime, R/Shiny App - global
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
library(RColorBrewer)
library(leaflet)
source(file="functions.R")

# various constants
TITLE <- "Denver Crime"
CRIME_LOCAL <- "data/denver_crime.csv" # static copy of the open data
DATE_FORMAT <- "%Y-%m-%d %H:%M:%S" # date format used in the source data

# read and transform the Denver open data crime dataset
crime <- readDenverCrime(CRIME_LOCAL)

# transform the date fields
crime$FIRST_OCCURRENCE_DATE <-
    as.POSIXct(crime$FIRST_OCCURRENCE_DATE, format=DATE_FORMAT)

# create a new column with the year component
crime$OCCURRENCE_YEAR <- 
    as.numeric(format(crime$FIRST_OCCURRENCE_DATE, "%Y"))

# super-group including all offense categories
groups_all <- unique(crime$OFFENSE_CATEGORY_ID)

# ignored - categories w/o location, more frequent and non-violent crimes
groups_ignore <- c("drug-alcohol", "all-other-crimes", "public-disorder", "larceny", "theft-from-motor-vehicle", "auto-theft", "other-crimes-against-persons", "white-collar-crime", "sexual-assault")

# default display - violent crimes
groups_display <- c("murder", "arson", "aggravated-assault",
                    "burglary", "robbery")

groups <- groups_display # vs. groups_all[! groups_all %in% groups_ignore]

# include display groups and remove data missing geotags or dates
subset <- crime[crime$OFFENSE_CATEGORY_ID %in% groups_display &
                !is.na(crime$GEO_LON) & !is.na(crime$GEO_LAT) &
                !is.na(crime$OCCURRENCE_YEAR), ]

# time range
minYear <- min(subset$OCCURRENCE_YEAR, na.rm=TRUE)
maxYear <- max(subset$OCCURRENCE_YEAR, na.rm=TRUE)

# color scheme for groups
# colors <- brewer.pal(length(groups), "Paired")
colors <- c("tomato", "darkgreen", "red", "purple", "navyblue", "darkgray")
pal <- colorFactor(colors, subset$OFFENSE_CATEGORY_ID)
