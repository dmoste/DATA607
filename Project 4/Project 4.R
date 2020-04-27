# load libraries
library(tm)
library(tidytext)
library(ranger)

# create the ham corpus and unnest
ham_corpus <- VCorpus(DirSource(directory = "./easy_ham/"))
tidy_ham <- tidy(ham_corpus)
ham_text <- tidy_ham %>%
  unnest_tokens(words, text) %>%
  mutate(spam = 0)

# create the spam corpus and unnest
spam_corpus <- VCorpus(DirSource(directory = "./spam_2/"))
tidy_spam <- tidy(spam_corpus)
spam_text <- tidy_spam %>%
  unnest_tokens(words, text) %>%
  mutate(spam = 1)

# combine dataframes
df <- rbind(ham_text, spam_text) %>%
  filter(id != "cmds") %>%
  select(-author, -datetimestamp, -description, -heading, -language, -origin, -id)

# create traing and holdout data
sample_size = floor(0.75*nrow(df))
picked = sample(seq_len(nrow(df)),size = sample_size)
training = df[picked,]
holdout = df[-picked,]

# build model
rf <- ranger(spam ~ ., data = training, write.forest = TRUE)
pred <- predict(rf, data = holdout)
rounded_pred <- round(predictions(pred))

# show model results
table(holdout$spam, rounded_pred)
