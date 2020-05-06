library(rvest)
library(ggplot2)
library(tidyverse)

url <- "https://data.nysed.gov/essa.php?instid=800000077852&year=2019&createreport=1&regents=1"

regents_html <- url %>%
  read_html() %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)

ela_html <- regents_html[[1]]
algebra1_html <- regents_html[[2]]
geometry_html <- regents_html[[3]]
algebra2_html <- regents_html[[4]]
global_html <- regents_html[[5]]
living_html <- regents_html[[6]]
earth_html <- regents_html[[7]]
chemistry_html <- regents_html[[8]]
physics_html <- regents_html[[9]]
us_html <- regents_html[[11]]

small <- c(ela_html,algebra1_html,geometry_html,
                 algebra2_html,global_html,us_html)

big <- c(living_html,earth_html,chemistry_html,physics_html)


## this shit is messy...
names(ela_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                 "Number 3","Level 3","Number 4","Level 4",
                 "Number 5","Level 5","Number Prof","Proficient")
names(algebra1_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                     "Number 3","Level 3","Number 4","Level 4",
                     "Number 5","Level 5","Number Prof","Proficient")
names(geometry_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                     "Number 3","Level 3","Number 4","Level 4",
                     "Number 5","Level 5","Number Prof","Proficient")
names(algebra2_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                     "Number 3","Level 3","Number 4","Level 4",
                     "Number 5","Level 5","Number Prof","Proficient")
names(global_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                     "Number 3","Level 3","Number 4","Level 4",
                     "Number 5","Level 5","Number Prof","Proficient")
names(us_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                     "Number 3","Level 3","Number 4","Level 4",
                     "Number 5","Level 5","Number Prof","Proficient")
names(living_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                    "Number 3","Level 3","Number 4","Level 4",
                    "Number Prof","Proficient")
names(earth_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                        "Number 3","Level 3","Number 4","Level 4",
                        "Number Prof","Proficient")
names(chemistry_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                        "Number 3","Level 3","Number 4","Level 4",
                        "Number Prof","Proficient")
names(physics_html) <- c("Subgroup","Tested","Number 1","Level 1","Number 2","Level 2",
                        "Number 3","Level 3","Number 4","Level 4",
                        "Number Prof","Proficient")


regents_csv <- read.csv("https://github.com/dmoste/DATA607/raw/master/Final/Grades.csv", header = TRUE)

math1 <- inner_join(algebra1_html, algebra2_html, by = "Subgroup")
math1 <- inner_join(math1,geometry_html, by = "Subgroup")

physics_html[2,4]

html_data <- c()
for(html in small){
  print(html)
  html_data <- rbind(html[2,4])
}
