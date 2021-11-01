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
plot_market_dominance

# Economics: USD M2 money supply
source("Code/Analysis_usd_m2.R")
plot_m2







