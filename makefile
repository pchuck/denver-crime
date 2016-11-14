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

# run shiny server locally
run_app_crime:
	R -e "shiny::runApp('denver-crime-map', display.mode='showcase')"

# run shiny server locally
run_app_bike_theft:
	R -e "shiny::runApp('denver-bike-theft-map', display.mode='showcase')"

# register w. shiny credentials
shinyio:
	R -e "shinyapps::setAccountInfo(name='', token='', secret='')

# deploy to shinyapps.io
deploy_app_crime:
	R -e "shinyapps::deployApp('denver-crime-map')"

# deploy to shinyapps.io
deploy_app_bike_theft:
	R -e "shinyapps::deployApp('denver-bike-theft-map')"


## environment 

# tmuxinator an R dev environment
create_env:
	tmuxinator start r-sandbox

# remove generated files
clean:
	rm -f *.html *.md
	rm -rf figure/

