library(mongolite)

attendance <- read.csv("attendance.csv", header = TRUE)

my_collection = mongo(collection = "attendance", db = "final")
my_collection$remove('{}')
my_collection$insert(attendance)