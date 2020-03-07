# load required libraries
library(tidyverse)
library(rvest)
library(ggplot2)

# load the coronavirus csv
cv <- read.csv("coronavirus.csv", header = TRUE, stringsAsFactors = FALSE)

# tidy the data by separating the notes section
for(i in c("critical","serious","recovered")){
  cv <- cv %>%
  mutate(i = str_extract(notes,str_c("\\d* ", i))) %>%
  separate(i, into = c(i, str_c("word", i)), sep = " ")
}

cv <- cv %>%
  select(country, cases, deaths, critical, serious, recovered)

# remove NAs and make them 0
# (this is justified since they were created by a lack of accounts)
cv[is.na(cv)] = 0
colnames(cv)[1] <- "region"

# get world map data for coordinates, then join with my data
world_map <- map_data("world")
cv_map <- full_join(cv, world_map, by = "region")

# plot the number of cases in each country
ggplot(cv_map, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = cases), color = "black") +
  scale_fill_viridis_c(option = "C")

bar_cv <- cv_map %>%
  filter(cases > 5) %>%
  distinct(region, cases)
ggplot(bar_cv, aes(x = reorder(region, cases), y = cases)) +
  geom_bar(stat = "identity") +
  labs(x = "Region",
       y = "Total Cases") +
  coord_flip()

# remove China and Japan from the data to show the spread in other countries
cv_map$cases[cv_map$region == "China"] = NA
cv_map$cases[cv_map$region == "Japan"] = NA

ggplot(cv_map, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = cases), color = "black") +
  scale_fill_viridis_c(option = "C")

bar_cv <- cv_map %>%
  filter(cases > 5) %>%
  distinct(region, cases)
ggplot(bar_cv, aes(x = reorder(region, cases), y = cases)) +
  geom_bar(stat = "identity") +
  labs(x = "Region",
       y = "Total Cases") +
  coord_flip()

################################################################################
# get some new, more current data
url <- "https://www.worldometers.info/coronavirus/#countries"
new_cv <- read_html(url) %>%
  html_nodes("table") %>%
  html_table()

# clean this new data. All NAs should be 0 since they occured
#due to there being no reported cases
new_cv <- new_cv[[1]]
new_cv$TotalCases <- str_remove(new_cv$TotalCases,",")
new_cv$TotalDeaths <- str_remove(new_cv$TotalDeaths,",")
new_cv$TotalCases <- as.integer(new_cv$TotalCases)
new_cv$TotalDeaths <- as.integer(new_cv$TotalDeaths)
new_cv[is.na(new_cv)] = 0

# right join with world map to get rid of data points that don't have coordinates
# create the death rate variable
colnames(new_cv)[1] <- "region"
new_cv <- right_join(new_cv, world_map, by = "region")
new_cv <- new_cv %>%
  mutate("death_rate" = round((TotalDeaths/TotalCases)*100, digits = 2))

# plot this new data
ggplot(new_cv, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = TotalCases), color = "black") +
  scale_fill_viridis_c(option = "C")

bar_cv <- new_cv %>%
  filter(TotalCases > 20) %>%
  distinct(region, TotalCases)
ggplot(bar_cv, aes(x = reorder(region, TotalCases), y = TotalCases)) +
  geom_bar(stat = "identity") +
  labs(x = "Region",
       y = "Total Cases") +
  coord_flip()

# look at death rate
rate <- new_cv %>%
  filter(region != "Philippines")
ggplot(rate, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = death_rate), color = "black") +
  scale_fill_viridis_c(option = "C")

# remove China again and plot
new_cv$TotalCases[new_cv$region == "China"] = NA

ggplot(new_cv, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = TotalCases), color = "black") +
  scale_fill_viridis_c(option = "C")

bar_cv <- new_cv %>%
  filter(TotalCases > 20) %>%
  distinct(region, TotalCases)
ggplot(bar_cv, aes(x = reorder(region, TotalCases), y = TotalCases)) +
  geom_bar(stat = "identity") +
  labs(x = "Region",
       y = "Total Cases") +
  coord_flip()

# remove Italy and Iran and plot
new_cv$TotalCases[new_cv$region == "Italy"] = NA
new_cv$TotalCases[new_cv$region == "Iran"] = NA

ggplot(new_cv, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = TotalCases), color = "black") +
  scale_fill_viridis_c(option = "C")

bar_cv <- new_cv %>%
  filter(TotalCases > 20) %>%
  distinct(region, TotalCases)
ggplot(bar_cv, aes(x = reorder(region, TotalCases), y = TotalCases)) +
  geom_bar(stat = "identity") +
  labs(x = "Region",
       y = "Total Cases") +
  coord_flip()
