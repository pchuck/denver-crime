# denver open data crime analysis
#
# exploratory analysis of traffic accident data set
#

## render main report
render:
	./R/rmdToHtml.R crime


## shiny application

# install prerequisite packages
prereqs:
	R -e "install.packages(c('devtools', 'shiny'), repos='http://cran.us.r-project.org'); devtools::install_github('rstudio/shinyapps')"

# acquire data from the Open Data source and segment for specific apps
acquire_data:
	R -e "source(file='refresh-data.R')"
	cp data/denver_bike_theft.csv denver-bike-theft-map/data/
	cp data/denver_crime.csv denver-crime-map/data/

# run shiny server locally
run_app_crime:
	R -e "shiny::runApp('denver-crime-map', display.mode='showcase')"

# create a static copy of the crime leaflet app for ghpages
create_static_crime:
	R -e "source(file='denver-crime-map.R')"
	mv denver-crime-map.html gh-pages/

# run shiny server locally
run_app_bike_theft:
	R -e "shiny::runApp('denver-bike-theft-map', display.mode='showcase')"

# create a static copy of the bike theft leaflet app for ghpages
create_static_bike_theft:
	R -e "source(file='denver-bike-theft-map.R')"
	mv denver-bike-theft-map.html gh-pages/

# register w. shiny credentials
shinyio:
	R -e "shinyapps::setAccountInfo(name='', token='', secret='')

# deploy to shinyapps.io
deploy_app_crime:
	R -e "shinyapps::deployApp('denver-crime-map')"

# deploy to shinyapps.io
deploy_app_bike_theft:
	R -e "shinyapps::deployApp('denver-bike-theft-map')"

# deply to ghpages
deploy_ghpages: create_static_bike_theft create_static_crime
	git subtree push --prefix gh-pages/ origin gh-pages


## environment 

# tmuxinator an R dev environment
create_env:
	tmuxinator start r-sandbox

# remove generated files
clean:
	rm -f *.html *.md
	rm -rf figure/
