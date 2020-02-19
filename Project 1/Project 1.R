library(tidyverse)

txt_data_frame <- read.delim("tournamentinfo.txt", stringsAsFactors = FALSE)

players_1 <- txt_data_frame[,1][c(str_detect(txt_data_frame[,1],"^ {3,4}\\d"))]
players_2 <- txt_data_frame[,1][c(str_detect(txt_data_frame[,1],"^ {3}[^ \\d]"))]

player_numbers <- as.numeric(str_extract(players_1, ".\\d "))
player_names <- str_trim(str_sub(str_extract(players_1, "\\|.{32}"),3))
total_points <- as.numeric(str_extract(players_1, "\\d\\.\\d"))

state <- str_sub(str_extract(players_2, ".. \\|"),1,2)
pre_ranking <- str_trim(str_sub(str_extract(players_2, "(R: ....P..)|(R: ....)"),4))
pre_ranking <- str_replace(pre_ranking,"P","\\.")
pre_ranking <- as.numeric(pre_ranking)

matches <- data.frame(str_extract_all(players_1,"[WLDHXBU]  .{2}\\|"))
matches <- data.frame(t(matches))
names(matches) <- c("m1","m2","m3","m4","m5","m6","m7")

m1 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m1,2,-2)))]
m2 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m2,2,-2)))]
m3 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m3,2,-2)))]
m4 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m4,2,-2)))]
m5 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m5,2,-2)))]
m6 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m6,2,-2)))]
m7 <- pre_ranking[as.numeric(str_trim(str_sub(matches$m7,2,-2)))]

matches <- data.frame(m1,m2,m3,m4,m5,m6,m7)
opposition <- c(rowMeans(matches[1:7], na.rm = TRUE))
opposition <- round(opposition, digits = 0)

chess <- data.frame(player_names, state, total_points, pre_ranking, opposition)

ggplot(chess, aes(pre_ranking, total_points)) +
  geom_point(aes(color = opposition)) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Pre-ranking",
       y = "Total Points (post-tournament)",
       color = "Opposition\nRanking")

write.csv(chess, "chess.csv")
