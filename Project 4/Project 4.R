library(tm)
library(tidytext)
library(ranger)

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
  select(-author, -datetimestamp, -description, -heading, -language, -origin, -id)

sample_size = floor(0.75*nrow(df))
picked = sample(seq_len(nrow(df)),size = sample_size)
training = df[picked,]
holdout = df[-picked,]

############################################################################
rf <- ranger(spam ~ ., data = training, write.forest = TRUE)
pred <- predict(rf, data = holdout)

rounded_pred <- round(predictions(pred))
table(holdout$spam, rounded_pred)
