########## Data Input ##########

Sys.setlocale("LC_TIME", "English")

# Libraries
library(crypto2)           # API to www.coinmarketcap.com to get price data
library(tidyverse)         # multiple libraries for R, e.g. ggplot2, dplyr, ...
library(readxl)            # reading / writing Excel files
library(quantmod)          # package can query some finance / economics websites for data, e.g. FRED
library(reshape2)          # data frame formatting, e.g. format data frame from long to wide
library(lubridate)         # tidyverse package to work with dates and times
library(cowplot)           # to arrange plots in a grid
library(scales)            # to edit ggplot2 scales

#### Functions

# waiting between two API calls, otherwise API limit is triggered
wait <- function(seconds){
  
    for (i in 1:seconds){
    text <- paste0("Waiting between API Calls: ", i, " seconds of ", seconds)
    print(text)
    Sys.sleep(1)
  }
}


#### Loading data

# all active coins
list_coins <- crypto_list(only_active=TRUE)

# historical Bitcoin data: prices, volume, market cap
btc_historic_raw <- crypto_history(list_coins, limit=1, start_date="20130430")
wait(65)

# sorted market caps of crypto
# Set the date: get start and end date of analysis
origin <- Sys.Date() %m-% years(1) %>% format(format = "%Y%m%d")
crypto_ranks <- list_coins[order(list_coins$rank),] 
# top 100 coins -> need to split, otherwise API limit is triggered (Max possible: 84 -> then HTTP error)
crypto_ranks_1 <- crypto_ranks[1:50,]   
crypto_ranks_2 <- crypto_ranks[51:100,] 
# Calling API two times
cryptos_1 <- crypto_history(coin_list = crypto_ranks_1, start_date = origin)
wait(65)
cryptos_2 <- crypto_history(coin_list = crypto_ranks_2, start_date = origin)

# Fetch data from FRED
getSymbols('M2SL',src='FRED')



#### Data Preparation

# select relevant data
df_btc <- btc_historic_raw[,c(1,10)]

# only keep the day date without time
df_btc$timestamp <- substr(df_btc$timestamp,1,10) %>% as.Date()
















