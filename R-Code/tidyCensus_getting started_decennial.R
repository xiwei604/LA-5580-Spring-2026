## ----Install-packages---------------------------------------------------------
#load one at a time
install.packages("tidycensus")
install.packages("dplyr") #this is actually also loaded in the tidyverse
#or several at once, these are more for visual display
install.packages(c("tidyverse", "plotly"))
install.packages("highcharter") #interactive charts
#and these help with spatial
install.packages(c("sf", "tigris", "mapview"))


## ----Load Libraries-----------------------------------------------------------
#load one at a time
library(tidycensus)
library(tidyverse)
library(dplyr)
library(sf)
library(tigris)
library(mapview)
library(ggplot2)
library(plotly)
library(highcharter)


## ----Loading Tidy Census Data---------------------------------------------
# For this example, we will start with getting the total population for 
# the 2020 decennial census using the TidyCensus package


# Before we get to far, we need to set our working directory. So first save this file.
# From the Session Menu --> Set Working Directory --> To Source File Location
getwd() #this will display your working directory


#Display all the variable in the 2020 Decennial data set
vDec <- load_variables(2020, "dhc", cache = TRUE)
View(vDec)

#name, label, concept are displayed.
# this table is searchable
#search for P1_001N - this is the overall total population

# Now lets go and use Tidy Census to retrieve this data so we can use it in Tableau
totalPop <- get_decennial(
  geography = "county", #could use County or State
  state = "IA", #since we said county, we can also tell it for which state
  variables = "P1_001N",  #Total Population variable
  year = 2020,  #census year - note 2010 has a slightly different format 
  sumfile = "dhc",  #Demographic and Housing Characteristics
  geometry = TRUE #TRUE or FALSE
)
totalPop

#It runs really slow if you do this for State and all counties with geometry!
#plot(totalPop["value"])

#the sf package allows us to write to a shapefile or geojson
#Unless you have set your working directory, it will default to what getwd() displayed
#Go to the menu Session and select Set Working Directory and decide where you want output to be written
st_write(totalPop, "totalPop_IAcounties.shp")


#Lets do this again, but for all states and then save it as a csv
totalPopStates <- get_decennial(
  geography = "state", #could use County or State
  #state = "IA",
  variables = "P1_001N",  #Total Population
  year = 2020,
  sumfile = "dhc",  #Demographic and Housing Characteristics
  geometry = FALSE
)
totalPopStates

write_csv2(totalPopStates, "totalPopStates.csv", append = FALSE)


#Same as above but for the Census tracts in Iowa and with geometry
totalPopIA_tracts <- get_decennial(
  geography = "tract", 
  state = "IA",
  variables = "P1_001N",  #Total Population
  year = 2020,
  sumfile = "dhc",  #Demographic and Housing Characteristics
  geometry = TRUE
)
totalPopIA_tracts
st_write(totalPopIA_tracts, "totalPopIA_tracts.geojson")

plot(totalPopIA_tracts["value"])