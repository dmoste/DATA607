# load the tidyverse and lubridate libraries
library(tidyverse)
library(lubridate)

# load in the csv for analysis
csv <- "time_series_covid_19_confirmed.csv"
coronavirus_data <- data.frame(read.csv(csv, header = TRUE, stringsAsFactors = FALSE))

# clean the dataset; pivot to long form, separate data column,
# create confirmed column (based on grouping), and eliminate duplicates
coronavirus_data <- coronavirus_data %>%
  pivot_longer(c("X1.22.20":"X3.27.20"),
    names_to = "Date",
    values_to = "Cases") %>%
  separate("Date", into = c("X", "Date"), sep = "X") %>%
  group_by(Country.Region, Date) %>%
  mutate("Confirmed" = sum(Cases))%>%
  distinct(Country.Region, Date, Confirmed)

# convert Date column to a date object
coronavirus_data$Date <- mdy(coronavirus_data$Date)

# find US time interval
us_cases <- coronavirus_data %>%
  filter(Country.Region == "US") %>%
  filter(Confirmed > 0)

us_start <- us_cases$Date[1]
us_end <- us_cases$Date[length(us_cases$Date)]
us_interval <- interval(us_start, us_end)

# find Italy time interval
italy_cases <- coronavirus_data %>%
  filter(Country.Region == "Italy") %>%
  filter(Confirmed > 0)

italy_start <- italy_cases$Date[1]
italy_end <- italy_cases$Date[length(italy_cases$Date)]
italy_interval <- interval(italy_start, italy_end)

# find Spain time interval
spain_cases <- coronavirus_data %>%
  filter(Country.Region == "Spain") %>%
  filter(Confirmed > 0)

spain_start <- spain_cases$Date[1]
spain_end <- spain_cases$Date[length(spain_cases$Date)]
spain_interval <- interval(spain_start, spain_end)

# check interval overlaps
int_overlaps(us_interval,italy_interval)
int_overlaps(us_interval,spain_interval)
int_overlaps(spain_interval,italy_interval)

# examine the length of an interval
as.duration(us_interval)
as.period(us_interval)

# what is the difference in length of the outbreak in the US vs Spain?
dseconds(setdiff(us_interval,spain_interval))

# check if an interval is contained within another
spain_interval %within% us_interval
us_interval %within% spain_interval

# find the last day of each month using lubridate math
jan_end <- ymd("2019-12-31") %m+% months(1)
feb_end <- ymd("2019-12-31") %m+% months(2)
march_end <- ymd("2019-12-31") %m+% months(3)

# get total cases by month
us_by_month <- us_cases %>%
  mutate("Month" = month(Date, label = TRUE)) %>%
  group_by(Month) %>%
  filter(Date == jan_end | Date == feb_end | Date == march_end | Date == us_end)
