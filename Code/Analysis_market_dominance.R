##################### Bitcoin Market Dominance ##################



# put the first 50 and the second 50 together
df_raw <- rbind(cryptos_1, cryptos_2)

# keep relevant columns
df3 <- df3_raw[,c(1,4,12)]


######## Data Preparation

# separate Bitcoin from Altcoins
bitcoin <- df3 %>% filter(name == "Bitcoin")
alts <- df3 %>% filter(name != "Bitcoin")

# calculate aggregate market cap of altcoins for each date
alts_marketcap <- alts %>% group_by(timestamp) %>% summarise(market_cap = sum(market_cap))
alts_marketcap <- data.frame(timestamp = alts_marketcap$timestamp, 
                             alts_marketcap = alts_marketcap$market_cap)

# Convert to date
bitcoin$timestamp <- as.Date(bitcoin$timestamp)
alts_marketcap$timestamp <- as.Date(alts_marketcap$timestamp)

# Calculate market dominance
df_plot <- merge(bitcoin, alts_marketcap, by = "timestamp")
df_plot$market_dom <- bitcoin$market_cap / (alts_marketcap$alts_marketcap + bitcoin$market_cap)


######## Visualization

plot_market_dominance <- ggplot(data = df_plot, aes(x = timestamp, y = market_dom)) +
  geom_line(size = 2, colour = "orange") +
  labs(title = paste0("Bitcoin Market Dominance - ", format(Sys.Date(), format = "%B")), 
       x = "Time", y = "Market Dominance" ,
       subtitle = "Bitcoin market share among top 100 cryptocurrencies",
       caption = "Note: Only active coins included. Delisted coins are ignored. \n Data: www.coinmarketcap.com") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_date(date_labels = "%b-%y") +
  annotate(geom = "text", x = df_plot[nrow(df_plot),1], y = round(df_plot[nrow(df_plot),5], 2) + 0.02, 
           label = paste0(round(df_plot[nrow(df_plot),5]*100, 2), "%"))

