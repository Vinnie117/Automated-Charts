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
library(viridis)           # for colour scales
library(ggdark)            # for dark mode in ggplots


#### Loading data

# all active coins
list_coins <- crypto_list(only_active=TRUE)
# Data of crypto, sorted by market cap
crypto_ranks <- list_coins[order(list_coins$rank),] 

# top 100 coins -> need to split, otherwise API limit is triggered (Max possible: 84 -> then HTTP error)
crypto_ranks_1 <- crypto_ranks[1:50,]   
crypto_ranks_2 <- crypto_ranks[51:100,] 

# Calling API two times
cryptos_1 <- crypto_history(coin_list = crypto_ranks_1, start_date = "20130430")
wait(65)
cryptos_2 <- crypto_history(coin_list = crypto_ranks_2, start_date = "20130430")


# Fetch data from FRED
getSymbols('M2SL',src='FRED')
getSymbols('CPIAUCSL',src='FRED')
getSymbols('BOGZ1FL663067003Q',src='FRED')


# Specify assets from Yahoo Finance loadad by quantmod
# (names without spaces!)
# all vectors MUST have same length!
commodities_names <- c("Gold", "Silver", "Copper", "Nat_Gas", "Lumber", "Crude_Oil", "Carbon")
commodities <- c("GC=F", "SI=F", "HG=F", "NG=F", "LBS=F", "CL=F", "KRBN")

em_names <- c("China", "Brazil", "Russia", "India", "S.Korea", "S.Africa", "EmergingMarkets")
em <- c("MCHI", "EWZ", "ERUS", "INDA", "EWY", "EZA", "EEM")

dm_names <- c("World", "Japan", "Germany", "France", "UK", "Canada", "Italy")
dm <- c("URTH", "EWJ", "EWG", "EWQ", "EWU", "EWC", "EWI")

index_names <- c("SP500", "Nasdaq100", "Russell2000", "EuroStoxx50", "Dax40" ,"Nikkei225", "FTSE100" )
index <- c("SPY", "QQQ", "IWM", "EXW1.DE", "EXS1.DE", "1329.T", "ISFA.AS")


list_asset_names <- list(index_names = index_names, em_names = em_names, dm_names = dm_names, 
                         commodities_names = commodities_names)
list_asset_codes <- list(index = index, em = em, dm = dm, commodities = commodities)


# Get data from Yahoo Finance
for(i in 1:length(list_asset_names)){
  # each single asset of the mix, length(list_asset_codes[[1]]) is hard-coded -> bad!
  for(j in 1:length(list_asset_codes[[1]])){
    # get all data from yahoo finance
    getSymbols(list_asset_codes[[i]][j], src="yahoo")
  }
}




# Vertical barchart
sectors_names <- c("IT", "Health_Care", "Financials", "Cons_Discr", "Cons_Stapl", "Communications",
                   "Industrials", "Energy", "Utilities", "Real_Estate", "Materials")
sectors <- c("QQQ", "XLV", "XLF", "XLY", "XLP", "VOX", "XLI", "XLE", "XLU", "VNQ", "XLB")


# for vertical bar chart
getSymbols(sectors)
dataprep_sectors(sectors)


#### Data Preparation

# select relevant data
df_btc <- filter(cryptos_1, name == "Bitcoin") %>% select(1,10)

# only keep the day date without time
df_btc$timestamp <- substr(df_btc$timestamp,1,10) %>% as.Date()

# Bitcoin monthly return (quantmod requires xts)
btc <- xts(x = df_btc$close, order.by = df_btc$timestamp)
monthly_return_btc <- monthlyReturn(btc) %>% as.data.frame()
monthly_return_btc$timestamp <- format(as.Date(rownames(monthly_return_btc)), format = "%Y-%m")

# Bitcoin daily return 
daily_return_btc <- dailyReturn(btc) %>% as.data.frame()
daily_return_btc$timestamp <- format(as.Date(rownames(daily_return_btc)), format = "%Y-%m-%d")


