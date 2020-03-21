# load required packages
library(rvest)
library(tidyverse)
library(tm)
library(SnowballC)

# read in the links that R will scrape from a csv and create column names
links <- read.csv("data_science_links.csv", header = FALSE)
names(links) <- c("Link")
links$Link <- as.character(links$Link)

# scrape the lists from each link and add the text to a single string (textList)
textList <- c()
for(i in 1:length(links$Link)){
  h_text <- read_html(links[i,]) %>%
    html_nodes("li") %>%
    html_text()
  textList <- rbind(textList, h_text)
}

# create VCorpus from textList
commentCorpus <- Corpus(VectorSource(textList))

# manipulte the corpus to remove unwanted information
commentCorpus <- commentCorpus %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(stripWhitespace) %>%
  tm_map(tolower)%>%
  tm_map(removeWords, stopwords("english"))

# find the most used words from the job postings
commentCorpus <-as.matrix(TermDocumentMatrix(commentCorpus))
commentCorpus_wordFreq <-sort(rowSums(commentCorpus), decreasing = TRUE)
toCSV <- commentCorpus_wordFreq[1:200]
toCSV

write.csv(toCSV,"corpus.csv")

data <- read.csv("corpus.csv")
names(data) <- c("words", "count")

data <- data %>%
  filter(count > 50) %>%
  filter(count < 180) %>%
  filter(words != "hiring") %>%
  filter(words != "jobs") %>%
  filter(words != "jobs") %>%
  filter(words != "advice") %>%
  filter(words != "skills") %>%
  filter(words != "help") %>%
  filter(words != "companies") %>%
  filter(words != "find") %>%
  filter(words != "salaries") %>%
  filter(words != "events") %>%
  filter(words != "indeed") %>%
  filter(words != "career") %>%
  filter(words != "employer") %>%
  filter(words != "countries") %>%
  filter(words != "years") %>%
  filter(words != "ability") %>%
  filter(words != "strong") %>%
  filter(words != "sell") %>%
  filter(words != "required") %>%
  filter(words != "using") %>%
  filter(words != "etc") %>%
  filter(words != "lab")

data$averages <- (data$count)/sum(data$count)

ggplot(data, aes(reorder(words, averages), averages)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(x = "Word",
       y = "Count")

