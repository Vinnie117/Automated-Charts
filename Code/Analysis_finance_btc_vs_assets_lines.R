######## Linecharts of Performances: Bitcoin vs other asset classes ########


#### Data Handling

# initiate empty list which will contain all the plots
list_linecharts_btc_vs_assets <- list()


for(i in 1:length(list_asset_names)){
  
  # fetch data from quantmod and put into list of xts with price data
  dataprep(get(names(list_asset_codes)[i]), get(names(list_asset_names)[i]))
  
  # this list will contain data frames of daily returns
  list_daily_returns <- list()
  
  # get all daily returns
  get_daily_return(list_asset_names[[i]])
  
  # Prepare data suitable for ggplot2
  # Data Range
  # past year (12months) -> Sys.Date() %m-% years(1)
  # past 1 month -> Sys.Date() %m-% months(1)
  origin <- Sys.Date() %m-% years(1)

  # No return (= 0%) for traditional assets on weekends
  df_daily_returns[,list_asset_names[[i]]][is.na(df_daily_returns[list_asset_names[[i]]])] <- 0
  
  # Add +1 on all returns
  df_daily_returns <- data.frame(timestamp = df_daily_returns$timestamp, 
                                 df_daily_returns[,c(2:ncol(df_daily_returns))] + 1)
  
  # get data from origin on to date
  df_daily_returns_origin <- df_daily_returns %>% filter(timestamp >= origin)
  
  plot_daily_df <- data.frame(timestamp = df_daily_returns_origin$timestamp,
                              cumprod(df_daily_returns_origin[,-1]) * 100)
  
  # wide to long format
  plot_daily_df <- plot_daily_df %>% gather(asset, index, c(names(df_daily_returns)[-1]))
  plot_daily_df$timestamp <- as.Date(plot_daily_df$timestamp)
  
  
  
  
  # Visualization
  last_months <- format(as.Date(plot_daily_df$timestamp), format = "%b-%y") %>% 
    unique() %>% 
    length()
  end <- plot_daily_df$timestamp 
  end <- floor_date(end[length(end)], "month")
  start <- end %m-% months(last_months-1)
  
  list_linecharts_btc_vs_assets[[i]] <- ggplot(plot_daily_df, aes(x = as.Date(timestamp), y = index)) + 
    geom_line(aes(color = as.factor(asset)), size = 1) +
    scale_color_manual(values = c("orange", hue_pal()(length(list_asset_names[[i]])))) +
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
  
  
  names(list_linecharts_btc_vs_assets)[[i]] <- paste0("linechart_btc_vs_", names(list_asset_codes[i]))
  
}



















