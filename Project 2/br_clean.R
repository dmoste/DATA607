# load required libraries
library(tidyverse)

# load the bob ross csv
br <- read.csv("bob_ross.csv", header = TRUE)

# tidy the bob ross csv (pivot_longer, filter, separate, select, group_by, mutate)
br <- br %>%
  pivot_longer(c("APPLE_FRAME":"WOOD_FRAMED"),
               names_to = "element",
               values_to = "present") %>%
  filter(present == 1) %>%
  separate("EPISODE", into = c("season", "episode"), sep = "E") %>%
  separate("season", into = c("S", "season"), sep = "S") %>%
  select(-S)

br$season <- as.integer(br$season)
br$episode <- as.integer(br$episode)

# create a data frame containing only one instance of each object
most_common <- br %>%
  group_by(element) %>%
  mutate("total" = sum(present)) %>%
  distinct(element, total) %>%
  filter(total > 50)

# plot the most popular elements
ggplot(most_common, aes(x = reorder(element, total), y = total)) +
  geom_bar(stat = "identity") +
  labs(x = "Element",
       y = "Total Appearances") +
  coord_flip()
