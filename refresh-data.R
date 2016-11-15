## script to refresh from source and segment local copy of Denver crime data
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##
source(file="functions.R")

CRIME_URL <- "http://data.denvergov.org/download/gis/crime/csv/crime.csv"
CRIME_FULL_LOCAL <- "data/denver_crime_full.csv"
BIKE_LOCAL <- "data/denver_bike_theft.csv"
TRAFFIC_LOCAL <- "data/denver_traffic.csv"
CRIME_LOCAL <- "data/denver_crime.csv"

acquireAndSave(CRIME_URL, CRIME_FULL_LOCAL)
crime <- readDenverCrime(CRIME_FULL_LOCAL)

# traffic accident subset of all crimes
saveDenverCrime(subsetTraffic(crime), TRAFFIC_LOCAL)

# non-traffic subset of all crimes
saveDenverCrime(subsetNonTraffic(crime), CRIME_LOCAL)

# larceny/bike theft subset of non-traffic crimes
saveDenverCrime(subsetBikeTheft(crime), BIKE_LOCAL)


