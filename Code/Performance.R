######## Performance charts - bar charts ######## 

#### Get all monthly returns
list_monthly_returns <- list()
for (i in 1:length(list_assets_2)){
  
  # create xts object with monthly returns per asset
  data <- monthlyReturn(list_assets_2[[i]])
  #assign(paste0("return_monthly_", names(list_assets_2)[i]), data)
  ret <- data.frame(timestamp = format(index(data), format="%Y-%m"),
                    value = data,
                    row.names = seq(1:nrow(data)))
  
  # collect data in a list
  list_monthly_returns[[asset_names[i]]] <- ret
  rm(ret)
}

df_monthly_returns <- Reduce(function(x, y) merge(x, y, by = "timestamp", all=TRUE), list_monthly_returns) 
names(df_monthly_returns) <- c("timestamp", names(list_assets_2))


# Add BTC monthly returns
df_monthly_returns <- merge(x = monthly_return_btc, y = df_monthly_returns,
                            by = "timestamp", all = TRUE)
names(df_monthly_returns)[2] <- "Bitcoin"



######## Calculations

#### Barplot
plot_monthly_df <- data.frame(asset = names(df_monthly_returns)[-1],
                              return = c(t(df_monthly_returns[nrow(df_monthly_returns)-1,c(2:length(df_monthly_returns))])),
                              orange = c(1,rep(0,length(asset_names)))
                              )



######## Visualization

#### Barplot of monthly return comparison
time <- rownames(monthly_return_btc)[nrow(monthly_return_btc)-1] %>% 
  as.Date() %>% 
  format(format =  "%B %Y")

plot_btc_vs_assets_bars <- ggplot(data=plot_monthly_df, aes(x=reorder(asset, -return), y=return, fill = as.factor(orange))) +
  geom_bar(stat="identity") +
  theme(legend.position="none") +
  scale_fill_manual(values = c("steelblue", "orange")) +
  labs(x = "Asset", y = "Return",
       title = "Market Performance: Returns by Asset Class", 
       subtitle = time,
       caption = "Data: Yahoo Finance") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))


