
#### Metadata ####

# This script shows an example workflow including producing and saving
  # analysis products
# Author Matt Stephenson
# Feb 2023

# Based on materials by Denis Cohen, Cosima Meyer, Marcel Neunhoeffer,
# and Oliver Rittmann 
# (https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/efficient-data-r/) 
# and Hadley Wickham (https://r4ds.had.co.nz/relational-data.html)


#### Set up workspace ####

# Clear working environment
rm(list=ls()) 

library(nycflights13)
library(dplyr)
library(ggplot2)

#### Load cleaned data ####

flights2 <- readRDS("02-data-processed/nycflights13_flight_dataset.RDS")

#### Final data manipulations ####

airport.delays <- flights2 %>%
  left_join(airports, by=c("dest"="faa")) %>%
  group_by(name, lon, lat) %>%
  summarise(dep_delay_mean = mean(dep_delay, na.rm=T)) %>%
  na.omit()

delays <- flights2 %>%
  mutate(precip_category=cut(precip, breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1, Inf)),
         gust_category = cut(wind_gust, breaks=c(-Inf, 15, 30, 45, 60, Inf)))

#### Produce visualizations ####

delay.map <- ggplot(airport.delays, aes(lon, lat)) +
  borders("state") +
  geom_point(aes(color=dep_delay_mean)) +
  coord_quickmap()

delay.map

delays.by.gust <- ggplot(delays[!is.na(delays$dep_delay),], aes(x=precip_category, y=dep_delay)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle=-45, vjust=-1))

delays.by.gust

#### Export visualizations ####

ggsave(plot=delay.map, 
       filename="04-analysis-products/delay_map.jpg",
       device="jpeg",
       units="in",
       width=7.5,
       height=3.375,
       dpi=300)

ggsave(plot=delays.by.gust, 
       filename="04-analysis-products/delays_by_gust.jpg",
       device="jpeg",
       units="in",
       width=3.375,
       height=3.375,
       dpi=300)

#### Session cleanup ####
# Take an renv snapshot() at the end of each session to save version info
renv::snapshot()

# Also remember to commit changes and push to GitHub

