
#### Metadata ####

# This script shows an example workflow including directory structure,
  # importing data from flat files, manipulating data using tidy approaches,
  # and exporting datasets
# Author Matt Stephenson
# Feb 2023

# Based on materials by Denis Cohen, Cosima Meyer, Marcel Neunhoeffer,
  # and Oliver Rittmann 
  # (https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/efficient-data-r/) 
  # and Hadley Wickham (https://r4ds.had.co.nz/relational-data.html)

# For nycflights13 data:
  # 'flights' connects to 'planes' via a single variable, 'tailnum'
  # 'flights' connects to 'airlines' through the 'carrier' variable
  # 'flights' connects to 'airports' in two ways: 'origin' and 'dest' variables
  # 'flights' connects to 'weather' via 'origin' (the location), 
    # and 'year', 'month', 'day' and 'hour' (the time).


#### Set up workspace ####

# Clear working environment

# It is good practice to clear your working environment at the 
  # top of each script to avoid issues with lingering objects from 
  # superseded code

rm(list=ls()) 

library(dplyr)

#### Import Data ####

# Load raw data from the project directory
# No need to set a working directory if we are operating within a .RProj

airlines <- read.csv("01-data-raw/airlines.csv")
airports <- read.csv("01-data-raw/airports.csv")
planes <- read.csv("01-data-raw/planes.csv")
weather <- read.csv("01-data-raw/weather.csv")
flights <- read.csv("01-data-raw/flights.csv")

#### Manipulate data ####

# The variables used to connect each pair of tables are called keys. 
  # A key is a variable (or set of variables) that uniquely identifies an 
  # observation. There are two types of keys:
    # A primary key uniquely identifies an observation in its own table. 
      # For example, planes$tailnum is a primary key because it uniquely 
      # identifies each plane in the planes table.
    # A foreign key uniquely identifies an observation in another table. 
      # For example, flights$tailnum is a foreign key because it appears in the 
      # flights table where it matches each flight to a unique plane.
    # A variable can be both a primary key and a foreign key. 
      # For example, origin is part of the weather primary key, and is also a 
      # foreign key for the airports table.
  # If a table lacks a primary key, it’s sometimes useful to add one.
    # That makes it easier to match observations if you’ve done some filtering 
    # and want to check back in with the original data. This is called a 
    # surrogate key.

# Add a surrogate key to 'flights'
flights <- flights %>%
  mutate(surrogate_key = row_number()) %>% # Base the surrogate_key on row number
  relocate(surrogate_key) # Place the surrogate_key in the first field position

# Create the dataset of interest
flights2 <- flights %>%
  select(year:day, hour, origin, dest, dep_delay, tailnum, carrier) %>%
  left_join(airlines, by = "carrier") %>%
  rename(carrier_name = name) %>% # Avoids a later conflict with $name
  left_join(weather) %>%
  # The planes table also contains a (plane model) year field, 
    # which we can remove with select()
  left_join(select(planes, -year), by = "tailnum")
  # Sometimes you need to match without keys of the same name
  #left_join(airports, c("dest" = "faa"))
  # You could also join by origin airport
  #left_join(airports, c("origin" = "faa"))

#### Export polished dataset ####

# Now that we have finished manipulating our dataset,
  # we need to save the analysis-ready version

saveRDS(flights2, "02-data-processed/nycflights13_flight_dataset.RDS")




