#### Metadata ####

# This script creates .csv files from data provided in the nycflights13 package
# Author Matt Stephenson
# Feb 2023

#### Set up workspace ####

rm(list=ls())

library(nycflights13) # this package contains the data objects used below

#### Export flat tables ####
# To demonstrate importing and manipulating tables, 
  # we need .csv files, not package data()

write.csv(airlines, file="01-data-raw/airlines.csv", row.names=F)
write.csv(airports, file="01-data-raw/airports.csv", row.names=F)
write.csv(planes, file="01-data-raw/planes.csv", row.names=F)
write.csv(weather, file="01-data-raw/weather.csv", row.names=F)
write.csv(flights, file="01-data-raw/flights.csv", row.names=F) # This one is big

