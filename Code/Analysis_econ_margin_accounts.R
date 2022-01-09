########## Security Brokers and Dealers; Margin Accounts at Brokers and Dealers; Asset, Level ##########

# first date of the current year -> rolling time window
current_start <- as.Date(paste0(format(Sys.Date(), "%Y"),"-01-01"))
# start and end of the plotted time series
x_end <- current_start %m+% years(1)   
x_start <- current_start %m-% years(10) 

df <- data.frame(timestamp = as.Date(index(BOGZ1FL663067003Q)), BOGZ1FL663067003Q)
colnames(df)[2] <- "margin_level"

# indexation to 100 at beginning of analysis
df_plot <- filter(df, timestamp >= x_start) %>% mutate(margin_level_indexed = margin_level / df[rownames(df) == x_start,2] * 100)




#### Visualization

# with indexed value
ggplot(data = df_plot, aes(x = timestamp, y = margin_level_indexed)) +
  geom_line() +
  scale_x_continuous(breaks = seq(x_start,x_end, by = '1 year'),
                     labels = as.character(c(format(x_start, "%Y"):format(x_end, "%Y"))),
                     limits = c(x_start, x_end)) +
  labs(title = "Margin Accounts at Brokers and Dealers", x = "Time", y = paste0(x_start," indexed at 100"),
       subtitle = "Quartlery Level Data", caption = "Data: FRED St. Louis") 


# with levels 
df_plot <- filter(df, timestamp >= x_start)

plot_margin_accounts <- ggplot(data = df_plot, aes(x = timestamp, y = margin_level)) +
  geom_line(size = 2, colour = "darkred") +
  scale_x_continuous(breaks = seq(x_start,x_end, by = '1 year'),
                     labels = as.character(c(format(x_start, "%Y"):format(x_end, "%Y"))),
                     limits = c(x_start, x_end)) +
  labs(title = "Margin Accounts at Brokers and Dealers", x = "Time", y = "US-Dollar",
       subtitle = "Quartlery Level Data", caption = "Data: FRED St. Louis") +
  scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-3),
                     limits = c(floor(min(df_plot[,2])/100000) * 100000, 
                                ceiling(max(df_plot[,2])/ 100000) * 100000)) +
  annotate(geom = "text",
           x = as.Date("2022-01-01"),
           y = df_plot[nrow(df_plot),2],
           label = paste0(substr(df_plot[nrow(df_plot),2], 1, 3), "B"))



