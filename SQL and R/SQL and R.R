# Open up required libraries
library(mice)
library(keyring)
library(DBI)

# Connect to database
con <- dbConnect(RMySQL::MySQL(), dbname = 'star_wars', host = 'localhost', port = 3306, user = 'root', password = keyring::key_get("star_wars", "root"))

# Create the query for all data from the ranking table and get the results of the query
sql = "SELECT * FROM rankings"
ranking_table <- dbGetQuery(con, sql)

# Impute data to correct for missing data; use pmm method
imputed_Data <- mice(ranking_table, m = 5, maxit = 50, method = 'pmm', seed = 500)
ranking_table <- complete(imputed_Data, 2)

# Get averages
averages <- data.frame(1:9, tapply(ranking_table$ranking, ranking_table$movieid, mean))
names(averages) <- c("episode", "ranking")

# Normalize the rankings
averages$ranking <- (-1.125 * averages$ranking) + 11.125

# Create barplot of rankings
barplot(averages$ranking, names.arg = 1:9, main = "Star Wars Rankings",
        sub = "Perfect score = 10", xlab = "Episode", ylab = "Ranking",
        col = "aquamarine1", ylim = c(0,10))
