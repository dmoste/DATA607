library(jsonlite)
library(tidyverse)

key <- "2rgJQycgUYqUYaZOWbMGtfjtK7ZzUkNh"

live_url <- str_c("https://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=",key)
most_viewed_url <- str_c("https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=",key)
most_shared_url <- str_c("https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=",key)

live_import <- fromJSON(live_url)
nyt_live_feed <- live_import$results

mv_import <- fromJSON(most_viewed_url)
nyt_most_viewed <- mv_import$results

ms_import <- fromJSON(most_shared_url)
nyt_most_shared <- ms_import$results

live_and_viewed <- inner_join(nyt_live_feed, nyt_most_viewed, by = "url")
live_and_shared <- inner_join(nyt_live_feed, nyt_most_shared, by = "url")
shared_and_viewed <- inner_join(nyt_most_shared, nyt_most_viewed, by = "url")

adx_keywords <- str_split(nyt_most_shared$adx_keywords,";")

phrases_shared <- c()
for(i in 1:length(adx_keywords)){
  for(j in 1:length(adx_keywords[[i]])){
    phrases_shared <- rbind(phrases_shared, adx_keywords[[i]][j])
  }
}

keywords_shared <- data.frame(phrases_shared) %>%
  count(phrases_shared) %>%
  filter(n > 2)

names(keywords_shared) <- c("Phrases", "Counts")

ggplot(keywords_shared, aes(x = reorder(Phrases, Counts), y = Counts)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(x = "Keyword",
       y = "Occurances") +
  coord_flip()

adx_keywords <- str_split(nyt_most_viewed$adx_keywords,";")

phrases_viewed <- c()
for(i in 1:length(adx_keywords)){
  for(j in 1:length(adx_keywords[[i]])){
    phrases_viewed <- rbind(phrases_viewed, adx_keywords[[i]][j])
  }
}

keywords_viewed <- data.frame(phrases_viewed) %>%
  count(phrases_viewed) %>%
  filter(n > 2)

names(keywords_viewed) <- c("Phrases", "Counts")

ggplot(keywords_viewed, aes(x = reorder(Phrases, Counts), y = Counts)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(x = "Keyword",
       y = "Occurances") +
  coord_flip()

all_keywords <- full_join(keywords_shared, keywords_viewed, by = "Phrases")
names(all_keywords) <- c("Phrases","Shared","Viewed")
all_keywords$Shared[is.na(all_keywords$Shared)] = 0
all_keywords$Viewed[is.na(all_keywords$Viewed)] = 0
all_keywords$Total <- all_keywords$Shared + all_keywords$Viewed
all_keywords <- pivot_longer(all_keywords,
                             c("Shared","Viewed","Total"),
                             names_to = "Type",
                             values_to = "Count")

ggplot(all_keywords, aes(x = reorder(Phrases, Count), y = Count,
                         fill = Type)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Keyword",
       y = "Occurances",
       fill = "Type") +
  coord_flip()
