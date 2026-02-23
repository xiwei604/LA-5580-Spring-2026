## ----Install-packages---------------------------------------------------------
#load one at a time
install.packages("tidycensus")
install.packages("tidyverse")
install.packages("dplyr") #this is actually also loaded in the tidyverse
#or several at once, these are more for visual display
install.packages(c("tidyverse", "plotly"))
install.packages("highcharter") #interactive charts
#and these help with spatial
install.packages(c("sf", "tigris"))



## ----Load Libraries-----------------------------------------------------------
#load one at a time
library(tidycensus)
library(tidyverse)
library(dplyr)
library(sf)
library(tigris)

library(ggplot2)
library(plotly)
library(highcharter)

## ----Loading Tidy Census ACS Data---------------------------------------------
# For this example, we are going to look at Poverty
# To calculate income to poverty, you divide a person or family's total 
# income before taxes by the federally established poverty threshold that 
# corresponds to their household size; if the result is less than 1, then 
# their income is considered below the poverty line.
# official documentation on this data is at 
# https://www.census.gov/topics/income-poverty/poverty/guidance/poverty-measures.html



#Display all the variable in the 2023 1 year ACS and open a tab to view the info
ACS1_2024_variables <- load_variables(2024, "acs1", cache = TRUE)
View(ACS1_2024_variables)

#for ACS5
ACS5_2024_variables <- load_variables(2024, "acs5", cache = TRUE)
View(ACS5_2024_variables)

#name, label, concept and lowest level of geography available are displayed.
# this table is searchable
#search for the word Poverty and we find  there are two variables of interest

# B05010_001 total number in the estimate
# B05010_002 total number with a ratio value below 1, by definition in poverty

# Now that we have two variables to work with, we want to retrieve them from 
# The US Census using a package called TidyCensus

# Save the results of this in data frame which I am calling something like poverty_df

#Example looking at ACS1 data, remove the survey = "acs1" to use acs5
poverty_est_df <- get_acs(geography = "county", 
              variables = "B05010_001",
              state = "Iowa", 
              output = "wide",
              geometry = TRUE, 
              survey = "acs1",
              year = 2023)
#look at the data frame and notice only 10 results!
view(poverty_est_df)

#maybe preview this as a map
#add Mapview package and library. In the future include this at the top of script!
install.packages("mapview")
library(mapview)

mapview(poverty_est_df)



## ----Getting down to business---------------------------------------------

# Before we get to far, we need to set our working directory. So first save this file.
# From the Session Menu --> Set Working Directory --> To Source File Location
getwd() #this will display your working directory

#Get the ACS5 data, remove the survey = "acs1" to use acs5
poverty_est_df <- get_acs(geography = "county", 
                          variables = "B05010_001",
                          state = "Iowa", 
                          output = "wide",
                          geometry = TRUE,
                          year = 2024)
mapview(poverty_est_df)

#now get the B05010_002 total number with a ratio value below 1
poverty_under1_df <- get_acs(geography = "county", 
                          variables = "B05010_002",
                          state = "Iowa", 
                          output = "wide",
                          geometry = TRUE,
                          year = 2024)
mapview(poverty_under1_df)


#but now we have two data frames, it would be better if we had this in just one
poverty_df <- get_acs(geography = "county", 
                      variables = c(poverty_est = "B05010_001",
                                    poverty_und1 = "B05010_002"),
                      state = "Iowa", 
                      output = "wide",
                      geometry = TRUE,
                      year = 2024)
view(poverty_df)
mapview(poverty_df)

#Looks good so we can create a shapefile
st_write(poverty_df, "iowa_poverty.shp")

#note error message about ESRI field name abbreviation
#so save as a geojson!
st_write(poverty_df, "iowa_poverty.geojson")

#If we just wanted the data asa CSV, we could run the code above with geometry = FALSE
poverty_df_noGeo <- get_acs(geography = "county", 
                      variables = c(poverty_est = "B05010_001",
                                    poverty_und1 = "B05010_002"),
                      state = "Iowa", 
                      output = "wide",
                      geometry = FALSE,
                      year = 2024)
view(poverty_df_noGeo)
write_csv2(poverty_df_noGeo, "povertyRatio.csv", append = FALSE)

