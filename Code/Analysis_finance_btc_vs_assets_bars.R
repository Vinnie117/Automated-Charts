######## Barplots of Performances: Bitcoin vs other asset classes ########

# Function to create plot
# - title changes dynamically
# - case_when() cannot be used in the main for-loop to fill plotlist bc it does not take S3 objects (ggplot) on RHS as input
barchart <- function(){
  
  # Month annotation in subtitle
  #time <- rownames(monthly_return_btc)[nrow(monthly_return_btc)-1] %>% 
  #  as.Date() %>% 
  #  format(format =  "%B %Y")
  
  
  time <- df_monthly_returns[nrow(df_monthly_returns)-1,1] %>%
    paste("-01",sep="") %>% 
    as.Date() %>%
    format(format =  "%B %Y")
  
  
  
  
  ggplot(data=plot_monthly_df, aes(x=reorder(asset, -return), y=return, fill = as.factor(orange))) +
    geom_bar(stat="identity") +
    theme(legend.position="none") +
    scale_fill_manual(values = c("steelblue", "orange")) +
    labs(x = "Asset", y = "Return",
         title = paste0(case_when(names(list_asset_names)[i] =="index_names" ~ "Bitcoin vs. Major Stock Indexes" ,
                                  names(list_asset_names)[i] =="em_names" ~ "Bitcoin vs. Stocks Emerging Markets",
                                  names(list_asset_names)[i] =="dm_names" ~ "Bitcoin vs. Stocks Developed Markets",
                                  names(list_asset_names)[i] =="commodities_names" ~ "Bitcoin vs. Commodities"),
                        ": Market Performance"), 
         subtitle = time,
         caption = "Data: Yahoo Finance") +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1))
}

#### Data Handling

# initiate empty list which will contain all the plots
list_barplots_btc_vs_assets <- list()

# For each asset mix
for(i in 1:length(list_asset_names)){
  
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
  # fill the list with single charts 
  list_barplots_btc_vs_assets[[i]] <- barchart()
  
  names(list_barplots_btc_vs_assets)[[i]] <- paste0("barplot_btc_vs_", names(list_asset_codes[i]))

}

list_barplots_btc_vs_assets[1]
list_barplots_btc_vs_assets[2]
list_barplots_btc_vs_assets[3]
list_barplots_btc_vs_assets[4]
