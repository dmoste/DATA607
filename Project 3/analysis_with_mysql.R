library(keyring)
library(RMySQL)
library(tidyverse)

con <- dbConnect(RMySQL::MySQL(), dbname = 'project_3', host = 'localhost', port = 3306, user = 'root', password = keyring::key_get("project_3","root"))

sql <- "SELECT * FROM indeed1"
res <- dbGetQuery(con, sql)

data <- res %>%
  filter(count > 100) %>%
  filter(token != "hiring") %>%
  filter(token != "jobs") %>%
  filter(token != "jobs") %>%
  filter(token != "advice") %>%
  filter(token != "skills") %>%
  filter(token != "help") %>%
  filter(token != "companies") %>%
  filter(token != "find") %>%
  filter(token != "salaries") %>%
  filter(token != "events") %>%
  filter(token != "indeed") %>%
  filter(token != "career") %>%
  filter(token != "employer") %>%
  filter(token != "countries") %>%
  filter(token != "years") %>%
  filter(token != "ability") %>%
  filter(token != "strong") %>%
  filter(token != "sell") %>%
  filter(token != "required") %>%
  filter(token != "using") %>%
  filter(token != "etc") %>%
  filter(token != "lab") %>%
  filter(token != "working")
               
data$averages <- (data$count)/sum(data$count)

ggplot(data, aes(reorder(token, averages), averages)) +
 geom_bar(stat = "identity") +
 coord_flip() +
 labs(x = "Word",
      y = "Count")
