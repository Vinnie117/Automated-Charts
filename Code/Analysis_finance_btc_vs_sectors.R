######## vertical barchart with monthly performance of BTC vs stock sectors ########


#### Get all monthly returns
list_monthly_returns <- list()
for (i in 1:length(list_assets_sectors)){
  
  # create xts object with monthly returns per asset
  data <- monthlyReturn(list_assets_sectors[[i]])
  #assign(paste0("return_monthly_", names(list_assets_sectors)[i]), data)
  ret <- data.frame(timestamp = format(index(data), format="%Y-%m"),
                    value = data,
                    row.names = seq(1:nrow(data)))
  
  # collect data in a list
  list_monthly_returns[[sectors_names[i]]] <- ret
  rm(ret)
}

df_monthly_returns <- Reduce(function(x, y) merge(x, y, by = "timestamp", all=TRUE), list_monthly_returns) 
names(df_monthly_returns) <- c("timestamp", sectors_names)


# Add BTC monthly returns
df_monthly_returns <- merge(x = monthly_return_btc, y = df_monthly_returns,
                            by = "timestamp", all = TRUE)
names(df_monthly_returns)[2] <- "Bitcoin"



######## Calculations

#### Barplot
plot_monthly_df <- data.frame(asset = names(df_monthly_returns)[-1],
                              return = c(t(df_monthly_returns[nrow(df_monthly_returns)-1,c(2:length(df_monthly_returns))])),
                              orange = c(1,rep(0,length(sectors_names)))
)


# For stock market sectors (11 bars!) 
# vertical plot: 600 x 800 fits for Twitter mobile! (vertical image)
time <- rownames(monthly_return_btc)[nrow(monthly_return_btc)-1] %>% 
  as.Date() %>% 
  format(format =  "%B %Y")

plot_btc_vs_sectors <- ggplot(data=plot_monthly_df, aes(x=reorder(asset, return), y=return, fill = as.factor(orange))) +
  geom_bar(stat="identity") +
  theme(legend.position="none",
        axis.title.y=element_blank(),
        axis.text=element_text(size=11)) +
  scale_fill_manual(values = c("steelblue", "orange")) +
  labs(x = "", y = "Return",
       title = "Market Performance: Returns by Asset Class", 
       subtitle = time,
       caption = "Data: Yahoo Finance") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  coord_flip()
                                   

