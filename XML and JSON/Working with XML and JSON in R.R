library(XML)
library(jsonlite)

html <- as.data.frame(read_html("books.html") %>% html_table())

xml <- xmlParse(file = "books.xml")
xml <- xmlRoot(xml)
xml <- xmlToDataFrame(xml)

json <- fromJSON("books.json")
json <- json$books
