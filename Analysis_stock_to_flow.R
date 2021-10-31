################ Stock to Flow analysis of Bitcoin ###################


######## Variables
# Adjustment to be set manually
# - "halvings" -> the dates must be add manually
# - "future_dates" -> the dates must be further away than the last halving date  (length argument)
#                  -> this controls length of the data frame, hence, time window in the plot
# - "months2halvings" -> row indices after variable definition are manually set

# -> not very stable as dates are hard coded -> need to change that!



######## Data Preparation

# only keep month-end for monthly data
eom <- seq(as.Date("2013-05-1"),length=1000,by="months")-1
df <- df_btc %>% filter(timestamp %in% eom)

# halving dates -> guess an estimate for the halving in 2024
halvings <- as.Date(c("2016-07-09", "2020-05-11", "2024-06-15"))
# end of month prior to halving date should be 0 "months2halving"
halving_month_prior <- floor_date(halvings, unit = "month") - 1

# expand the data frame by future dates that have no price history yet
last_date_with_price <- as.data.frame(df)
last_date_with_price <- last_date_with_price[nrow(last_date_with_price),1] 
future_dates <- seq(last_date_with_price+1, length=40, by="months")-1
future_dates <- future_dates[-1]

future <- data.frame(timestamp = future_dates, close = NA)

# combine both data frames
df <- rbind(df, future)


#### Dealing with months to halvings 
# create months to halvings
df$months2halvings <- ifelse(df$timestamp %in% halving_month_prior, 0, NA)

# months to first halving
df[c(1:38),3] <- seq(which(df$timestamp == halving_month_prior[1]) - 1, 1)

# months to second halving
df[c(40:84), 3] <- seq(which(df$timestamp == halving_month_prior[2]) - which(df$timestamp == halving_month_prior[1]) -1, 1)

# months to third halving
df[c(86:133), 3] <- seq(which(df$timestamp == halving_month_prior[3]) - which(df$timestamp == halving_month_prior[2]) -1, 1)


#### Adding past data to make moving average longer
past_dates <- seq(ymd('2012-03-01'),ymd('2013-04-1'), by = '1 month') -1
past <- data.frame(timestamp = past_dates, close = NA, months2halvings = NA)
df <- rbind(past, df)



######## s2F Model
#### Calculate S2F Ratio

# Query data from Bitcoin node? -> is ex-post -> for the future, theoretic production has to be used anyways
# Or use theoretic values? -> data is consistent with one time point of view (from past to future)

# Theoretic calculations
# 10 minutes = 1 Block -> 1 hour = 6 blocks -> 1 day = 144 blocks -> 1 month (30 days) = 4,320 blocks
#
#
# 1. Halving: 2012-11-28 -> Monthly data: 2012-11-30 to 2016-05-31
# block reward = 25 BTC per block -> 144*25 = 3,600 BTC per day -> *365 -> 1,314,000 BTC per year
# -> 109500 BTC per month

# 2. Halving: 2016-07-09 -> Monthly data: 2016-06-30 to 2020-04-30
# block reward = 12.5 BTC per block -> 144*12.5 = 1,800 BTC per day -> *365 -> 657,000 BTC per year
# -> 54750 BTC per month
#
# 3. Halving 2020-05-11 -> Monthly data: 2020-05-31 to 2024-05-31 (est.)
# block reward = 6.25 BTC per block -> 144*6.25 = 900 BTC per day -> *365 -> 328,500 BTC per year
# -> 27375 BTC per month
#
# 4. Halving 2020-06-30 to 2028-05-31 (est.)
# block reward = 23.125 BTC per block -> 144*3.125 = 450 BTC per day -> *365 -> 164250 BTC per year
# -> 13687.5 BTC per month


# Flow: yearly production -> rolling? or annualized? -> annualized! (daily value*365)
# Stock on 2012-02-29 = 8,427,000 (https://www.blockchain.com/charts/total-bitcoins)

df <- df %>% mutate(monthly_supply_increase = case_when(
  timestamp <= as.Date("2012-11-30") ~ 219000,
  timestamp <= as.Date("2016-06-30") & timestamp >= as.Date("2012-12-31") ~ 109500,
  timestamp <= as.Date("2020-04-30") & timestamp >= as.Date("2016-07-31") ~ 54750,
  timestamp <= as.Date("2024-05-31") & timestamp >= as.Date("2020-05-31") ~ 27375,
  timestamp <= as.Date("2028-05-31") & timestamp >= as.Date("2024-06-30") ~ 13687.5))

df <- df %>% mutate(flow = case_when(
  timestamp <= as.Date("2012-11-30") ~ 2628000,
  timestamp <= as.Date("2016-06-30") & timestamp >= as.Date("2012-12-31") ~ 1314000,
  timestamp <= as.Date("2020-04-30") & timestamp >= as.Date("2016-07-31") ~ 657000,
  timestamp <= as.Date("2024-05-31") & timestamp >= as.Date("2020-05-31") ~ 328500,
  timestamp <= as.Date("2028-05-31") & timestamp >= as.Date("2024-06-30") ~ 164250))

df <- df %>% mutate(stock = cumsum(monthly_supply_increase) + 8427000)

df$s2f <- df$stock / df$flow


#### 15 month moving average of S2F

# https://stats.buybitcoinworldwide.com/stock-to-flow/
# https://medium.com/geekculture/bitcoin-stock-to-flow-model-80beacc344b

# function for moving average
ma <- function(x, n){stats::filter(x, rep(1 / n, n), sides = 1)}
df$s2f_15m <- ma(df$s2f, n = 15)

df <- df %>% filter(timestamp >= as.Date("2013-04-30"))


# best model so far? model price = exp^(-1.84) * S2F^3.36
df$s2f_price2_15m <- exp(-1.84)*df$s2f_15m^3.36


# Visualization
plot_price_halvings <- ggplot(data = df, aes(x = timestamp, y = close, color = months2halvings))+
  geom_point(size = 2) +
  theme(legend.position="bottom") +
  labs(color = "Months until next halving", x = "Time", y = "Price in USD",
       title = "Bitcoin: Price and Halving - End of Month", caption = "Data: www.coinmarketcap.com") +
  scale_y_continuous(limits = c(100, 10000000),
                     breaks = c(10, 100, 1000, 10000, 100000, 1000000, 10000000),
                     labels = c("10", "100","1,000", "10,000", "100,000", "1,000,000", "10,000,000"),
                     trans='log10') +
  scale_x_continuous(breaks = seq(ymd('2013-01-01'),ymd('2025-01-01'), by = '1 year'),
                     labels = as.character(c(2013:2025))) +
  scale_color_gradientn(colours = c("red", "yellow", "green", "blue"), trans = 'reverse') +
  theme(legend.key.width = unit(5, 'cm'))



plot_s2f <- plot_price_halvings +
  geom_line(data = df, aes(x=timestamp, y=s2f_price2_15m), color = "black", size = 1.2) +
  labs(color = "Months until next halving", x = "Time", y = "Price in USD",
       title = "Bitcoin: Stock-to-Flow Price Model",
       subtitle = "Monthly data, S2F 15m rolling mean" ,
       caption = "Model by PlanB (@100trillionUSD) \n Data: www.coinmarketcap.com")







