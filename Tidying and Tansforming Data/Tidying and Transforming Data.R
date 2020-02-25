# open the required libraries
library(keyring)
library(RMySQL)

# connect to MySQL and get all of the airline data from the database
con <- dbConnect(MySQL(), dbname = 'airlines', host = 'localhost', port = 3306, user = 'root', password = key_get("airlines", "root"))

sql = "SELECT * FROM flights"
airlines <- dbGetQuery(con, sql)
names(airlines) <- c("airline", "result", "Los Angeles", "Phoenix", "San Diego", "San Francisco", "Seattle")

# get the total number of delayed and on-time flights for each airline
airlines$Totals <- rowSums(airlines[3:7])

# compare airlines in a stacked proportional bar graph
ggplot(airlines, aes(x = airline, y = Totals, fill = result)) +
  geom_bar(position = "fill", stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Airline",
       y = "On Time",
       fill = "Result",
       title = "Comparing On Time Rates of Airlines",
       subtitle = "AM West has a better overall on-time rate")

# use pivot_longer to switch destinations from columns to rows
airlines <- airlines %>%
  select(-Totals) %>%
  pivot_longer(
    c("Los Angeles", "Phoenix", "San Diego", "San Francisco", "Seattle"),
    names_to = "destination",
    values_to = "count"
  )

# set up the airlines data frame
airlines <- airlines %>%
  group_by(airline, destination)

# get the total flights based on destination
totalFlights <- airlines %>%
  summarise(count = sum(count))

# filter based result (keep onTime values)
onTimeFlights <- airlines %>%
  filter(result == "onTime") %>%
  select(-result)

onTimeFlights$rate <- onTimeFlights$count/totalFlights$count
totalFlights$rate <- onTimeFlights$rate

# create plots to compare the airlines performace based on destination
ggplot(onTimeFlights, aes(x = destination, y = rate, color = airline)) +
  geom_point() +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "Destination",
       y = "On Time Rate",
       color = "Airline") +
  coord_flip()

ggplot(onTimeFlights, aes(x = reorder(destination, -rate), y = rate, fill = airline)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Destination",
       y = "On Time",
       fill = "Airline") +
  coord_flip()

ggplot(totalFlights, aes(x = airline, y = count, fill = destination)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_brewer(palette = "Spectral") +
  labs(x = "Airline",
       y = "Total Flights",
       fill = "Destination")

ggplot(totalFlights, aes(x = reorder(destination, count), y = count, fill = airline)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Destination",
       y = "Total Flights",
       fill = "Airline") +
  coord_flip()
