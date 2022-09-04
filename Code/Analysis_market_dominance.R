##################### Bitcoin Market Dominance ##################



# put the first 50 and the second 50 together
df_raw <- rbind(cryptos_1, cryptos_2)

# keep relevant columns
df <- df_raw[,c(1,4,12)]


######## Data Preparation

# separate Bitcoin from Altcoins
bitcoin <- df %>% filter(name == "Bitcoin")
alts <- df %>% filter(name != "Bitcoin")

# clean the data frame
bitcoin <- select(bitcoin, -name)
colnames(bitcoin)[2] <- "btc_market_cap"

# calculate aggregate market cap of altcoins for each date
alts_marketcap <- alts %>% group_by(timestamp) %>% summarise(market_cap = sum(market_cap))
alts_marketcap <- data.frame(timestamp = alts_marketcap$timestamp, 
                             alts_marketcap = alts_marketcap$market_cap)

# Convert to date
bitcoin$timestamp <- as.Date(bitcoin$timestamp)
alts_marketcap$timestamp <- as.Date(alts_marketcap$timestamp)

# Calculate market dominance
df_plot <- merge(bitcoin, alts_marketcap, by = "timestamp")
df_plot$market_dom <- bitcoin$btc_market_cap / (alts_marketcap$alts_marketcap + bitcoin$btc_market_cap)

# start and end of the plotted time series
# current date
date_current <- as.Date(format(Sys.Date()))
date_current_floor <- floor_date(date_current, "month")

date_end <- date_current %m+% months(1)   
date_start <- date_current_floor %m-% months(12) 
df_plot <- df_plot[df_plot$timestamp > date_start-1 & df_plot$timestamp < date_end, ]

######## Visualization


plot_market_dominance <- ggplot(data = df_plot, aes(x = timestamp, y = market_dom)) +
  geom_line(size = 2, colour = "orange") +
  labs(title = paste0("Bitcoin Market Dominance - on ", format(Sys.Date(), format = "%B %d, %Y")), 
       x = "Time", y = "Market Dominance" ,
       subtitle = "Bitcoin market share among top 100 cryptocurrencies",
       caption = "Note: Only active coins included. Delisted coins are ignored. \n Data: www.coinmarketcap.com") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0.4, 0.51)) +
  scale_x_date(date_labels = "%b-%y") +
  annotate(geom = "text", x = df_plot[nrow(df_plot),1], y = round(df_plot[nrow(df_plot),4], 2) + 0.015, 
           label = paste0(round(df_plot[nrow(df_plot),4]*100, 2), "%"), colour = "black")





