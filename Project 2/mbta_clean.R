# load required libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

# load the mbta csv
mbta <- read.csv("mbta.csv", header = FALSE)

# clean a little to get the dates in date format
dates <- mbta %>%
  filter(V2 == "mode") %>%
  select(V3:V60) %>%
  pivot_longer(c(V3:V60), names_to = "V", values_to = "dates")

dates$dates <- str_c(dates$dates,"-01")
dates <- ymd(dates$dates)

# clean the data to make each date an instance
mbta <- mbta %>%
  pivot_longer(c("V3":"V60"), names_to = "day", values_to = "rides") %>%
  cbind(dates) %>%
  select(-day, -V1) %>%
  filter(V2 != "mode") %>%
  filter(V2 != "All Modes by Qtr") %>%
  filter(V2 != "Pct Chg / Yr")

mbta$rides <- as.numeric(as.character(mbta$rides))
colnames(mbta)[1] <- "mode"

# create a plot of dates vs rides for each mode of transportation
# this is the initial overview of the data
ggplot(mbta, aes(x = dates, y = rides, color = mode)) +
  geom_point() +
  labs(title = "MBTA",
       subtitle = "Boston Transit",
       x = "Date",
       y = "Rides",
       color = "Mode")

# remove the total rides to get a better picture of the data
without_total <- mbta %>%
  filter(mode != "TOTAL")

ggplot(without_total, aes(x = dates, y = rides, color = mode)) +
  geom_point() +
  labs(title = "MBTA",
       subtitle = "Boston Transit",
       x = "Date",
       y = "Rides",
       color = "Mode")

ggplot(without_total, aes(x = reorder(mode, rides), y = rides)) +
  geom_bar(stat = "identity") +
  labs(title = "MBTA",
       subtitle = "Boston Transit",
       x = "Mode",
       y = "Total Rides 2007-2010") +
  coord_flip()

###############################################################################

# create a data frame of year by year data and plot
zoom <- c()
for(i in 8:12){
  zoom_hold <- mbta %>%
    filter(dates < ymd(str_c(2000+i,"-01-01"))) %>%
    filter(dates >= ymd(str_c(2000+i-1,"-01-01"))) %>%
    filter(mode == "TOTAL") %>%
    mutate("year" = str_c(2000+i-1)) %>%
    mutate("months" = row_number()) %>%
    select(-mode, -dates)
  
  zoom <- rbind(zoom, zoom_hold)
}

ggplot(zoom, aes(x = months, y = rides, color = year)) +
  geom_point() +
  geom_smooth(color = "black", se = FALSE) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "MBTA",
       subtitle = "Boston Transit",
       x = "Month",
       y = "Rides",
       color = "Year")
