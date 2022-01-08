############# A Barchart for Monthly Bitcoin Market Cap #############


######## Data Preparation
# keep relevant data: timestamp and market cap (column 12)
df <- btc_historic_raw[,c(1,12)]

# time stamp formatting
df$timestamp <- substr(df$timestamp,1,10) %>% as.Date()

# end of month
eom <- seq(as.Date("2013-05-1"),length=1000,by="months")-1
df <- df %>% filter(timestamp %in% eom)

# Last 13 months (for MoM-Change)
df <- df[c((nrow(df)-13):nrow(df)),]

# Change in market cap
df <- df %>% mutate(delta = market_cap - lag(market_cap))

# % Change in market cap
df <- df %>% mutate(delta_percent = round((market_cap / lag(market_cap)-1) * 100, 2))

# format label
df$delta_percent <- ifelse(df$delta_percent >= 0, paste0("+", df$delta_percent),df$delta_percent)
df$delta_percent <- paste0(df$delta_percent, "%")


######## Visualization

# Last 12 months relevant for visualization
df <- df[c((nrow(df)-12):nrow(df)),]

months <- format(df$timestamp, format="%b-%y")
months <- months[seq(1, length(months), 2)]
month_breaks <- as.factor(df$timestamp[seq(1, length(df$timestamp), by = 2)])

# every second label

plot_btc_market_cap <- ggplot(data = df, aes(x = as.factor(timestamp), y = market_cap)) +
  geom_bar(stat = "identity", fill = "orange") +
  scale_x_discrete(labels = months,
                   breaks = month_breaks) +
  scale_y_continuous(labels = unit_format(unit = "T", scale = 1e-12, accuracy = 0.1),
                     breaks = seq(0,1e+13, by = 2e+11)) +
  geom_text(aes(x=as.factor(timestamp), y=market_cap+35000000000, label=delta_percent),
            size = 2.75) +
  labs(x = "Date", y = "in Trillions",
       title = "Bitcoin Market Cap - End of Month", 
       subtitle = "Including MoM-Change" ,
       caption = "Data: www.coinmarketcap.com")



























