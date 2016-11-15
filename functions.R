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

# render a crime map, with the specified overlay groups and marker settings
#   colors and groups by year
createCrimeMap_YearOverlay <- function(crime, groups, pal,
                                       radius, opacity, zoom) {
    # add the background
    base <- leaflet(crime) %>%
        setView(lng=mean(crime$GEO_LON), lat=mean(crime$GEO_LAT), zoom=zoom) %>%
        addTiles(group="OSM") %>%
        addProviderTiles("CartoDB.DarkMatter", group="Dark") %>%
        addProviderTiles("Thunderforest.OpenCycleMap", group="Cycle") %>%
        addProviderTiles("Stamen.TonerLite", group="Toner")

    # add crime markers and display the map
    base %>%
        addCircleMarkers(lng=~GEO_LON, lat=~GEO_LAT,
                         color=~pal(OCCURRENCE_YEAR_STRING),
                         radius=radius,
                         group=~OCCURRENCE_YEAR_STRING,
                         popup=paste(crime$FIRST_OCCURRENCE_DATE,
                             crime$NEIGHBORHOOD_ID,
                             crime$INCIDENT_ADDRESS,
                             sep="<br/>"), 
                         fillOpacity=opacity) %>%
        addLegend(pal=pal, values=groups) %>%
        addLayersControl(overlayGroups=groups,
                         baseGroups=c("Toner", "Dark", "OSM", "Cycle"), 
                         options=layersControlOptions(collapsed=TRUE),
                         position="bottomright")
}

# render a crime map, with the specified overlay groups and marker settings
#   colors and groups by offense categories
#   computes radius based on provided year
createCrimeMap_CatOverlay <- function(crime, groups, pal, year, opacity, zoom) {
    # add the background
    base <- leaflet(crime) %>%
        setView(lng=mean(crime$GEO_LON), lat=mean(crime$GEO_LAT), zoom=12) %>%
        addTiles(group="OSM") %>%
        addProviderTiles("CartoDB.DarkMatter", group="Dark") %>%
        addProviderTiles("Stamen.TonerLite", group="Toner")

    # add crime markers
    base %>%
        addCircleMarkers(lng=~GEO_LON, lat=~GEO_LAT,
                         color=~pal(OFFENSE_CATEGORY_ID),
                         radius=~OCCURRENCE_YEAR - year + 1,
                         group=~OFFENSE_CATEGORY_ID,
                         popup=paste(crime$FIRST_OCCURRENCE_DATE,
                                     crime$NEIGHBORHOOD_ID,
                                     crime$INCIDENT_ADDRESS,
                                     crime$OFFENSE_CATEGORY_ID, 
                                     crime$OFFENSE_TYPE_ID,
                                     sep="<br/>"), 
                         fillOpacity=opacity) %>%
        addLegend(pal=pal, values=groups) %>%
        addLayersControl(overlayGroups=groups,
                         baseGroups=c("Toner", "Dark", "OSM"),
                         options=layersControlOptions(collapsed=FALSE),
                         position="bottomright") %>%
        hideGroup(groups)
}
