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

#### Functions

# waiting between two API calls
wait <- function(seconds){
  
    for (i in 1:seconds){
    text <- paste0("Waiting between API Calls: ", i, " seconds of ", seconds)
    print(text)
    Sys.sleep(1)
  }
}


#### Loading data

# all active coins
coins <- crypto_list(only_active=TRUE)

# historical Bitcoin prices
btc_historic_raw <- crypto_history(coins, limit=1, start_date="20130430")
#wait(70)

# Fetch data from FRED
getSymbols('M2SL',src='FRED')



#### Data Preparation

# select relevant data
df_btc <- btc_historic_raw[,c(1,10)]

# only keep the day date without time
df_btc$timestamp <- substr(df_btc$timestamp,1,10) %>% as.Date()
















