######## Performance charts - line charts ######## 

#### Get all daily returns
list_daily_returns <- list()
for (i in 1:length(list_assets_2)){
  
  # create xts object with daily returns per asset
  data <- dailyReturn(list_assets_2[[i]])
  #assign(paste0("return_daily_", names(list_assets_2)[i]), data)
  ret <- data.frame(timestamp = format(index(data), format="%Y-%m-%d"),
                    value = data,
                    row.names = seq(1:nrow(data)))
  
  # collect data in a list
  list_daily_returns[[asset_names[i]]] <- ret
  rm(ret)
}

df_daily_returns <- Reduce(function(x, y) merge(x, y, by = "timestamp", all=TRUE), list_daily_returns) 
names(df_daily_returns) <- c("timestamp", names(list_assets_2))


# Add BTC daily returns
df_daily_returns <- merge(x = daily_return_btc, y = df_daily_returns,
                          by = "timestamp", all = TRUE)
names(df_daily_returns)[2] <- "Bitcoin"


#### Lineplot
# Data Range
origin <- Sys.Date() %m-% years(1)
# past year (12months) -> Sys.Date() %m-% years(1)
# past 1 month -> Sys.Date() %m-% months(1)

# No return (= 0%) for traditional assets on weekends
df_daily_returns[,asset_names][is.na(df_daily_returns[asset_names])] <- 0

# Add +1 on all returns
df_daily_returns <- data.frame(timestamp = df_daily_returns$timestamp, 
                               df_daily_returns[,c(2:ncol(df_daily_returns))] + 1)

# get data from origin on to date
df_daily_returns_origin <- df_daily_returns %>% filter(timestamp >= origin)

plot_daily_df <- data.frame(timestamp = df_daily_returns_origin$timestamp,
                            cumprod(df_daily_returns_origin[,-1]) * 100)

# wide to long format
plot_daily_df <- plot_daily_df %>% gather(asset, index, c(names(df_monthly_returns)[-1]))
plot_daily_df$timestamp <- as.Date(plot_daily_df$timestamp)


#### Visualisation
# Linechart for daily development
last_months <- format(as.Date(plot_daily_df$timestamp), format = "%b-%y") %>% 
  unique() %>% 
  length()
end <- plot_daily_df$timestamp 
end <- floor_date(end[length(end)], "month")
start <- end %m-% months(last_months-1)


plot_btc_vs_assets_lines <- ggplot(plot_daily_df, aes(x = as.Date(timestamp), y = index)) + 
  geom_line(aes(color = as.factor(asset)), size = 1) +
  scale_color_manual(values = c("orange", hue_pal()(length(asset_names)))) +
  labs(x = "Time", y = "Value",
       title = "Market Performance: Nominal Returns by Asset Class through Time", 
       subtitle = paste0("Growth of $100 invested over last ", last_months-1 , " months"),
       caption = "Data: Yahoo Finance",
       color = "Asset") +
  scale_x_date(date_labels = "%b-%y", breaks = seq(start, end, by = "2 months")) +
  theme(legend.key.size = unit(0.2, 'cm'),
        legend.key.width= unit(0.5, 'cm'),
        legend.background = element_rect(fill=alpha('grey', 0)),
        legend.title = element_blank()) +
  guides(color = guide_legend(override.aes = list(size = 2) ) )
















