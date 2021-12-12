######## Barplots of Performances: Bitcoin vs other asset classes ########

# collect data from "Data Input.R" in lists -> can be put to "Data Input.R"
list_asset_names <- list(index_names = index_names, em_names = em_names, dm_names = dm_names, 
                         commodities_names = commodities_names)
list_asset_codes <- list(index = index, em = em, dm = dm, commodities = commodities)


#### Data Handling

# initiate empty list which will contain all the plots
list_barplots_btc_vs_assets <- list()


for(i in 1:length(list_asset_names)){
  
  # each single asset of the mix
  for(j in 1:length(list_asset_codes[[1]])){
    # get all data from yahoo finance
    getSymbols(list_asset_codes[[i]][j], src="yahoo")
  }
  
  # fetch data from quantmod and put into list of xts with price data
  dataprep(get(names(list_asset_codes)[i]), get(names(list_asset_names)[i]))
  
  # this list will contain data frames of monthly returns
  list_monthly_returns <- list()
  
  # get all monthly returns
  get_monthly_return(list_asset_names[[i]])
  
  # prepare data suitable for ggplot2
  plot_monthly_df <- data.frame(asset = names(df_monthly_returns)[-1],
                                return = c(t(df_monthly_returns[nrow(df_monthly_returns)-1,c(2:length(df_monthly_returns))])),
                                orange = c(1,rep(0,length(list_assets_2))))
  
  
  # Visualization
  time <- rownames(monthly_return_btc)[nrow(monthly_return_btc)-1] %>% 
    as.Date() %>% 
    format(format =  "%B %Y")
  
  list_barplots_btc_vs_assets[[i]] <- ggplot(data=plot_monthly_df, aes(x=reorder(asset, -return), y=return, fill = as.factor(orange))) +
    geom_bar(stat="identity") +
    theme(legend.position="none") +
    scale_fill_manual(values = c("steelblue", "orange")) +
    labs(x = "Asset", y = "Return",
         title = "Market Performance: Returns by Asset Class", 
         subtitle = time,
         caption = "Data: Yahoo Finance") +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1))
  
  names(list_barplots_btc_vs_assets)[[i]] <- paste0("barplot_btc_vs_", names(list_asset_codes[i]))

}




###############################
