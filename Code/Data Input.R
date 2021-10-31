########## Data Input ##########

Sys.setlocale("LC_TIME", "English")

# Libraries
library(crypto2)
library(tidyverse)
library(readxl)
library(quantmod)
library(reshape2)
library(lubridate)
library(quantmod)
library(cowplot)

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

# Fetch data from FRED
getSymbols('M2SL',src='FRED')



#### Data Preparation

# select relevant data
df_btc <- btc_historic_raw[,c(1,10)]

# only keep the day date without time
df_btc$timestamp <- substr(df_btc$timestamp,1,10) %>% as.Date()



















