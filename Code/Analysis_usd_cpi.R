################ Linechart of U.S. CPI ###################


######## Data Preparation

# Build a data frame
df <- data.frame(timestamp = index(CPIAUCSL), cpi = CPIAUCSL, row.names = c(1:length(CPIAUCSL)))

# Get relevant timeframe -> last 10 years
df <- df[c((nrow(df)-120):nrow(df)),]

# get CPI value of same month but previous year
df$cpi_lag_12m <- lag(df$CPIAUCSL, n = 12)

# Calculate YoY-change
df$cpi_yoy <- (df$CPIAUCSL / df$cpi_lag_12m) - 1

# drop first 12 rows -> no data for YoY change calculation
df <- df[-c(1:12),]

######## Visualization

top <- as.numeric(format(round(max(df$cpi_yoy), 2), nsmall = 2)) + 0.02
steps <- seq(from = -0.01, to = top, by = 0.01)
number <- as.numeric(format(round(max(df$cpi_yoy), 4), nsmall = 4)) * 100


plot_us_cpi <- ggplot(data = df, aes(x = timestamp, y = cpi_yoy))+
  geom_line(size = 2, color = "darkred") +
  geom_hline(yintercept=0) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     limits = c(-0.01,top),
                     breaks = steps) +
  scale_x_continuous(breaks = seq(ymd('2013-01-01'),ymd('2023-01-01'), by = '1 year'),
                     labels = as.character(c(2013:2023)),
                     limits = c(ymd('2013-01-01'), ymd('2023-01-01'))) +
  labs(x = "Year", y = "CPI Inflation - YoY",
       title = "USA: Consumer Price Index for All Urban Consumers", 
       subtitle = "All Items in U.S. City Average - Monthly Data" ,
       caption = "Data: FRED St. Louis") +
  annotate(geom = "text",
           x = df[nrow(df),1]+180,
           y = df[nrow(df),4] ,
           label = paste0(number, "%"))

