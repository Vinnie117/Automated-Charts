########## MASTER FILE ##########

# to generate all monthly charts automatically

# load data
source("Code/Data Input.R")


# Bitcoin: Generate heatmap of monthly returns
source("Code/Analysis_heatmap.R")
plot_heatmap

# Bitcoin: Generate stock to flow
source("Code/Analysis_stock_to_flow.R")
plot_price_halvings
plot_s2f

# Bitcoin: Generate market dominance
source("Code/Analysis_market_dominance.R")

# Economics: USD M2 money supply
source("Code/Analysis_usd_m2.R")
plot_m2


########################################
# To do

# Add data input of bitcoin market dominance
# 
# - in data input: rename "coins" to "list_coins"
# - specify origin for each analysis -> input for crypto_history
#   but where? here in master file? in each Analysis file? or in data input?
#   -> probably best in data input, makes the most sense?
#   -> build a funtion for it?







