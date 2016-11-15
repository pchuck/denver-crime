## util funcs for Denver data acquistion and transform
##
## (c) Patrick Charles; see http://pchuck.net
## redistribute or modify under the GPL; see http://www.gnu.org/licenses
##

# acquire a copy of the data from the Open Data repository
acquireAndSave <- function(source_url, dest_path) {
    download.file(url=source_url, destfile=dest_path, method='wget')
}

# read denver crime format sources (e.g. denver traffic data, crime data, etc)
readDenverCrime <- function(source) {
    read.csv(source, sep=",", header=TRUE, stringsAsFactors=FALSE, 
             colClasses=c("OFFENSE_CODE"="factor",
                          "OFFENSE_CODE_EXTENSION"="factor",
                          "OFFENSE_TYPE_ID"="factor",
                          "OFFENSE_CATEGORY_ID"="factor",
                          "INCIDENT_ADDRESS"="character",
                          "DISTRICT_ID"="factor",
                          "PRECINCT_ID"="factor",
                          "NEIGHBORHOOD_ID"="factor"))
}

# write denver crime format data to disk
saveDenverCrime <- function(df, dest) {
    write.csv(df, file=dest)
}
    
# create a subset of the data excluding traffic incidents
subsetNonTraffic <- function(crime) {
    crime <- crime[crime$IS_CRIME %in% c(1), ]
}

# create a subset of the data excluding non-traffic
subsetTraffic <- function(crime) {
    crime[crime$IS_TRAFFIC %in% c(1), ]
}

# create a subset of the crimes specifically for the cycling theft analysis
subsetBikeTheft <- function(crime) {
    crime[crime$IS_CRIME %in% c(1) &
          crime$OFFENSE_CATEGORY_ID == "larceny" &
          crime$OFFENSE_TYPE_ID == "theft-bicycle", ]
}



    
