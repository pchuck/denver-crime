
[Denver Bike Theft Map](https://pchuck.shinyapps.io/denver-bike-theft-map) was developed to visualize reported Denver crimes classified as bicycle theft since 2011.

* **Select** a map tileset from the radio button overlay
* **Click** on a circle marker to get details of a particular incident.

The interactive map is part of a larger [exploratory analysis of Denver Crime](https://github.com/pchuck/denver-crime), which includes data on all reported Denver crimes.

Data is acquired from the [Open Data Catalog](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-traffic-accidents) and is based on police reports collected by districts and precincts within the city and county of Denver. Currently, the dataset contains information on approximately 500,000 incidents.

Of those incidents, the application looks specifically at the subset of crimes categorized as larceny with an offense type of "theft-bicycle".

This means that more severe crimes (such as armed robberies or burglaries) involving the theft of a bicycle, but otherwise classified, are not included.

Finally, in years prior to 2012, location data is often not available for larceny incidents, making many data points not displayable. These earlier crimes, however, are included in the Year graph showing the number of thefts per year.

The application is written in R and utilizes the Shiny and Leaflet libraries.

*Links*

* [github repository](https://github.com/pchuck/denver-crime)
* [shiny application](https://pchuck.shinyapps.io/denver-bike-theft-map)

