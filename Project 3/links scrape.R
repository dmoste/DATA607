library(rvest)
library(tidyverse)

links <- read.csv("data_science_links.csv", header = FALSE)
names(links) <- c("Link")
links$Link <- as.character(links$Link)

goal <- c()
for(i in 1:length(links$Link)){
  h_text <- read_html(links[i,]) %>%
    html_nodes("li") %>%
    html_text()
  
  for(j in 1:length(h_text)){
    goal <- str_c(goal, h_text[j], sep = " ")
  }
}

goal <- str_extract_all(goal, boundary("word"))
  
big_list <- c()
for(i in 1:length(goal)){
  for(j in 1:length(goal[[i]])){
    big_list <- c(big_list, tolower(goal[[i]][j]))
  }
}

sums <- c()
for(i in 1:length(big_list)){
  sums <- c(sums, sum(big_list == big_list[i]))
}

small_data <- data.frame(big_list, sums)
small_data <- small_data[!duplicated(small_data$big_list), ] %>%
  filter(sums <= 150) %>%
  filter(sums >= 50)
