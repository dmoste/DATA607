# Acquire data
cable_data <- data.frame(read.csv("media-mentions-2020/cable_weekly.csv"))
online_data <- data.frame(read.csv("media-mentions-2020/online_weekly.csv"))

# Get just the date, name, and mention data
all_data <- data.frame(cable_data$date, cable_data$name, cable_data$pct_of_all_candidate_clips, online_data$pct_of_all_candidate_stories)
names(all_data) <- c("Date","Name","Clips","Stories")

# Subset to just Joe Biden
all_biden <- subset(all_data, Name == "Joe Biden")
all_biden$Date <- as.Date(all_biden$Date)

#Examine plot of entire timeline
plot(all_biden$Date, all_biden$Clips + all_biden$Stories, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")

# Subset data to narrow timeline to just 2019
all_biden <- subset(all_biden, Date >= "2019-01-01")

plot(all_biden$Date, all_biden$Clips, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")
plot(all_biden$Date, all_biden$Stories, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")
plot(all_biden$Date, all_biden$Clips + all_biden$Stories, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")

# Subset data to narrow timeline to September and later
all_biden <- subset(all_biden, Date >= "2019-09-01")

plot(all_biden$Date, all_biden$Clips, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")
plot(all_biden$Date, all_biden$Stories, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")
plot(all_biden$Date, all_biden$Clips + all_biden$Stories, type = "l", main = "Biden in the Media", xlab = "Date", ylab = "% of Mentions")
