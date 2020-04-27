library(tm)
library(tidytext)

ham_corpus <- VCorpus(DirSource(directory = "./easy_ham/"))
tidy_ham <- tidy(ham_corpus)
ham_text <- tidy_ham %>%
  unnest_tokens(words, text) %>%
  mutate(spam = 0)

spam_corpus <- VCorpus(DirSource(directory = "./spam_2/"))
tidy_spam <- tidy(spam_corpus)
spam_text <- tidy_spam %>%
  unnest_tokens(words, text) %>%
  mutate(spam = 1)

df <- rbind(ham_text, spam_text) %>%
  filter(id != "cmds") %>%
  select(-author, -datetimestamp, -description, -heading, -language, -origin)
df$index <- 1:nrow(df)

training_data <- sample_frac(df, 0.75, replace = FALSE)
holdout_data <- anti_join(df, training_data, by = "index")

############################################################################
rf <- ranger(spam ~ ., data = training_data, write.forest = TRUE)
pred <- predict(rf, data = holdout_data)
table(holdout_data$spam, predictions(pred))
