library(keyring)
library(RMySQL)
library(tidyverse)

con <- dbConnect(RMySQL::MySQL(), dbname = 'project_3',
                 host = 'localhost', port = 3306, user = 'root',
                 password = keyring::key_get("project_3","root"))

sql <- "SELECT * FROM indeed1"
indeed1 <- dbGetQuery(con, sql)

sql <- "SELECT * FROM reddit"
reddit <- dbGetQuery(con, sql)

indeed_data <- indeed1 %>%
  filter(upos == "NOUN")
               
indeed_data$Indeed <- (indeed_data$count)/sum(indeed_data$count)

reddit_data <- reddit %>%
  filter(upos == "NOUN")

reddit_data$Reddit <- (reddit_data$count)/sum(reddit_data$count)

data_compare <- indeed_data %>%
  inner_join(reddit_data, by = "token") %>%
  filter(count.x >100) %>%
  filter(count.y >100) %>%
  select(-lemma.x, -lemma.y, -upos.x, -upos.y) %>%
  pivot_longer(
    c("Reddit", "Indeed"),
    names_to = "Database",
    values_to = "Count"
  )

ggplot(data_compare, aes(x = reorder(token, Count), y = Count,
                          fill = Database)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Word",
       y = "Usage",
       fill = "Site") +
  coord_flip()
