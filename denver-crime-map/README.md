
[Denver Crime Map](https://pchuck.shinyapps.io/denver-crime-map) was developed to visualize selected categories of Denver crime since 2011.

* **Select** a map tileset from the radio button overlay
* **Select** different categories of crimes in the checkbox overlay
* **Click** on a circle marker to get details of a particular incident.
* **Color** of marker represents crime category.
* **Radius** of marker represents time. Recent incidents are larger.

The interactive map is part of a larger [exploratory analysis of Denver Crime](https://github.com/pchuck/denver-crime), which includes data on all reported Denver crimes.

Data is acquired from the [Open Data Catalog](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-traffic-accidents) and is based on police reports collected by districts and precincts within the city and county of Denver. Currently, the dataset contains information on approximately 500,000 incidents.

The following categories of crimes are excluded from the map because of the large volume of data involved. This brings the current dataset down to <100,000 incidents.

* drug alcohol
* larceny
* auto theft
* theft from motor vehicle
* public disorder
* white collar crimes
* other crimes against persons
* all other crimes

Other categories of crimes, particular sexual assault, are excluded. These reports have redacted location information and cannot be displayed.

The application is written in R and utilizes the Shiny and Leaflet libraries.

*Links*

* [github repository](https://github.com/pchuck/denver-crime)
* [shiny application](https://pchuck.shinyapps.io/denver-crime-map)

