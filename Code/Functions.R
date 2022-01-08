########## Functions ##########

####
# waiting between two API calls, otherwise API limit is triggered
wait <- function(seconds){
  
  for (i in 1:seconds){
    text <- paste0("Waiting between API Calls: ", i, " seconds of ", seconds)
    print(text)
    Sys.sleep(1)
  }
}

####
# some data handling of quantmod data from Yahoo Finance
dataprep <- function(x, y){
  
  # empty list in global environment to be filled
  list_assets_2 <<- list()
  
  # 4th column contains closing prices
  for (i in 1:length(x)){
    list_assets_2[[i]] <<- na.locf(get(x[i])[,4])       
  }
  names(list_assets_2) <<- y
}

####
# some data handling of quantmod data from Yahoo Finance, need a separate one for sector plot (really?)
dataprep_sectors <- function(x){
  
  # empty list in global environment to be filled
  list_assets_sectors <<- list()
  
  # 4th column contains closing prices
  for (i in 1:length(x)){
    list_assets_sectors[[i]] <<- na.locf(get(x[i])[,4])       
  }
  names(list_assets_sectors) <<- sectors_names
}

####
# Function to create a data frame of monthly returns from a list of xts objects with prices
get_monthly_return <- function(x){
  
  # Iterate over a list of zoo objects with (monthly) price data
  for (i in 1:length(list_assets_2)){
    
    # create xts object with monthly returns per asset
    data <- monthlyReturn(list_assets_2[[i]])
    #assign(paste0("return_monthly_", names(list_assets_2)[i]), data)
    ret <- data.frame(timestamp = format(index(data), format="%Y-%m"),
                      value = data,
                      row.names = seq(1:nrow(data)))
    
    # collect data in a list
    list_monthly_returns[[x[i]]] <<- ret
    rm(ret)
  }
  
  df_monthly_returns <<- Reduce(function(x, y) merge(x, y, by = "timestamp", all=TRUE), list_monthly_returns) 
  names(df_monthly_returns) <<- c("timestamp", names(list_assets_2))
  
  
  # Add BTC monthly returns
  df_monthly_returns <<- merge(x = monthly_return_btc, y = df_monthly_returns,
                               by = "timestamp", all = TRUE)
  names(df_monthly_returns)[2] <<- "Bitcoin"
}

####
# Function to create a data frame of daily returns from a list of xts objects with prices
get_daily_return <- function(x){
  for (i in 1:length(list_assets_2)){
    
    # create xts object with daily returns per asset
    data <- dailyReturn(list_assets_2[[i]])
    #assign(paste0("return_daily_", names(list_assets_2)[i]), data)
    ret <- data.frame(timestamp = format(index(data), format="%Y-%m-%d"),
                      value = data,
                      row.names = seq(1:nrow(data)))
    
    # collect data in a list
    list_daily_returns[[x[i]]] <<- ret
    rm(ret)
  }
  
  df_daily_returns <<- Reduce(function(x, y) merge(x, y, by = "timestamp", all=TRUE), list_daily_returns) 
  names(df_daily_returns) <<- c("timestamp", names(list_assets_2))
  
  
  # Add BTC daily returns
  df_daily_returns <<- merge(x = daily_return_btc, y = df_daily_returns,
                             by = "timestamp", all = TRUE)
  names(df_daily_returns)[2] <<- "Bitcoin"
}

















