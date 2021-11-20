############# Chart to show USD M2 money supply and growth ############


######## Data Preparation
data <- data.frame(timestamp = index(M2SL), M2SL, row.names = c(1:length(M2SL)))
colnames(data)[2]<- "m2"

# Calculate YoY-change
data <- data %>% mutate(change=(data$m2-lag(data$m2,12))/lag(data$m2,12)*100)
data$change <- round(data$change,2)
change <- data.frame(data[,c(1,3)])

rm(M2SL)

######## Visualization

#### historic
ggplot(data = data)  + 
  geom_area(aes(x=timestamp, y=change), fill = "grey40") +
  geom_line(aes(x=timestamp, y=m2/1000),stat="identity",color="steel blue", size = 2) +
  scale_y_continuous(labels = c("5%", "10%", "15%", "20%", "25%"),
                     breaks = c(5, 10, 15, 20, 25),
                     name = "YoY-Change",
                     sec.axis = sec_axis(trans=~.*1000, name="in Billions")) +
  scale_x_date(name = "Time") +
  labs(title = "M2 Money Supply of US-Dollars", caption = "FRED St. Louis")


#### more recent

# Passing parameters for the plot
last <- 3 # 2 or 3 years
interval <- 3 # 3 or 6 months

# Set time window
df <- filter(data, timestamp >= data[nrow(data),1] %m-% years(last))
df$format <- format(df$timestamp, format="%b-%y")
df$group <- 1

# Constructing the intervals between x-axis ticks
# For last 2 years -> length.out = 9 for 3 month intervals or length.out = 5 for 6 month intervals
# For last 3 years -> length.out = 13 for 3 month intervals or length.out = 7 for 6 month intervals
if (interval == 3 & last == 2) {
  space <- 9 
} else if (interval == 3 & last == 3) {
  space <- 13
} else if (interval == 6 & last == 2) {
  space <- 5
} else if (interval == 6 & last == 3) {
  space <- 7
}


m2 <- ggplot(df, aes(x=as.factor(timestamp), y=m2, colour=group, group=group)) +
       geom_line(colour = "steel blue", size = 2) +
       scale_y_continuous(name = "in Billions") +
       theme(axis.title.x=element_blank(), axis.ticks.x = element_blank(), axis.text.x=element_blank(),
             legend.position = "none") +
       labs(title = "M2 Money Supply of US-Dollars") 
#m2

change <- ggplot(data = df)  + 
  geom_bar(aes(x=factor(timestamp), y=change/100),stat="identity", size = 0.5) +
  scale_y_continuous(name = "YoY-Change",
                     breaks = c(0.05, 0.1, 0.15, 0.2, 0.25),
                     labels = c("5%", "10%", "15%", "20%", "25%")) +
  scale_x_discrete(breaks = as.character(df$timestamp[seq(1, length(df$timestamp), length.out = space)]), 
                   labels = as.character(df$format[seq(1, length(df$format), length.out = space)]), name = "Time") +
  labs(caption = "Data: FRED St. Louis") 
#change

plot_m2 <- plot_grid(m2, change, ncol = 1, align = "v", rel_heights = c(1,1.1))

